import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
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
  late TabController _tabController;
  bool _isPublicProfile = false;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // Min/max sheet sizes as fraction of screen height
  static const double _minSheetSize = 0.5;
  static const double _maxSheetSize = 0.75;

  double _headerScale = 1.0;
  double _childOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to sheet position and shrink header as sheet expands
    _sheetController.addListener(() {
      final isFullSize = _sheetController.size == 0.75;
      final t =
          (_sheetController.size - _minSheetSize) /
          (_maxSheetSize - _minSheetSize);
      setState(() {
        _headerScale =  t.clamp(0.8, 1.0);
        _childOpacity = 1.0 - t.clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFEEECE8), // warm beige background
      body: Stack(
        children: [
          // ── Profile header (visible behind the sheet) ──────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          size: 24,
                          color: Colors.black87,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Avatar + Name
                // In your build method, replace the header Column with:
                AnimatedScale(
                  scale: _headerScale,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  // Optional: makes the movement feel more natural
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://i.pravatar.cc/150?img=12',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Aladdin',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFB39DDB),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '@aladdin_mtfk',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                AnimatedScale(
                  scale: _childOpacity,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  // Optional: makes the movement feel more natural
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      // Followers row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '0 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'followers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '1 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'following',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Divider
                      const Divider(height: 1, color: Color(0xFFDDDDDD)),
                      const SizedBox(height: 16),
                      // Public profile toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Let others view your portfolio, balance,\nand trade performance or keep them\nprivate',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black45,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isPublicProfile,
                              onChanged: (v) => setState(() => _isPublicProfile = v),
                              activeColor: Colors.black,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                              trackOutlineColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Favorites header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'FAVORITES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),




              ],
            ),
          ),

          // ── Draggable bottom sheet ──────────────────────────────────────
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _minSheetSize,
            minChildSize: _minSheetSize,
            maxChildSize: _maxSheetSize,
            snap: true,
            snapSizes: const [_minSheetSize, _maxSheetSize],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Tab bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: _SegmentedTabBar(controller: _tabController),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _PortfolioEmptyState(
                            scrollController: scrollController,
                          ),
                          _InsightsTab(scrollController: scrollController),
                          _EventsTab(scrollController: scrollController),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── FAB ────────────────────────────────────────────────────────
          Positioned(
            right: 20,
            bottom: 32,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom segmented tab bar ─────────────────────────────────────────────────

class _SegmentedTabBar extends StatefulWidget {
  final TabController controller;

  const _SegmentedTabBar({required this.controller});

  @override
  State<_SegmentedTabBar> createState() => _SegmentedTabBarState();
}

class _SegmentedTabBarState extends State<_SegmentedTabBar> {
  final List<String> _labels = ['Portfolio', 'Insights', 'Events'];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_labels.length, (i) {
        final selected = widget.controller.index == i;
        return GestureDetector(
          onTap: () => widget.controller.animateTo(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: selected
                  ? null
                  : Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Text(
              _labels[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Portfolio empty state ─────────────────────────────────────────────────────

class _PortfolioEmptyState extends StatelessWidget {
  final ScrollController scrollController;

  const _PortfolioEmptyState({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 40),
        const Text(
          'This space will reflect your\nprogress, returns and\nportfolio insights',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black38,
            height: 1.55,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 48),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Make your first investment',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black54,
            size: 22,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

// ── Placeholder tabs ──────────────────────────────────────────────────────────

class _InsightsTab extends StatelessWidget {
  final ScrollController scrollController;

  const _InsightsTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: const [
        Text(
          'Insights will appear here once\nyou start investing.',
          style: TextStyle(fontSize: 17, color: Colors.black38, height: 1.55),
        ),
      ],
    );
  }
}

class _EventsTab extends StatelessWidget {
  final ScrollController scrollController;

  const _EventsTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: const [
        Text(
          'No upcoming events.',
          style: TextStyle(fontSize: 17, color: Colors.black38, height: 1.55),
        ),
      ],
    );
  }
}
