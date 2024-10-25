import 'dart:typed_data';
import 'package:http/http.dart' as http;
Future<Uint8List?> fetchVideo() async {
  final response = await http.get(Uri.parse('http://10.1.131.177:8000/video/get'));

  if (response.statusCode == 200) {
    return response.bodyBytes;  // This returns the video data as bytes
  } else {
    // Handle error case
    print('Failed to load video');
    return null;
  }
}