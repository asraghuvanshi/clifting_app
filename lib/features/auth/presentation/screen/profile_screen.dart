import 'dart:async';
import 'dart:math' as math;
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/presentation/auth_provider.dart';
import 'package:clifting_app/features/auth/presentation/screen/about_screen.dart';
import 'package:clifting_app/features/auth/presentation/screen/edit_profile_screen.dart';
import 'package:clifting_app/features/auth/presentation/screen/setting_screen.dart';
import 'package:clifting_app/features/auth/presentation/screen/webview_screen.dart';
import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();
  Timer? _particleTimer;

  User? _user;
  bool _isLoading = true;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();

    // Initialize particles - increased count and size
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(_random));
    }

    // Start particle animation
    _startParticleAnimation();

    // Load user profile
    _loadProfile();
  }

  void _startParticleAnimation() {
    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        for (final particle in _particles) {
          particle.update();
        }
        setState(() {});
      }
    });
  }

  Future<void> _loadProfile() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.get('/user/profile');

      if (response.statusCode == 200) {
        setState(() {
          _user = User.fromJson(response.data['data']['user']);
          _isVerified = _user?.verified ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading profile: $e');
    }
  }

  void _navigateToEditProfile() {
    if (_user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            user: _user!,
            onProfileUpdated: (updatedUser) {
              setState(() {
                _user = updatedUser;
              });
            },
          ),
        ),
      );
    }
  }

  void _navigateToAbout() {
    if (_user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutScreen(user: _user!)),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.black.withOpacity(0.95),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red, size: 24),
            SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: AppColors.cyberBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await ref.read(authStateProvider.notifier).logout();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

void _navigateToWebView(String title, String type) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewScreen(
        title: title,
        type: type,
      ),
    ),
  );
}

  @override
  void dispose() {
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0A0A),
              AppColors.midnightBlue,
              Color(0xFF1A1A2E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Particle effects around profile image - made bigger
            ..._particles.map((particle) {
              final opacity = particle.opacity.clamp(0.0, 0.7);
              return Positioned(
                left: particle.x,
                top: particle.y,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          AppColors.cyberBlue.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        stops: [0.1, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyberBlue.withOpacity(opacity * 0.5),
                          blurRadius: particle.size * 0.8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  _buildAppBar(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 20),

                          // Profile Header with Particle Effects
                          _buildProfileHeader(),

                          SizedBox(height: 30),

                          // Quick Stats
                          _buildQuickStats(),

                          SizedBox(height: 30),

                          // Main Menu Options
                          _buildMainMenuOptions(),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.cyberBlue,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty space for alignment (no back button in bottom nav)
          Container(width: 44),

          // Title
          Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppColors.cyberBlue.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          // Edit Profile Button (Changed from Edit mode toggle)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _navigateToEditProfile,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cyberBlue.withOpacity(0.4),
                      AppColors.electricGold.withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.cyberBlue.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyberBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final fullName = _user != null
        ? '${_user!.firstName} ${_user!.lastName}'.trim()
        : 'User Name';

    final profession = _user?.profession ?? 'Software Engineer';
    final city = _user?.city ?? '';
    final country = _user?.country ?? '';
    final hasLocation = city.isNotEmpty || country.isNotEmpty;

    return Column(
      children: [
        // Profile Picture with Particle Effects
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow Effect
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyberBlue.withOpacity(0.4),
                    AppColors.electricGold.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: [0.1, 0.6, 1.0],
                ),
              ),
            ),

            // Profile Picture Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.electricGold, AppColors.cyberBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.electricGold.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  fullName.isNotEmpty ? fullName[0] : 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: AppColors.cyberBlue.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Verified Badge
            if (_isVerified)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(Icons.verified, color: Colors.white, size: 18),
                ),
              ),
          ],
        ),

        SizedBox(height: 20),

        // Name and Profession
        Column(
          children: [
            Text(
              fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),

            SizedBox(height: 6),

            Text(
              profession,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),

            SizedBox(height: 10),

            // Location
            if (hasLocation)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.cyberBlue,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      city.isNotEmpty && country.isNotEmpty
                          ? '$city, $country'
                          : city.isNotEmpty
                          ? city
                          : country,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.cyberBlue.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Posts', '12', Icons.post_add_outlined),
          _buildStatItem('Friends', '24', Icons.people_outline),
          _buildStatItem('Likes', '156', Icons.favorite_outline),
          _buildStatItem('Following', '45', Icons.person_add_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.cyberBlue.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Icon(icon, color: AppColors.cyberBlue, size: 22),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMainMenuOptions() {
    final menuItems = [
      _MenuItem(
        icon: Icons.info_outline,
        title: 'About',
        subtitle: 'View profile details',
        color: AppColors.cyberBlue,
        onTap: _navigateToAbout,
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'App settings & preferences',
        color: Colors.blueAccent,
        onTap: _navigateToSettings,
      ),
     _MenuItem(
  icon: Icons.privacy_tip_outlined,
  title: 'Privacy Policy',
  subtitle: 'Read our privacy policy',
  color: Colors.greenAccent,
  onTap: () => _navigateToWebView('Privacy Policy', 'privacy'),
),
_MenuItem(
  icon: Icons.description_outlined,
  title: 'Terms & Conditions',
  subtitle: 'Read terms & conditions',
  color: Colors.orangeAccent,
  onTap: () => _navigateToWebView('Terms & Conditions', 'terms'),
),
_MenuItem(
  icon: Icons.help_outline,
  title: 'Help & Support',
  subtitle: 'Get help & support',
  color: Colors.purpleAccent,
  onTap: () => _navigateToWebView('Help & Support', 'help'),
),
_MenuItem(
  icon: Icons.info_outline,
  title: 'About Us',
  subtitle: 'Learn about Clifting',
  color: Colors.blueAccent,
  onTap: () => _navigateToWebView('About Clifting', 'about'),
),
      _MenuItem(
        icon: Icons.logout,
        title: 'Logout',
        subtitle: 'Logout from account',
        color: Colors.redAccent,
        onTap: _showLogoutDialog,
      ),
    ];

    // Option 1: With Padding wrapper (Recommended for cleanest look)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0), // Top leading space
          ...menuItems.map((item) => _buildMenuItem(item)).toList(),
          const SizedBox(height: 16.0), // Bottom trailing space
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          item.onTap();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.15),
                item.color.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border.all(color: item.color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [item.color.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child: Icon(item.icon, color: Colors.white, size: 22),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: item.color.withOpacity(0.8),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final math.Random random;
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double direction;
  double velocityX;
  double velocityY;

  _Particle(this.random)
    : x = 0,
      y = 0,
      size = 0,
      speed = 0,
      opacity = 0,
      direction = 0,
      velocityX = 0,
      velocityY = 0 {
    reset();
  }

  void reset() {
    // Position particles around center - adjusted for bigger profile image
    final angle = random.nextDouble() * math.pi * 2;
    final distance = 70 + random.nextDouble() * 50;
    x = 160 + math.cos(angle) * distance;
    y = 160 + math.sin(angle) * distance;

    // Increased particle size significantly
    size = random.nextDouble() * 8 + 4;
    speed = random.nextDouble() * 0.6 + 0.3;
    opacity = random.nextDouble() * 0.5 + 0.3;
    direction = random.nextDouble() * math.pi * 2;
    velocityX = math.cos(direction) * speed;
    velocityY = math.sin(direction) * speed;
  }

  void update() {
    x += velocityX;
    y += velocityY;

    // Gentle curve movement
    direction += (random.nextDouble() - 0.5) * 0.08;
    velocityX = math.cos(direction) * speed;
    velocityY = math.sin(direction) * speed;

    // Reset if goes too far
    final dx = x - 160;
    final dy = y - 160;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance > 140) {
      reset();
    }

    // Gentle pulsing opacity
    final time = DateTime.now().millisecondsSinceEpoch / 1000;
    opacity = 0.3 + (math.sin(time * 0.3 + x * 0.01) * 0.3).abs();
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
