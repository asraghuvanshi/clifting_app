import 'package:clifting_app/presentation/auth/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:clifting_app/utility/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          // Home/Discover Tab
          _buildDiscoverScreen(),
          
          // Matches Tab
          _buildMatchesScreen(),
          
          // Messages Tab
          _buildMessagesScreen(),
          
          // Profile Tab
          //  const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDiscoverScreen() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          floating: false,
          snap: false,
          expandedHeight: 120,
          automaticallyImplyLeading: false, // This removes the back button
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.midnightBlue, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            title: Container(
              margin: const EdgeInsets.only(top: 30), // Space from system status bar
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.electricGold, AppColors.cyberBlue],
                    ).createShader(bounds),
                    child: const Text(
                      "CLIFITING",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildNotificationButton(),
                  const SizedBox(width: 10),
                  _buildFilterButton(),
                ],
              ),
            ),
            centerTitle: false,
          ),
        ),

        // Add some space between app bar and content
        SliverToBoxAdapter(
          child: const SizedBox(height: 10),
        ),

        // Payment Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF0080), Color(0xFF00D4FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Premium Membership",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Unlock unlimited matches and advanced features",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Upgrade Now",
                            style: TextStyle(
                              color: AppColors.midnightBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.diamond_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Featured Profiles
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Text(
              "Featured Profiles",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildProfileCard(index);
              },
            ),
          ),
        ),

        // Daily Suggestions
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  "Daily Suggestions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  "See All",
                  style: TextStyle(
                    color: AppColors.cyberBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Grid of Profiles
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildSuggestionCard(index);
              },
              childCount: 6,
            ),
          ),
        ),

        // Add bottom padding for navigation bar
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildProfileCard(int index) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://picsum.photos/200/300?random=$index",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Alex, 28",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cyberBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "PRO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Software Engineer",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "5km away",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
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

  Widget _buildSuggestionCard(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://picsum.photos/200/250?random=${index + 10}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Profile Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emma, 26",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Doctor",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesScreen() {
    return const Center(
      child: Text(
        "Matches Screen",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildMessagesScreen() {
    return const Center(
      child: Text(
        "Messages Screen",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return const Center(
      child: Text(
        "Profile Screen",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
      child: const Icon(
        Icons.notifications_none,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.electricGold, AppColors.cyberBlue],
        ),
      ),
      child: const Icon(
        Icons.tune,
        color: Colors.white,
        size: 20,
      ),
    );
  }

 Widget _buildBottomNavigationBar() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.midnightBlue,
      border: Border(
        top: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use Expanded with flex: 1 for equal spacing
            Expanded(
              flex: 1,
              child: _buildNavItem(Icons.explore_outlined, "Discover", 0),
            ),
            Expanded(
              flex: 1,
              child: _buildNavItem(Icons.favorite_border, "Matches", 1),
            ),
            Expanded(
              flex: 1,
              child: _buildNavItem(Icons.chat_bubble_outline, "Messages", 2),
            ),
            Expanded(
              flex: 1,
              child: _buildNavItem(Icons.person_outline, "Profile", 3),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNavItem(IconData icon, String label, int index) {
  return GestureDetector(
    onTap: () {
      setState(() => _selectedIndex = index);
      _pageController.jumpToPage(index);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: _selectedIndex == index
              ? AppColors.electricGold
              : Colors.white.withOpacity(0.6),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: _selectedIndex == index
                ? AppColors.electricGold
                : Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
}