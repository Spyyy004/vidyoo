import 'package:flutter/material.dart';
import 'package:vidyoo/screens/landing_screen.dart';
import 'package:vidyoo/screens/upload.dart';

import '../utils/consts.dart';
import 'features.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int selectectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavBar(context),
            selectectedIndex == 0 ? LandingPage() : FeaturesPage()
          ],
        ),
      ),
    );
  }
  Widget _buildNavBar(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GestureDetector(
        onTap: (){
          setState(() {
            selectectedIndex = 0;
          });
        },
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
            setState(() {
selectectedIndex = 2;
            });

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

  Widget _buildNavItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: (){
          setState(() {
            selectectedIndex = 1;
          });
          // Navigator.push(context, MaterialPageRoute(builder: (context){
          //   return FeaturesPage();
          // }));
        },
        child: Text(
          title,
          style: VidyooTheme.bodyDefault.copyWith(color: VidyooTheme.textDark),
        ),
      ),
    );
  }

}
