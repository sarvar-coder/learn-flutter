import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFEEEBE6),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _publicProfile = false;
  int _selectedTab = 0;
  late TabController _tabController;

  final List<String> _tabs = ['Portfolio', 'Insights', 'Events'];

  final List<Map<String, dynamic>> _favorites = [
    {'name': 'Microsoft', 'color': Color(0xFFf25022), 'letter': 'M'},
    {'name': 'LinkedIn', 'color': Color(0xFF0077B5), 'letter': 'in'},
    {'name': 'Google', 'color': Color(0xFF4285F4), 'letter': 'G'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.3, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFFD8D0C8),
                  Color(0xFFEEEBE6),
                ],
              ),
            ),
          ),
          // Decorative blob
          Positioned(
            top: 60,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconButton(Icons.arrow_back_ios_new_rounded),
                      _hexagonSettings(),
                    ],
                  ),
                ),

                // Profile info (scrollable top section)
                Expanded(
                  child: _buildScrollableContent(),
                ),
              ],
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 32,
            right: 20,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.menu_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Profile header (stays in scroll but above the white sheet)
        SliverToBoxAdapter(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + name row
                Row(
                  children: [
                    _avatar(),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Aladdin',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _verifiedBadge(),
                          ],
                        ),
                        const Text(
                          '@aladdin_mtfk',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Followers / Following
                Row(
                  children: [
                    _statItem('0', 'followers'),
                    const SizedBox(width: 4),
                    const Text('  ',
                        style: TextStyle(color: Color(0xFFCCCCCC))),
                    _statItem('1', 'following'),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFDDDAD5), thickness: 0.8),
                const SizedBox(height: 16),

                // Public profile toggle
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Public profile',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Let others view your portfolio, balance,\nand trade performance or keep them private',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch.adaptive(
                      value: _publicProfile,
                      onChanged: (v) => setState(() => _publicProfile = v),
                      activeColor: const Color(0xFF1A1A1A),
                      inactiveTrackColor: const Color(0xFFDDDDDD),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Favorites
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FAVORITES',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF999999),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Icon(Icons.edit_outlined,
                        size: 18, color: const Color(0xFF666666)),
                  ],
                ),
                const SizedBox(height: 12),

                // Favorite chips
                Row(
                  children: _favorites
                      .map((f) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _favoriteChip(f),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // White scrollable bottom sheet
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 16),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Tab bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final selected = i == _selectedTab;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedTab = i);
                          _tabController.animateTo(i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF1A1A1A)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFE0E0E0),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _tabs[i],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),

                // Tab content
                _buildTabContent(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return _buildPortfolioTab();
    } else if (_selectedTab == 1) {
      return _buildInsightsTab();
    } else {
      return _buildEventsTab();
    }
  }

  Widget _buildPortfolioTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This space will reflect your\nprogress, returns and\nportfolio insights',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color(0xFFCCCCCC),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          const Divider(color: Color(0xFFEEEEEE), thickness: 0.8),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Make your first investment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Color(0xFF999999)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Your insights will\nappear here',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color(0xFFCCCCCC),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'No upcoming events\njust yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color(0xFFCCCCCC),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF6EC6FF), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'A',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _verifiedBadge() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E0F8),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_rounded, size: 13, color: Color(0xFF9B7FD4)),
    );
  }

  Widget _statItem(String value, String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          TextSpan(
            text: ' $label',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteChip(Map<String, dynamic> f) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: (f['color'] as Color).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                f['letter'] as String,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: f['color'] as Color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            f['name'] as String,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1A1A1A)),
      ),
    );
  }

  Widget _hexagonSettings() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.settings_outlined,
            size: 20, color: Color(0xFF1A1A1A)),
      ),
    );
  }
}