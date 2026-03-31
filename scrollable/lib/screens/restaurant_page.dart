// 1
import 'package:flutter/material.dart';
import '../components/restaurant_item.dart';
import '../models/restaurant.dart';

// 2
class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

// 3
  const RestaurantPage({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

// 4
class _RestaurantPageState extends State<RestaurantPage> {
  static const desktopThreshold = 700;
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
        ? screenWidth * largeScreenPercentage //
        : screenWidth)
        .clamp(0.0, maxWidth);
  }
  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }
  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Menu'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
// 1
    return SliverAppBar(
// 2
      pinned: true,
// 3
      expandedHeight: 300.0,
// 4
      flexibleSpace: FlexibleSpaceBar(
// 5
        background: Center(
// 6
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 64.0,
            ),
// 7
            child: Stack(
              children: [
// 8
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16.0),
// 9
                    image: DecorationImage(
                      image: AssetImage(widget.restaurant.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
// 10
                const Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.store,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// 1
  SliverToBoxAdapter _buildInfoSection() {
// 2
    final textTheme = Theme.of(context).textTheme;
// 3
    final restaurant = widget.restaurant;
// 4
    return SliverToBoxAdapter(
// 5
      child: Padding(
        padding: const EdgeInsets.all(16.0),
// 6
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// 7
            Text(
              restaurant.name,
              style: textTheme.headlineLarge,
            ),
            Text(
              restaurant.address,
              style: textTheme.bodySmall,
            ),
            Text(
              restaurant.getRatingAndDistance(),
              style: textTheme.bodySmall,
            ),
            Text(
              restaurant.attributes,
              style: textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return InkWell(
      onTap: () {
// Present Bottom Sheet in the future.
      },
      child: RestaurantItem(item: item),
    );
  }
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,),
      ),
    );
  }
// 1
  GridView _buildGridView(int columns) {
// 2
    return GridView.builder(
      padding: const EdgeInsets.all(0),
// 3
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
// 4
// 5
// 6
      shrinkWrap: true,
// 7
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.restaurant.items.length,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
// 1
  SliverToBoxAdapter _buildGridViewSection(String title) {
// 2
    final columns =
    calculateColumnCount(MediaQuery.of(context).size.width);
// 3
    return SliverToBoxAdapter(
// 4
      child: Container(
        padding: const EdgeInsets.all(16.0),
// 5
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// 6
            _sectionTitle(title),
// 7
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth =
    _calculateConstrainedWidth(screenWidth);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }
}
