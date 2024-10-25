import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/smart_edit_result.dart';
import 'package:vidyoo/screens/upload.dart';
import '../services/openai_service.dart';
import '../utils/consts.dart';
import 'dart:html' as html;
class SmartEditSetup extends StatefulWidget {
  final dynamic videoFile;

  const SmartEditSetup({
    super.key,
    required this.videoFile,
  });

  @override
  State<SmartEditSetup> createState() => _SmartEditSetupState();
}

class _SmartEditSetupState extends State<SmartEditSetup> {
  final TextEditingController _commandController = TextEditingController();
  String? selectedCommand;
  bool generateSocialFormats = false;
  bool addCaptions = false;
  bool addBackgroundMusic = false;
  bool exportHighQuality = false;
  late VideoPlayerController videoPlayerController;
  // Predefined commands for quick selection
  final List<String> suggestedCommands = [
    'Extract all product demonstrations',
    'Find customer testimonials',
    'Create social media highlights',
    'Capture moments with laughter',
    'Find all mentions of pricing',
    'Extract tutorial sections',
  ];
  final OpenAIService _openAIService = OpenAIService();
  bool _isProcessing = false;
  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {

    final blob = html.Blob([widget.videoFile]);
    final file = html.File([blob], "myfile");
    final url = html.Url.createObjectUrlFromBlob(file);

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await videoPlayerController.initialize();
      videoPlayerController.play();
      setState(() {

      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Video Preview
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 270,
                      child: AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Original Video',
                      style: VidyooTheme.bodyLarge.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Smart Edit Controls
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text('Smart Edit', style: VidyooTheme.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us what you want to extract from your video',
                    style: VidyooTheme.bodyLarge.copyWith(
                      color: VidyooTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Command Input
                  Text('What do you want?', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _commandController,
                    decoration: InputDecoration(
                      hintText: "Remove all unwanted pauses",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 32),

                  // Suggested Commands
                  Text('Suggested Commands', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: suggestedCommands.map((command) {
                      return _buildCommandChip(command);
                    }).toList(),
                  ),
                  const SizedBox(height: 48),

                  // Output Settings
                  Text('Output Settings', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  _buildSettingsUI(),

                  const Spacer(),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _commandController.text.isNotEmpty
                            ? (_isProcessing ? null : _startProcessing)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VidyooTheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isProcessing)
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            else ...[
                              const Text(
                                'Start Processing',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandChip(String command) {
    final isSelected = selectedCommand == command;

    return ChoiceChip(
      label: Text(command),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedCommand = selected ? command : null;
          if (selected) {
            _commandController.text = command;
          }
        });
      },
      labelStyle: VidyooTheme.bodyDefault.copyWith(
        color: isSelected ? Colors.white : VidyooTheme.textDark,
      ),
      backgroundColor: Colors.white,
      selectedColor: VidyooTheme.primary,
      side: BorderSide(
        color: isSelected
            ? VidyooTheme.primary
            : VidyooTheme.textSecondary.withOpacity(0.2),
      ),
    );
  }
  Widget _buildSettingsUI() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: VidyooTheme.textSecondary.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
      ),
      child: Column(
        children: [
          _buildSettingOption(
            title: 'Generate Social Media Formats',
            subtitle: 'Create versions for Instagram, TikTok, YouTube Shorts',
            icon: Icons.aspect_ratio,
            value: generateSocialFormats,
            onChanged: (value) {
              setState(() {
                generateSocialFormats = value!;
              });
            },
          ),
          _buildDivider(),
          _buildSettingOption(
            title: 'Add Auto Captions',
            subtitle: 'Generate and embed captions in the video',
            icon: Icons.closed_caption,
            value: addCaptions,
            onChanged: (value) {
              setState(() {
                addCaptions = value!;
              });
            },
          ),
          _buildDivider(),
          _buildSettingOption(
            title: 'Limit Output',
            subtitle: 'Limit output video to 60 seconds',
            icon: Icons.music_note,
            value: addBackgroundMusic,
            onChanged: (value) {
              setState(() {
                addBackgroundMusic = value!;
              });
            },
          ),
          _buildDivider(),
          _buildSettingOption(
            title: 'Export as High Quality',
            subtitle: '1080p or above resolution',
            icon: Icons.high_quality,
            value: exportHighQuality,
            onChanged: (value) {
              setState(() {
                exportHighQuality = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VidyooTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: VidyooTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: VidyooTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: VidyooTheme.bodySmall.copyWith(
                      color: VidyooTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: VidyooTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: VidyooTheme.textSecondary.withOpacity(0.1),
    );
  }

  Future<void> _startProcessing() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Show transcription status
      _showProcessingStatus('Generating video transcription...');

      // Step 1: Generate transcription
      final transcription = await _openAIService.generateTranscription(
        widget.videoFile,
      );

      if (!mounted) return;
      print(transcription);
      print("STEP 1-----");
      // Show analysis status
      _showProcessingStatus('Analyzing content...');

      // Step 2: Analyze transcription
      // final settings = {
      //   'generateSocialFormats': generateSocialFormats,
      //   'addCaptions': addCaptions,
      //   'limitOutput': addBackgroundMusic,
      //   'exportHighQuality': exportHighQuality,
      // };

      final analysis = await _openAIService.analyzeTranscription(
        transcription: transcription,
        command: _commandController.text,

      );
      print(analysis);
      print("STEP 2-----");
      if (!mounted) return;

      // Convert to strongly-typed object
      // final instructions = VideoEditingInstructions.fromJson(analysis);

      // Navigate to processing screen
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoSegmentsScreen(
              segments: analysis['actions'],
              videoFile: widget.videoFile,
            )),
          );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _startProcessing,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showProcessingStatus(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 60),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}








