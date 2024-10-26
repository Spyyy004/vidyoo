import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _apiKey = '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'; // Replace with your API key
  Future<Map<String, dynamic>> generateTranscription(List<int> videoBytes) async {
    try {
      // Create form data with the video file
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/audio/transcriptions'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $_apiKey',
      });

      // Add the video file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          videoBytes,
          filename: 'video.mp4',
        ),
      );

      // Add other required parameters
      request.fields['model'] = 'whisper-1';
      request.fields['response_format'] = 'verbose_json';
      request.fields['timestamp_granularities[]'] = 'word';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);

        // Validate response structure
        if (jsonResponse == null || jsonResponse is! Map<String, dynamic>) {
          print('Invalid response format: $responseData');
          throw 'Invalid transcription response format';
        }

        // Check if segments exist
        if (!jsonResponse.containsKey('words')) {
          print('No segments in response: $responseData');
          throw 'No segments found in transcription';
        }

        return jsonResponse;
      } else {
        print('API Error Response: $responseData');
        throw 'Transcription API Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Transcription error: $e');
      throw 'Failed to generate transcription: $e';
    }
  }
  // Step 2: Analyze transcription with GPT
  Future<Map<String, dynamic>> analyzeTranscription({
    required Map<String, dynamic> transcription,
    required String command,
  }) async {
    try {
      // First validate transcription format
      if (!transcription.containsKey('words')) {
        throw 'Invalid transcription format: missing segments';
      }

      final formattedTranscription = _formatTranscriptionForGPT(transcription);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a video editing assistant. 
                                  Analyze the provided video transcription and timestamp data to find relevant segments based on the user's request.
                                  Return ONLY a JSON response with timestamps for video editing.''',
            },
            {
              'role': 'user',
              'content': '''
Here is the video transcription with timestamps:
$formattedTranscription

Request: $command

Based on the transcription, identify the relevant segments and return ONLY a JSON in this format:
{
  "actions": [
    {
      "type": "extract",
      "startTime": "HH:mm:ss",
      "endTime": "HH:mm:ss",
      "description": "why this segment was selected"
    }
  ],
  "output_settings": {
    "format": "mp4"
  }
}
'''
            }
          ],
          'temperature': 0.7,

        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data.containsKey('choices') ||
            data['choices'] is! List ||
            data['choices'].isEmpty ||
            !data['choices'][0].containsKey('message') ||
            !data['choices'][0]['message'].containsKey('content')) {

          print('Invalid GPT response format: $data');
          throw 'Invalid response format from GPT';
        }

        final content = data['choices'][0]['message']['content'];
        print('GPT Response: $content');
        return _extractJsonFromResponse(content);
      } else {
        print('GPT API Error Response: ${response.body}');
        throw 'Analysis API Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Analysis error: $e');
      throw 'Failed to analyze transcription: $e';
    }
  }
  // Helper method to format transcription for GPT
  String _formatTranscriptionForGPT(Map<String, dynamic> transcription) {
    try {
      // Safely check if segments exist and is a List
      final segments = transcription['words'];
      if (segments == null || segments is! List) {
        print('Transcription format error: ${transcription.toString()}');
        throw 'Invalid transcription format';
      }

      return segments.map((segment) {
        // Safely extract start and end times
        final start = segment['start'];
        final end = segment['end'];
        final text = segment['word'];

        if (start == null || end == null || text == null) {
          print('Segment format error: ${segment.toString()}');
          throw 'Invalid segment format';
        }

        return '''
Timestamp: ${_formatSeconds(start.toDouble())} to ${_formatSeconds(end.toDouble())}
Text: $text
''';
      }).join('\n');
    } catch (e) {
      print('Error formatting transcription: $e');
      print('Raw transcription: $transcription');
      throw 'Failed to format transcription: $e';
    }
  }
  // Helper method to format seconds to HH:mm:ss
  String _formatSeconds(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }
  Future<Map<String, dynamic>> processVideoCommand({
    required String command,
    required Map<String, bool> settings,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a video editing assistant. Parse the user\'s request and return specific timestamps and actions for video editing.',
            },
            {
              'role': 'user',
              'content': '''
Process this video editing request:
Command: $command


Return the response in the following JSON format:
{
  "actions": [
    {
      "type": "extract" or "remove" or "modify",
      "startTime": "HH:mm:ss",
      "endTime": "HH:mm:ss",
      "description": "what to do with this segment"
    }
  ],
  "output_settings": {
    "format": "mp4",
    "quality": "1080p or specified",
    "aspect_ratio": "if social media formats requested"
  }
}
'''
            }
          ],
          'temperature': 0.7,

        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Extract and validate JSON from the content
        final parsedJson = _extractJsonFromResponse(content);

        // Validate the required fields
        if (!_isValidResponseFormat(parsedJson)) {
          throw FormatException('Invalid response format from API');
        }

        return parsedJson;
      } else {
        throw 'API Error: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Failed to process video: $e';
    }
  }


  Map<String, dynamic> _extractJsonFromResponse(String response) {
    try {
      // First attempt: Try to parse the entire response as JSON
      return jsonDecode(response);
    } catch (e) {
      try {
        // Second attempt: Find JSON within the text
        final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(response);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        }

        // If no JSON found, throw error
        throw FormatException('No valid JSON found in response');
      } catch (e) {
        throw FormatException('Failed to parse response: $e');
      }
    }
  }
  bool _isValidResponseFormat(Map<String, dynamic> json) {
    try {
      // Check if the response has the required structure
      if (!json.containsKey('actions') || !json.containsKey('output_settings')) {
        return false;
      }

      // Validate actions array
      final actions = json['actions'] as List;
      if (actions.isEmpty) return false;

      // Validate each action
      for (var action in actions) {
        if (action is! Map<String, dynamic>) return false;
        if (!action.containsKey('type') ||
            !action.containsKey('startTime') ||
            !action.containsKey('endTime') ||
            !action.containsKey('description')) {
          return false;
        }

        // Validate timestamp format
        final timeRegex = RegExp(r'^\d{2}:\d{2}:\d{2}$');
        if (!timeRegex.hasMatch(action['startTime']) ||
            !timeRegex.hasMatch(action['endTime'])) {
          return false;
        }
      }

      // Validate output settings
      final settings = json['output_settings'] as Map<String, dynamic>;
      if (!settings.containsKey('format') ||
          !settings.containsKey('quality')) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}