import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyoo/screens/features.dart';
import 'package:vidyoo/screens/pricing.dart';
import 'package:vidyoo/screens/sign_up_prompt.dart';
import 'package:vidyoo/screens/upload.dart';
import '../utils/consts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavBar(context),
            _buildHeroSection(context),
            _buildFeaturesSection(context),
          ],
        ),
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
          Row(
            children: [
              Icon(Icons.play_circle_filled, color: VidyooTheme.primary, size: 32),
              const SizedBox(width: 8),
              Text('vidyoo', style: VidyooTheme.h3.copyWith(color: VidyooTheme.primary)),
            ],
          ),
          const Spacer(),
          if (!isMobile) _buildDesktopMenu(),
          if (isMobile) _buildMobileMenuButton(context),
        ],
      ),
    );
  }

  Widget _buildDesktopMenu() {
    return Row(
      children: [
        _buildNavItem('Features',(){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return FeaturesPage();
          }));
        }),

        _buildNavItem('Pricing',(){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PricingPage();
          }));
        }),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () {
            // showDialog(context: context, builder: (context){
            //   return AlertDialog(content: SignUpPrompt(videoPreviewUrl: '',),);
            // });
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

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: isMobile ? 32 : 64),
      child: Column(
        children: [
          Text(
            'Transform Your Videos with AI',
            style: VidyooTheme.h1.copyWith(color: VidyooTheme.textDark, fontSize: isMobile ? 36 : 56),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Translate videos into any language while preserving voice.\nEdit content using natural language commands.',
            style: VidyooTheme.bodyLarge.copyWith(color: VidyooTheme.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildCTAButton('Translate Video', VidyooTheme.primary, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UploadPage();
                }));
              }),
              _buildCTAButton('Smart Edit', Colors.white, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UploadPage();
                }));
              }, outlined: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: isMobile ? 32 : 64),
      child: Column(
        children: [
          Text('Key Features', style: VidyooTheme.h2),
          const SizedBox(height: 48),
          isMobile ? _buildMobileFeatures() : _buildDesktopFeatures(),
        ],
      ),
    );
  }

  Widget _buildDesktopFeatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureCard(
          context,
          'Video Translation',
          'Translate your videos into any language while preserving the original voice.',
          Icons.translate,
        ),
        const SizedBox(width: 24),
        _buildFeatureCard(
          context,
          'Smart Editing',
          'Edit videos using natural language. Extract specific moments instantly.',
          Icons.auto_awesome,
        ),
      ],
    );
  }

  Widget _buildMobileFeatures() {
    return Column(
      children: [
        _buildFeatureCard(
          context,
          'Video Translation',
          'Translate your videos into any language while preserving the original voice.',
          Icons.translate,
        ),
        const SizedBox(height: 24),
        _buildFeatureCard(
          context,
          'Smart Editing',
          'Edit videos using natural language. Extract specific moments instantly.',
          Icons.auto_awesome,
        ),
      ],
    );
  }

  Widget _buildNavItem(String title, dynamic onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: VidyooTheme.bodyDefault.copyWith(color: VidyooTheme.textDark),
        ),
      ),
    );
  }

  Widget _buildCTAButton(String title, Color color, VoidCallback onPressed, {bool outlined = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined ? Colors.white : color,
        foregroundColor: outlined ? VidyooTheme.primary : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
          side: outlined ? BorderSide(color: VidyooTheme.primary) : BorderSide.none,
        ),
      ),
      child: Text(title, style: VidyooTheme.buttonText),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String description, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: VidyooTheme.primary),
          const SizedBox(height: 16),
          Text(title, style: VidyooTheme.h4),
          const SizedBox(height: 8),
          Text(
            description,
            style: VidyooTheme.bodyDefault.copyWith(color: VidyooTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
