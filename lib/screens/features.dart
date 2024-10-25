import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyoo/screens/landing_screen.dart';
import 'package:vidyoo/screens/upload.dart';

import '../utils/consts.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  static const double kMobileBreakpoint = 600;
  static const double kTabletBreakpoint = 1024;

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  late VideoPlayerController videoPlayerController;
  late VideoPlayerController videoPlayerController2;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
   initializeVideo();
  }

  Future<void> initializeVideo() async {
    videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse("https://cdn.pixabay.com/video/2020/01/05/30902-383991325_large.mp4"));
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse("https://videos.pexels.com/video-files/19345257/19345257-sd_640_360_30fps.mp4"));
    try {
      await videoPlayerController.initialize();
      await videoPlayerController2.initialize();
      videoPlayerController.play();
      videoPlayerController2.play();
      setState(() {

      });
    } catch (e) {
      print('Error initializing video: $e');
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildNavBar(context),
                // _buildHeader(constraints.maxWidth),
                _buildTranslationFeature(constraints.maxWidth),
                _buildSmartEditFeature(constraints.maxWidth),
                _buildComparisonSection(constraints.maxWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){return LandingPage();}))
;            },
            child: Row(
              children: [
                Icon(Icons.play_circle_filled, color: VidyooTheme.primary, size: 32),
                const SizedBox(width: 8),
                Text('vidyoo', style: VidyooTheme.h3.copyWith(color: VidyooTheme.primary)),
              ],
            ),
          ),
          const Spacer(),
          if (!isMobile) _buildDesktopMenu(),
          if (isMobile) _buildMobileMenuButton(context),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return FeaturesPage();
          }));
        },
        child: Text(
          title,
          style: VidyooTheme.bodyDefault.copyWith(color: VidyooTheme.textDark),
        ),
      ),
    );
  }

  Widget _buildDesktopMenu() {
    return Row(
      children: [
        _buildNavItem('Features'),
        _buildNavItem('How it Works'),
        _buildNavItem('Pricing'),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UploadPage();
            }));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: VidyooTheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
            ),
          ),
          child: Text('Try Now', style: VidyooTheme.buttonText.copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu, color: VidyooTheme.primary),
      onPressed: () {
        // Open drawer or bottom sheet for mobile menu
      },
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth <= FeaturesPage.kMobileBreakpoint ? 40 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            VidyooTheme.primary.withOpacity(0.1),
            VidyooTheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Features',
            style: VidyooTheme.h1.copyWith(
              color: VidyooTheme.textDark,
              fontSize: screenWidth <= FeaturesPage.kMobileBreakpoint ? 36 : 48,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: screenWidth <= FeaturesPage.kMobileBreakpoint
                ? screenWidth * 0.9
                : screenWidth * 0.6,
            child: Text(
              'Transform your video content with our powerful AI features',
              style: VidyooTheme.bodyLarge.copyWith(
                color: VidyooTheme.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationFeature(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 64,
      ),
      child: Wrap(
        spacing: 48,
        runSpacing: 48,
        alignment: WrapAlignment.center,
        children: [
          // Feature Description
          Container(
            width: screenWidth <= FeaturesPage.kTabletBreakpoint
                ? screenWidth * 0.9
                : screenWidth * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureLabel('VIDEO TRANSLATION'),
                const SizedBox(height: 16),
                Text(
                  'Break Language Barriers',
                  style: VidyooTheme.h2,
                ),
                const SizedBox(height: 24),
                _buildFeaturePoint(
                  'Voice Preservation',
                  'Maintain the original speaker\'s voice while translating to any language',
                  Icons.record_voice_over,
                ),
                _buildFeaturePoint(
                  'Multiple Languages',
                  'Support for 50+ languages with native accents',
                  Icons.language,
                ),
                _buildFeaturePoint(
                  'Subtitle Options',
                  'Choose between burned-in captions or separate SRT files',
                  Icons.subtitles,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VidyooTheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'Try Translation',
                    style: VidyooTheme.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Feature Demo
          Container(

            height: 400,
            decoration: BoxDecoration(
              color: VidyooTheme.surface,
              borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
              border: Border.all(
                color: VidyooTheme.textSecondary.withOpacity(0.1),
              ),
            ),
            child: AspectRatio(
              aspectRatio: videoPlayerController2.value.aspectRatio,
              child: VideoPlayer(videoPlayerController2),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSmartEditFeature(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 64,
      ),
      color: VidyooTheme.surface,
      child: Wrap(
        spacing: 48,
        runSpacing: 48,
        alignment: WrapAlignment.center,
        children: [
          // Feature Demo (reversed order on desktop)
          if (screenWidth > FeaturesPage.kTabletBreakpoint)
            Container(

              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
                border: Border.all(
                  color: VidyooTheme.textSecondary.withOpacity(0.1),
                ),
              ),
              child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              )
            ),

          // Feature Description
          Container(
            width: screenWidth <= FeaturesPage.kTabletBreakpoint
                ? screenWidth * 0.9
                : screenWidth * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureLabel('SMART EDIT'),
                const SizedBox(height: 16),
                Text(
                  'Edit with Natural Language',
                  style: VidyooTheme.h2,
                ),
                const SizedBox(height: 24),
                _buildFeaturePoint(
                  'Natural Commands',
                  'Simply describe what you want to extract or edit',
                  Icons.psychology,
                ),
                _buildFeaturePoint(
                  'Smart Detection',
                  'Automatically detect specific moments, emotions, and actions',
                  Icons.auto_awesome,
                ),
                _buildFeaturePoint(
                  'Quick Export',
                  'Export edited clips in various formats and resolutions',
                  Icons.movie_filter,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VidyooTheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'Try Smart Edit',
                    style: VidyooTheme.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Feature Demo (on mobile and tablet)
          if (screenWidth <= FeaturesPage.kTabletBreakpoint)
            Container(
              width: screenWidth * 0.9,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
                border: Border.all(
                  color: VidyooTheme.textSecondary.withOpacity(0.1),
                ),
              ),
              child: Center(
                child: Text('Smart Edit Demo Placeholder'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 64,
      ),
      child: Column(
        children: [
          Text(
            'Compare Features',
            style: VidyooTheme.h2,
          ),
          const SizedBox(height: 48),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Feature')),
                DataColumn(label: Text('Translation')),
                DataColumn(label: Text('Smart Edit')),
              ],
              rows: [
                _buildComparisonRow(
                  'Processing Time',
                  '2-5 minutes',
                  '1-3 minutes',
                ),
                _buildComparisonRow(
                  'Output Formats',
                  'MP4, MOV',
                  'All formats',
                ),
                _buildComparisonRow(
                  'Max Duration',
                  '60 minutes',
                  '120 minutes',
                ),
                _buildComparisonRow(
                  'Additional Files',
                  'SRT, Transcript',
                  'Timestamps',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildComparisonRow(String feature, String translation, String smartEdit) {
    return DataRow(
      cells: [
        DataCell(Text(feature)),
        DataCell(Text(translation)),
        DataCell(Text(smartEdit)),
      ],
    );
  }

  Widget _buildFeatureLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: VidyooTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(VidyooTheme.radiusS),
      ),
      child: Text(
        label,
        style: VidyooTheme.bodySmall.copyWith(
          color: VidyooTheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturePoint(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              size: 24,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: VidyooTheme.bodyDefault.copyWith(
                    color: VidyooTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}