import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/upload.dart';
import '../utils/consts.dart';
import 'dart:html' as html;

class TranslationSetupScreen extends StatefulWidget {
  final dynamic videoFile;

  const TranslationSetupScreen({
    super.key,
    required this.videoFile,
  });

  @override
  State<TranslationSetupScreen> createState() => _TranslationSetupScreenState();
}

class _TranslationSetupScreenState extends State<TranslationSetupScreen> {
  String? selectedLanguage;
  String? selectedVoiceOption;
  String? selectedSubtitleOption;
  String? selectedAccent;
  late VideoPlayerController videoPlayerController;

  final List<String> commonLanguages = [
    'Marathi', 'Gujarati', 'Tamil', 'Malayalam', 'Japanese',
    'Bengali', 'Chinese (Mandarin)', 'Hindi', 'Telugu',
    'Marwari','Spanish','French'
  ];

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
                    // Video player will go here
                    Container(

                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 270,

                      child: AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoPlayerController)
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

          // Right side - Settings
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text('Translation Settings', style: VidyooTheme.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Configure how you want your video to be translated',
                    style: VidyooTheme.bodyLarge.copyWith(
                      color: VidyooTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Language Selection
                  Text('Target Language', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...commonLanguages.map((lang) => _buildLanguageChip(lang)),

                    ],
                  ),
                  const SizedBox(height: 32),

                  // Voice Options
                  Text('Voice Settings', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  _buildOptionCards(
                    options: [
                      {
                        'title': 'Keep Original Voice',
                        'description': 'Overlay translated audio on original voice',
                        'icon': Icons.record_voice_over,
                      },

                      {
                        'title': 'AI Voice',
                        'description': 'Use high-quality AI voice',
                        'icon': Icons.smart_toy,
                      },
                    ],
                    selectedOption: selectedVoiceOption,
                    onSelect: (option) {
                      setState(() {
                        selectedVoiceOption = option;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Subtitle Options
                  Text('Subtitle Settings', style: VidyooTheme.h4),
                  const SizedBox(height: 16),
                  _buildOptionCards(
                    options: [
                      {
                        'title': 'No Subtitles',
                        'description': 'Audio translation only',
                        'icon': Icons.subtitles_off,
                      },
                      {
                        'title': 'Burned-in Captions',
                        'description': 'Permanent subtitles on video',
                        'icon': Icons.subtitles,
                      },
                      {
                        'title': 'Separate File',
                        'description': 'Generate .srt file',
                        'icon': Icons.file_present,
                      },
                    ],
                    selectedOption: selectedSubtitleOption,
                    onSelect: (option) {
                      setState(() {
                        selectedSubtitleOption = option;
                      });
                    },
                  ),

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
                        onPressed: _canProceed() ? _startTranslation : null,
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
                             Text('Start Translation',style: TextStyle(color: Colors.white ),),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 16, color: Colors.white,),
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

  Widget _buildLanguageChip(String language, {bool isMore = false}) {
    final isSelected = selectedLanguage == language;

    return ChoiceChip(
      label: Text(language),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedLanguage = selected ? language : null;
        });
      },
      labelStyle: VidyooTheme.bodyDefault.copyWith(
        color: isSelected ? Colors.white : VidyooTheme.textDark,
      ),
      backgroundColor: Colors.white,
      selectedColor: VidyooTheme.primary,
      side: BorderSide(
        color: isSelected ? VidyooTheme.primary : VidyooTheme.textSecondary.withOpacity(0.2),
      ),
    );
  }

  Widget _buildOptionCards({
    required List<Map<String, dynamic>> options,
    required String? selectedOption,
    required Function(String) onSelect,
  }) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: options.map((option) {
        final isSelected = selectedOption == option['title'];

        return GestureDetector(
          onTap: () => onSelect(option['title']),
          child: Container(
            width: 200,
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? VidyooTheme.primary.withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isSelected
                    ? VidyooTheme.primary
                    : VidyooTheme.textSecondary.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  option['icon'] as IconData,
                  color: isSelected ? VidyooTheme.primary : VidyooTheme.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  option['title'],
                  style: VidyooTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? VidyooTheme.primary : VidyooTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option['description'],
                  style: VidyooTheme.bodySmall.copyWith(
                    color: VidyooTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _canProceed() {
    return selectedLanguage != null &&
        selectedVoiceOption != null &&
        selectedSubtitleOption != null;
  }

  void _startTranslation() {
    // Proceed to processing screen
    Navigator.pushNamed(
      context,
      '/translate/processing',
      arguments: {
        'language': selectedLanguage,
        'voiceOption': selectedVoiceOption,
        'subtitleOption': selectedSubtitleOption,
        'accent': selectedAccent,
      },
    );
  }
}