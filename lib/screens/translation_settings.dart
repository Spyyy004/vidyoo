import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/translation_success.dart';
import 'package:vidyoo/screens/upload.dart';
import '../services/translation_service.dart';
import '../utils/consts.dart';
import 'dart:html' as html;

class TranslationSetupScreen extends StatefulWidget {
  final dynamic videoFile;
  final dynamic videoUrl;

  const TranslationSetupScreen({
    super.key,
    required this.videoFile,
    required this.videoUrl
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
  final Map<String, String> languageCodes = {
    'Marathi': 'mr',
    'Gujarati': 'gu',
    'Tamil': 'ta',
    'Malayalam': 'ml',
    'Japanese': 'ja',
    'Bengali': 'bn',
    'Chinese (Mandarin)': 'zh',
    'Hindi': 'hi',
    'Telugu': 'te',
    'Marwari': 'mwr', // Note: Marwari does not have an ISO 639-1 code, so 'mwr' is an ISO 639-3 code
    'Spanish': 'es',
    'French': 'fr',
  };
  bool isVideoProcess = false;

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

  Future<void> _startTranslation() async {

    setState(() {
       isVideoProcess = true;
    });

    try {
      final translationService = TranslationService();
      dynamic videoUrl;
      print(widget.videoUrl);
      if(widget.videoUrl != "") {
         videoUrl = await translationService.translateVideo(
          videoUrl: widget.videoUrl,
          targetLanguage: languageCodes[selectedLanguage] ?? '',
          ageCategory: '18-25',
          subtitleCategory: 'none' ?? '',
          voiceCategory: 'ai' ?? '',
        );
      }
      else{
        videoUrl = await translationService.translateVideoUpload(
          videoFile: widget.videoFile,
          targetLanguage: languageCodes[selectedLanguage] ?? '',
          ageCategory: '18-25',
          subtitleCategory: 'none' ?? '',
          voiceCategory: 'ai' ?? '',
        );
      }
      print(videoUrl);
      if (mounted) {
        setState(() {
          isVideoProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TranslationResultScreen(
              videoData: videoUrl,
              settings: {
                'targetLanguage': selectedLanguage ?? '',
                'ageCategory': '18-25' ?? '',
                'subtitleCategory': 'none' ?? '',
                'voiceCategory': 'ai' ?? '',
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isVideoProcess = false;
        });
      }
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
      body: isVideoProcess ? Center(
          child: LottieBuilder.network(
              width: 400,
              height: 400,
              "https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json")
      ) : Row(
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

  // In your TranslationSetup page

}