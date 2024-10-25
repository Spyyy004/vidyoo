import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../utils/consts.dart';

class SignUpPrompt extends StatefulWidget {
  final String videoPreviewUrl;

  const SignUpPrompt({
    super.key,
    required this.videoPreviewUrl,
  });

  @override
  State<SignUpPrompt> createState() => _SignUpPromptState();
}

class _SignUpPromptState extends State<SignUpPrompt> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      userCredential = await _firebaseService.signInWithGoogle();

      if (userCredential != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign In Complete'),
              backgroundColor: VidyooTheme.success,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate successful sign-in
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in: ${e.toString()}'),
            backgroundColor: VidyooTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        boxShadow: VidyooTheme.shadowMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VidyooTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: VidyooTheme.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Your Video is Ready!',
            style: VidyooTheme.h2.copyWith(
              color: VidyooTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Create a free account to download and access more features',
            style: VidyooTheme.bodyLarge.copyWith(
              color: VidyooTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Video Preview with Watermark
          Container(
            height: 200,
            width: double.infinity,
            // decoration: BoxDecoration(
            //   color: VidyooTheme.surface,
            //   borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
            //   image: DecorationImage(
            //     image: NetworkImage(widget.videoPreviewUrl),
            //     fit: BoxFit.cover,
            //     colorFilter: ColorFilter.mode(
            //       Colors.white.withOpacity(0.8),
            //       BlendMode.overlay,
            //     ),
            //   ),
            // ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
                ),
                child: Text(
                  'Preview',
                  style: VidyooTheme.bodyDefault.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Features List
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: VidyooTheme.surface,
              borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
            ),
            child: Column(
              children: [
                _buildFeatureItem('Download unlimited videos'),
                _buildFeatureItem('Access to both translation & smart edit'),
                _buildFeatureItem('Priority processing'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Sign Up Buttons
          _isLoading
              ? const CircularProgressIndicator()
              : Column(
            children: [
              _buildSignUpButton(
                'Continue with Google',
                Icons.g_mobiledata,
                _handleGoogleSignIn,
                isPrimary: true,
              ),
              const SizedBox(height: 16),
              _buildSignUpButton(
                'Sign up with Email',
                Icons.email_outlined,
                    () {
                  // Handle email sign up
                },
                isPrimary: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Terms
          Text(
            'By signing in, you agree to our Terms of Service and Privacy Policy',
            style: VidyooTheme.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

// ... rest of your existing widget methods (_buildFeatureItem, _buildSignUpButton) ...
Widget _buildFeatureItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: VidyooTheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: VidyooTheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: VidyooTheme.bodyDefault.copyWith(
            color: VidyooTheme.textDark,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSignUpButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
      bool isPrimary = true,
    }) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? VidyooTheme.primary : Colors.white,
        foregroundColor: isPrimary ? Colors.white : VidyooTheme.textDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: VidyooTheme.textSecondary.withOpacity(0.2)),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: VidyooTheme.buttonText.copyWith(
              color: isPrimary ? Colors.white : VidyooTheme.textDark,
            ),
          ),
        ],
      ),
    ),
  );
}
}



