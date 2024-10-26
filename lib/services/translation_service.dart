import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:media_kit/media_kit.dart';
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
          'sourceLanguage':'en',

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
    required Uint8List videoFile,
    required String targetLanguage,
    required String ageCategory,
    required String subtitleCategory,
    required String voiceCategory,
  }) async {
    try {
      // Initialize Dio
      final dio = Dio();

      // Prepare FormData with file and additional fields
      final formData = FormData.fromMap({
        'files': MultipartFile.fromBytes(
          videoFile,
          filename: 'video.mp4',
            contentType: MediaType('video','mp4'),

        ),
        'targetLanguage': targetLanguage,
        'ageCategory': ageCategory,
        'subtitleCategory': subtitleCategory,
        'voiceCategory': voiceCategory,
      });

      // Send the request with onSendProgress to track progress
      final response = await dio.post(
        '$baseUrl/video/translate/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.bytes, // Ensures raw bytes are returned
        ),
        onSendProgress: (sent, total) {
          // Add progress tracking for large video files
          final progress = (sent / total * 100).toStringAsFixed(2);
          print('Upload progress: $progress%');
        },
      );

      // Check response and return the video blob if successful
      if (response.statusCode == 200) {
        print('Upload Successful');
        return response.data as Uint8List; // Ensure Uint8List is returned
      } else {
        print('Error Response: ${response.data}');
        throw 'Translation failed: ${response.statusCode}';
      }
    } catch (e) {
      print('Error details: $e');
      throw 'Error translating video: $e';
    }
  }

}
