import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/dashboard.dart';
import 'package:vidyoo/screens/sign_up_prompt.dart';
import 'package:vidyoo/screens/upload.dart';
import 'dart:html' as html;
import '../utils/consts.dart';

// screens/translation_result_screen.dart
class TranslationResultScreen extends StatefulWidget {
  final Uint8List videoData;
  final Map<String, String> settings;

  const TranslationResultScreen({
    super.key,
    required this.videoData,
    required this.settings,
  });

  @override
  State<TranslationResultScreen> createState() => _TranslationResultScreenState();
}

class _TranslationResultScreenState extends State<TranslationResultScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final blob = html.Blob([widget.videoData]);
      _videoUrl = html.Url.createObjectUrlFromBlob(blob);
      _controller = VideoPlayerController.network(_videoUrl!);
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _downloadVideo() {
    if(userCredential == null){
      showDialog(context: context, builder: (context){
        return AlertDialog(content: SignUpPrompt(videoPreviewUrl: '',),);
      }).then((value){
        if(value){
          final blob = html.Blob([widget.videoData]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'translated_video.mp4')
            ..click();
          html.Url.revokeObjectUrl(url);
          Navigator.push(context, MaterialPageRoute(builder: (context){return DashboardPage();}));
        }
      });
    }
    else{
      final blob = html.Blob([widget.videoData]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'translated_video.mp4')
        ..click();
      html.Url.revokeObjectUrl(url);
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    if (_videoUrl != null) {
      html.Url.revokeObjectUrl(_videoUrl!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 12),
            Text(
              'Translation Complete',
              style: VidyooTheme.h4.copyWith(color: VidyooTheme.primary),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          // Left Column - Video
          Expanded(
            flex: 2,
            child: Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: VidyooTheme.h3.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: !_isInitialized
                            ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                VidyooTheme.primary),
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                              // Play/Pause Overlay
                              AnimatedOpacity(
                                opacity:
                                _controller.value.isPlaying ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 200),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 64,
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPlaying = !_isPlaying;
                                        if (_isPlaying) {
                                          _controller.play();
                                        } else {
                                          _controller.pause();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // Video Progress
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        colors: VideoProgressColors(
                                          playedColor: VidyooTheme.primary,
                                          bufferedColor:
                                          Colors.white.withOpacity(0.5),
                                          backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ValueListenableBuilder(
                                        valueListenable: _controller,
                                        builder: (context,
                                            VideoPlayerValue value, child) {
                                          return Text(
                                            '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                                            style: VidyooTheme.bodySmall
                                                .copyWith(
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Column - Info & Actions
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translation Settings',
                    style: VidyooTheme.h3,
                  ),
                  SizedBox(height: 24),
                  _buildSettingItem(
                    'Target Language',
                    widget.settings['targetLanguage'] ?? '',
                    Icons.language,
                  ),
                  _buildSettingItem(
                    'Age Category',
                    widget.settings['ageCategory'] ?? '',
                    Icons.people,
                  ),
                  _buildSettingItem(
                    'Subtitle Type',
                    widget.settings['subtitleCategory'] ?? '',
                    Icons.subtitles,
                  ),
                  _buildSettingItem(
                    'Voice Type',
                    widget.settings['voiceCategory'] ?? '',
                    Icons.record_voice_over,
                  ),
                  SizedBox(height: 48),

                  // Action Buttons
                  Text(
                    'Actions',
                    style: VidyooTheme.h3,
                  ),
                  SizedBox(height: 24),
                  _buildActionButton(
                    'Download Video',
                    Icons.download,
                    VidyooTheme.primary,
                    _downloadVideo,
                  ),
                  SizedBox(height: 16),
                  _buildActionButton(
                    'Create New Translation',
                    Icons.add,
                    Colors.green,
                        () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VidyooTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: VidyooTheme.textSecondary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VidyooTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: VidyooTheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: VidyooTheme.bodySmall.copyWith(
                    color: VidyooTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: VidyooTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Text(
              title,
              style: VidyooTheme.buttonText.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}