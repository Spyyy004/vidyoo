import '../utils/consts.dart';
import 'package:flutter/material.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  bool isAnnual = true;

  final List<PricingPlan> plans = [
    PricingPlan(
      name: 'Basic',
      monthlyPrice: 999,
      annualPrice: 470,
      features: [
        '5 hours of video processing',
        'Basic translation features',
        'Standard quality output',
        'Email support',
        '720p max resolution',
      ],
      color: Colors.blue,
      isPopular: false,
    ),
    PricingPlan(
      name: 'Professional',
      monthlyPrice: 2499,
      annualPrice: 950,
      features: [
        '25 hours of video processing',
        'Advanced translation features',
        'High quality output',
        'Priority support',
        '1080p max resolution',
        'Custom voice cloning',
        'Subtitle customization',
      ],
      color: VidyooTheme.primary,
      isPopular: true,
    ),
    PricingPlan(
      name: 'Enterprise',
      monthlyPrice: 9999,
      annualPrice: 1900,
      features: [
        'Unlimited video processing',
        'All translation features',
        'Ultra high quality output',
        '24/7 dedicated support',
        '4K resolution',
        'API access',
        'Custom integration',
        'Team collaboration',
      ],
      color: Colors.purple,
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              _buildHeader(),
              _buildPricingSection(),
              _buildFAQSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VidyooTheme.primary.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
      ),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Text('Simple, Transparent Pricing',
                    style: VidyooTheme.h1.copyWith(
                        color: VidyooTheme.textDark, fontSize: 56),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Text(
                  'Choose the perfect plan for your video translation needs',
                  style: VidyooTheme.bodyLarge
                      .copyWith(color: VidyooTheme.textSecondary, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _buildBillingToggleSection(),
        ],
      ),
    );
  }

  Widget _buildBillingToggleSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: VidyooTheme.surface,
            borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBillingToggle('Monthly', !isAnnual),
              _buildBillingToggle('Annual', isAnnual),
            ],
          ),
        ),
        if (isAnnual)
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Text('Save 20% with annual billing',
                    style: VidyooTheme.bodyDefault.copyWith(
                        color: Colors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBillingToggle(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => isAnnual = text == 'Annual'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ]
              : null,
        ),
        child: Text(
          text,
          style: VidyooTheme.bodyDefault.copyWith(
            color: isSelected
                ? VidyooTheme.primary
                : VidyooTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: plans.map((plan) {
              final cardWidth = constraints.maxWidth > 1200
                  ? (constraints.maxWidth - 96) / 3
                  : constraints.maxWidth > 800
                  ? (constraints.maxWidth - 64) / 2
                  : constraints.maxWidth;
              return _buildPricingCard(plan, cardWidth);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildPricingCard(PricingPlan plan, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(40),
      height: 800,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        border: Border.all(
          color: plan.isPopular
              ? plan.color
              : VidyooTheme.textSecondary.withOpacity(0.1),
          width: plan.isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.isPopular
                ? plan.color.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.isPopular)
            Container(

              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: plan.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
              ),
              child: Text(
                'Most Popular',
                style: VidyooTheme.bodySmall.copyWith(
                  color: plan.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(plan.name,
              style:
              VidyooTheme.h3.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\₹', style: VidyooTheme.bodyLarge),
              Text(
                  isAnnual
                      ? plan.annualPrice.toString()
                      : plan.monthlyPrice.toString(),
                  style: VidyooTheme.h2
                      .copyWith(fontWeight: FontWeight.w700)),
              Text('/mo',
                  style: VidyooTheme.bodyLarge
                      .copyWith(color: VidyooTheme.textSecondary)),
            ],
          ),
          if (isAnnual)
            Text('Billed annually',
                style: VidyooTheme.bodySmall
                    .copyWith(color: VidyooTheme.textSecondary)),
          const SizedBox(height: 40),
          ...plan.features
              .map((feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    color: VidyooTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                    child:
                    Text(feature, style: VidyooTheme.bodyDefault)),
              ],
            ),
          ))
              .toList(),
          const SizedBox(height: 40),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                plan.isPopular ? plan.color : Colors.transparent,
                foregroundColor:
                plan.isPopular ? Colors.white : plan.color,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                side: BorderSide(color: plan.color),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(VidyooTheme.radiusM),
                ),
              ),
              child:
              Text('Get Started', style: VidyooTheme.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      decoration: BoxDecoration(
        color: VidyooTheme.surface,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
      ),
      child: Column(
        children: [
          Text('Frequently Asked Questions',
              style:
              VidyooTheme.h2.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 48),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                _buildFAQItem(
                  'What payment methods do you accept?',
                  'We accept all major credit cards, PayPal, and bank transfers for annual plans.',
                ),
                _buildFAQItem(
                  'Can I switch plans later?',
                  'Yes, you can upgrade or downgrade your plan at any time. The change will be prorated.',
                ),
                _buildFAQItem(
                  'Is there a free trial?',
                  'Yes, all plans come with a 14-day free trial. No credit card required.',
                ),
                _buildFAQItem(
                  'What happens if I exceed my video processing limit?',
                  'You can purchase additional hours or upgrade to a higher plan.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
        border: Border.all(
            color: VidyooTheme.textSecondary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: VidyooTheme.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(answer,
              style: VidyooTheme.bodyDefault
                  .copyWith(color: VidyooTheme.textSecondary)),
        ],
      ),
    );
  }
}

class PricingPlan {
  final String name;
  final int monthlyPrice;
  final int annualPrice;
  final List<String> features;
  final Color color;
  final bool isPopular;

  PricingPlan({
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.features,
    required this.color,
    required this.isPopular,
  });
}