import 'package:flutter/material.dart';
import 'package:vidyoo/screens/upload.dart';

import '../utils/consts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isDrawerOpen = false;
  bool showGridView = true; // toggle between grid and list view

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      // Responsive layout with conditional drawer
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          // Show sidebar permanently on desktop
          if (isDesktop) _buildDrawer(),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                _buildTopNav(isDesktop),

                // Main Content Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickActions(isDesktop),
                        const SizedBox(height: 32),
                        _buildAnalytics(isDesktop),
                        const SizedBox(height: 32),
                        _buildRecentProjects(isDesktop, isTablet),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right sidebar on desktop only
          if (isDesktop) _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo and Brand
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.play_circle_filled,
                    color: VidyooTheme.primary,
                    size: 32),
                const SizedBox(width: 12),
                Text('vidyoo',
                    style: VidyooTheme.h3.copyWith(
                      color: VidyooTheme.primary,
                    )),
              ],
            ),
          ),

          // Navigation Items
          _buildNavItem('Dashboard', Icons.dashboard, true),
          _buildNavItem('My Videos', Icons.video_library, false),
          _buildNavItem('Translations', Icons.translate, false),
          _buildNavItem('Smart Edits', Icons.auto_awesome, false),
          _buildNavItem('Settings', Icons.settings, false),

          const Divider(height: 32),

          // Usage Statistics
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usage', style: VidyooTheme.h4),
                const SizedBox(height: 16),
                _buildUsageItem('Hours Used', '8/20'),
                _buildUsageItem('Videos', '12/50'),
                _buildUsageItem('Storage', '60%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? VidyooTheme.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? VidyooTheme.primary : VidyooTheme.textSecondary),
        title: Text(title,
            style: VidyooTheme.bodyLarge.copyWith(
              color: isActive ? VidyooTheme.primary : VidyooTheme.textDark,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            )),
        onTap: () {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildTopNav(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          if (!isDesktop) const SizedBox(width: 16),

          // Search
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: VidyooTheme.surface,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Profile and Notifications
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: VidyooTheme.primary,
            child: Text('AP',
                style: VidyooTheme.bodySmall.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickActions(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: VidyooTheme.h3),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = isDesktop ? 250 : (constraints.maxWidth - 32) / 3;
            return Row(
              children: [

                _buildQuickActionCard(
                  'Translate Video',
                  Icons.translate,
                  VidyooTheme.secondary,
                  cardWidth,
                      () {
                   Navigator.push(context, MaterialPageRoute(builder: (context){return UploadPage();}));
                  },
                ),
                const SizedBox(width: 16),
                _buildQuickActionCard(
                  'Smart Edit',
                  Icons.auto_awesome,
                  Color(0xFF6C63FF),
                  cardWidth,
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){return UploadPage();}));

                        // Handle smart edit
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
      String title,
      IconData icon,
      Color color,
      double width,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: VidyooTheme.bodyLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analytics Overview', style: VidyooTheme.h3),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildAnalyticCard(
              'Videos Created',
              '12',
              '20',
              0.6,
              VidyooTheme.primary,
            ),
            _buildAnalyticCard(
              'Storage Used',
              '6.0',
              '10',
              0.6,
              VidyooTheme.secondary,
              suffix: 'GB',
            ),
            _buildAnalyticCard(
              'Processing Hours',
              '8',
              '20',
              0.4,
              Color(0xFF6C63FF),
              suffix: 'hrs',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticCard(
      String title,
      String current,
      String total,
      double progress,
      Color color, {
        String suffix = '',
      }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: VidyooTheme.bodyLarge.copyWith(
              color: VidyooTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$current/$total$suffix',
                style: VidyooTheme.h3.copyWith(
                  color: VidyooTheme.textDark,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: VidyooTheme.bodyLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(VidyooTheme.radiusS),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjects(bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Projects', style: VidyooTheme.h3),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    color: showGridView ? VidyooTheme.primary : VidyooTheme.textSecondary,
                  ),
                  onPressed: () => setState(() => showGridView = true),
                ),
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: !showGridView ? VidyooTheme.primary : VidyooTheme.textSecondary,
                  ),
                  onPressed: () => setState(() => showGridView = false),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        showGridView
            ? _buildProjectsGrid(isDesktop, isTablet)
            : _buildProjectsList(),
      ],
    );
  }

  Widget _buildProjectsGrid(bool isDesktop, bool isTablet) {
    int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: 6, // Example count
      itemBuilder: (context, index) {
        return _buildProjectCard();
      },
    );
  }

  Widget _buildProjectCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: VidyooTheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(VidyooTheme.radiusL),
                  topRight: Radius.circular(VidyooTheme.radiusL),
                ),
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/300/200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: VidyooTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(VidyooTheme.radiusS),
                      ),
                      child: Text(
                        'Translation',
                        style: VidyooTheme.bodySmall.copyWith(
                          color: VidyooTheme.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Just now',
                      style: VidyooTheme.bodySmall.copyWith(
                        color: VidyooTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Product Demo Video',
                  style: VidyooTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: VidyooTheme.textSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Processing Queue', style: VidyooTheme.h4),
          const SizedBox(height: 16),
          _buildQueueItem(
            'Marketing Video',
            'Translation',
            0.6,
          ),
          _buildQueueItem(
            'Team Meeting',
            'Smart Edit',
            0.3,
          ),

          const Divider(height: 48),

          Text('Recent Activities', style: VidyooTheme.h4),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Product Demo translated to Spanish',
            '5 min ago',
          ),
          _buildActivityItem(
            'Meeting highlights extracted',
            '1 hour ago',
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(String title, String type, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: VidyooTheme.surface,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: VidyooTheme.bodyLarge),
              Text(
                '${(progress * 100).round()}%',
                style: VidyooTheme.bodySmall.copyWith(
                  color: VidyooTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: VidyooTheme.primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(VidyooTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: VidyooTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: VidyooTheme.bodyDefault),
                Text(
                  time,
                  style: VidyooTheme.bodySmall.copyWith(
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


  Widget _buildUsageItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: VidyooTheme.bodyDefault.copyWith(
                  color: VidyooTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: VidyooTheme.bodyDefault.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(VidyooTheme.radiusS),
            child: LinearProgressIndicator(
              value: 0.6, // Example value
              backgroundColor: VidyooTheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(VidyooTheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Projects', style: VidyooTheme.h4),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    color: showGridView ? VidyooTheme.primary : VidyooTheme.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      showGridView = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: !showGridView ? VidyooTheme.primary : VidyooTheme.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      showGridView = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Projects Grid/List
        showGridView ? _buildProjectsGrid(true, false) : _buildProjectsListView(),
      ],
    );
  }



  Widget _buildProjectsListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8, // Example count
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 160,
              height: 90,
              decoration: BoxDecoration(
                color: VidyooTheme.surface,
                borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 32),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Demo Video',
                    style: VidyooTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSmallBadge('Translation', VidyooTheme.primary),
                      const SizedBox(width: 8),
                      _buildSmallBadge('Complete', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2 minutes ago',
                    style: VidyooTheme.bodySmall.copyWith(
                      color: VidyooTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                  tooltip: 'Download',
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                  tooltip: 'More',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(VidyooTheme.radiusS),
      ),
      child: Text(
        text,
        style: VidyooTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
// ... I'll continue with the rest of the implementation in the next message
// due to length limitations. Would you like to see any specific section first?
}