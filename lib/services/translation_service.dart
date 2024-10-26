import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String baseUrl = 'http://10.1.131.177:8000';

  Future<Uint8List> translateVideo({
    required String videoUrl,

    required String targetLanguage,
    required String ageCategory,
    required String subtitleCategory,
    required String voiceCategory,
  }) async {
    try {
      print(videoUrl);
      final response = await http.post(
        Uri.parse('$baseUrl/video/translate/url'),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control_Allow_Origin": "*"
        },
        body: jsonEncode({
          'type': 'url',
          'typeData': videoUrl,
          'targetLanguage': targetLanguage,
          'ageCategory': ageCategory,
          'subtitleCategory': subtitleCategory,
          'voiceCategory': voiceCategory,
          'sourceLanguage':'en'
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a video URL in the response
        print(response);
        return response.bodyBytes; // Adjust based on actual response structure
      } else {
        throw 'Translation failed: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error translating video: $e';
    }
  }

  Future<Uint8List> translateVideoUpload({
    required Uint8List videoFile,  // Renamed from videoUrl to videoFile for clarity
    required String targetLanguage,
    required String ageCategory,
    required String subtitleCategory,
    required String voiceCategory,
  }) async {
    try {
      print(targetLanguage);
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/video/translate/upload'));
      request.headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
        'content-type':'multipart/form-data'
      });
      print(request.headers);
      // Add the file
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',  // field name that server expects
          videoFile,
            // Added filename
        ),
      );

      // Add other fields
      request.fields.addAll({
        'targetLanguage': targetLanguage,
        'ageCategory': ageCategory,
        'subtitleCategory': subtitleCategory,
        'voiceCategory': voiceCategory,
      });

      // Send the request
      final streamedResponse = await request.send();
      print(streamedResponse);
      // Get the response as bytes
      final response = await http.Response.fromStream(streamedResponse);
      print(response);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Error Response: ${response.body}');  // Log error response
        throw 'Translation failed: ${response.statusCode}';
      }
    } catch (e) {
      print('Error details: $e');  // Log error details
      throw 'Error translating video: $e';
    }
  }
}
