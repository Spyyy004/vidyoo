import 'dart:html' as html;

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/smart_edit.dart';
import 'package:vidyoo/screens/translation_settings.dart';
import 'package:vidyoo/utils/consts.dart';

class VideoFile {
  final dynamic file; // Can be File or html.File
  final String name;
  final String type;

  VideoFile({
    required this.file,
    required this.name,
    required this.type,
  });
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  VideoFile? selectedVideo;
  bool isDragging = false;
  bool isVideoInitialized = false;
  late VideoPlayerController videoPlayerController;
  bool isUrlMode = false;
  final TextEditingController _urlController = TextEditingController();
  bool isLoadingUrl = false;
  String? urlError;
  dynamic videoBytes;
  @override

  void initState() {
    super.initState();
  }

  Future<void> _initializeVideo(String url) async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await videoPlayerController.initialize();
      videoPlayerController.play();

      setState(() {
        isVideoInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedVideo == null) _buildUploadArea() else
              _buildVideoPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: VidyooTheme.surface,
            borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton(
                'Upload Video',
                Icons.upload_file,
                !isUrlMode,
                    () => setState(() => isUrlMode = false),
              ),
              _buildToggleButton(
                'Video URL',
                Icons.link,
                isUrlMode,
                    () => setState(() => isUrlMode = true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      isUrlMode ? _buildUrlInput() :   GestureDetector(
          onTap: _pickVideo,
          child: Container(
            width: 600,
            height: 400,
            decoration: BoxDecoration(
              color: isDragging ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDragging ? Colors.blue : Colors.grey.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: Colors.blue,
                ),
                SizedBox(height: 24),
                Text('Drag and drop your video here',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 12),
                Text('or click to browse',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(height: 24),
                Text('Supported formats: MP4, MOV, AVI\nMax file size: 500MB',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.movie_outlined, color: VidyooTheme.primary),
              const SizedBox(width: 8),
              Text('sample.mp4', style: TextStyle(fontSize: 16)),
            ],
          )
        ,
SizedBox(height: 8,),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController)
            ),),
          const SizedBox(height: 24),
          // Center(
          //   child: IconButton(
          //     icon: Icon(
          //         videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow
          //     )
          //     ,
          //     onPressed: (){
          //       videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
          //       setState(() {
          //
          //       });
          //     },
          //   ),
          // )
          Center(
            child: TextButton(
              onPressed: _pickVideo,
              child: const Text('Choose Different Video'),
            ),
          ),
          const SizedBox(height: 32),
          Text('What would you like to do with this video?',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureButton('Translate Video', Icons.translate, () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return TranslationSetupScreen(videoFile: videoBytes,videoUrl: _urlController.text,);
                }));
              }),
              const SizedBox(width: 16),
              _buildFeatureButton('Smart Edit', Icons.auto_awesome, () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SmartEditSetup(videoFile: videoBytes);
                }));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      String text,
      IconData icon,
      bool isSelected,
      VoidCallback onPressed
      ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ] : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? VidyooTheme.primary
                      : VidyooTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: VidyooTheme.bodyDefault.copyWith(
                    color: isSelected
                        ? VidyooTheme.primary
                        : VidyooTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlInput() {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: VidyooTheme.surface,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        border: Border.all(
          color: VidyooTheme.textSecondary.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'Paste video URL here...',
              errorText: urlError,
              prefixIcon: const Icon(Icons.link),
              suffixIcon: _urlController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _urlController.clear();
                  setState(() {
                    urlError = null;
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
              ),
            ),
            onChanged: (value) {
              setState(() {
                urlError = null;
              });
              // if (urlError != null) {
              //   setState(() {
              //     urlError = null;
              //     print(_urlController.text);
              //   });
              //
              // }
            },
            onEditingComplete: (){
              if (urlError != null) {
                setState(() {
                  urlError = null;
                  print(_urlController.text);
                });

              }
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _urlController.text.isNotEmpty
                  ? () => _loadVideoFromUrl(_urlController.text)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: VidyooTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
                ),
              ),
              child: isLoadingUrl
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                'Load Video',
                style: VidyooTheme.buttonText.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Supported platforms: YouTube, Vimeo, etc.',
            style: VidyooTheme.bodySmall.copyWith(
              color: VidyooTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadVideoFromUrl(String url) async {
    setState(() {
      isLoadingUrl = true;
      urlError = null;
    });

    try {
      // Validate URL
      final uri = Uri.parse(url);
      if (!uri.hasScheme) {
        throw 'Invalid URL';
      }

      // Initialize video player with URL
      await _initializeVideo(url);

      setState(() {
        selectedVideo = VideoFile(
          file: url,
          name: 'Online Video',
          type: 'url',
        );
      });
    } catch (e) {
      setState(() {
        urlError = 'Invalid video URL';
      });
    } finally {
      setState(() {
        isLoadingUrl = false;
      });
    }
  }


  Widget _buildFeatureButton(String title, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color:VidyooTheme.primary),
          const SizedBox(width : 12),
          Text(title, style: VidyooTheme.bodyDefault),
        ],
      ),
    );
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (kIsWeb) {
      final bytes = result?.files.first.bytes!;
      videoBytes = bytes;
      final blob = html.Blob([bytes]);
      final file = html.File([blob], "myfile");
      final url = html.Url.createObjectUrlFromBlob(file);

      setState(() {
        selectedVideo = VideoFile(
          file: file,
          name: result!.files.first.name,
          type: result.files.first.extension ?? 'video',
        );
      });
      await _initializeVideo(url);
    }

  }
}

