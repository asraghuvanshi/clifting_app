import 'dart:async';
import 'dart:math' as math;
import 'package:clifting_app/features/auth/data/model/user_model.dart';
import 'package:clifting_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:clifting_app/features/auth/presentation/provider/auth_provider.dart';
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

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with WidgetsBindingObserver {
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();
  Timer? _particleTimer;
  final GlobalKey _refreshIndicatorKey = GlobalKey();

  UserResponse? _user;
  bool _isLoading = true;
  bool _isVerified = false;

  // Store screen dimensions
  late double _screenWidth;
  late double _screenHeight;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeParticles();
        _isInitialized = true;
        _startParticleAnimation();
        // Load user profile AFTER the widget tree is built
        _loadUserProfile();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
  }

  void _initializeParticles() {
    _particles.clear();
    for (int i = 0; i < 25; i++) {
      _particles.add(
        _Particle(
          random: _random,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        ),
      );
    }
    if (mounted) setState(() {});
  }

  void _startParticleAnimation() {
    _particleTimer?.cancel();
    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        for (final particle in _particles) {
          particle.update();
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _particleTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize particles when screen size changes
    if (_isInitialized) {
      _initializeParticles();
    }
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      // Use Future.delayed to ensure we're not in build phase
      await Future.delayed(Duration.zero, () async {
        await ref.read(authProvider.notifier).getUserProfile();
      });
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        _showErrorSnackbar('Failed to load profile');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
                _isVerified = _user?.verified ?? false;
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
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text(
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
      // await ref.read(authStateProvider.notifier).logout();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToWebView(String title, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(title: title, type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state for changes
    final authState = ref.watch(authProvider);

    // Use Future.microtask to handle state updates after build
    Future.microtask(() {
      if (authState is UserProfileSuccess) {
        final response = authState.response;
        if (response.data != null && mounted) {
          setState(() {
            _user = response.data;
            _isVerified = _user?.verified ?? false;
            _isLoading = false;
          });
        }
      } else if (authState is AuthError && _isLoading && mounted) {
        setState(() => _isLoading = false);
        if (!authState.message.contains('initial')) {
          _showErrorSnackbar(authState.message);
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
            // Attractive particle effects
            if (_isInitialized)
              ..._particles.map((particle) {
                return Positioned(
                  left: particle.x,
                  top: particle.y,
                  child: Transform.rotate(
                    angle: particle.rotation,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: particle.opacity,
                      child: Container(
                        width: particle.size,
                        height: particle.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: particle.colors,
                            stops: const [0.1, 0.5, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: particle.glowColor.withOpacity(
                                particle.opacity * 0.6,
                              ),
                              blurRadius: particle.size * 1.5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
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
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: AppColors.cyberBlue,
                      backgroundColor: Colors.black,
                      onRefresh: _loadUserProfile,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // Profile Header with Particle Effects
                            _buildProfileHeader(),

                            const SizedBox(height: 30),

                            // Quick Stats
                            _buildQuickStats(),

                            const SizedBox(height: 30),

                            // Main Menu Options
                            _buildMainMenuOptions(),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.85),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.cyberBlue,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Loading Profile...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty space for alignment
          const SizedBox(width: 44),

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

          // Edit Profile Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _user != null ? _navigateToEditProfile : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cyberBlue.withOpacity(
                        _user != null ? 0.4 : 0.2,
                      ),
                      AppColors.electricGold.withOpacity(
                        _user != null ? 0.2 : 0.1,
                      ),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.cyberBlue.withOpacity(
                      _user != null ? 0.6 : 0.3,
                    ),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyberBlue.withOpacity(
                        _user != null ? 0.3 : 0.1,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: _user != null
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: _user != null
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
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
        : 'Loading...';

    final profession = _user?.profession ?? 'Profession';
    final city = _user?.city ?? '';
    final country = _user?.country ?? '';
    final hasLocation = city.isNotEmpty || country.isNotEmpty;
    final age = _user?.age != null ? '${_user!.age} years' : '';

    return Column(
      children: [
        // Profile Picture with Glow Effect
        Stack(
          alignment: Alignment.center,
          children: [
            // Animated Glow Rings
            for (int i = 0; i < 3; i++)
              AnimatedContainer(
                duration: Duration(seconds: 2 + i),
                curve: Curves.easeInOut,
                width: 140 + (i * 20),
                height: 140 + (i * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyberBlue.withOpacity(0.1 * (3 - i)),
                      AppColors.electricGold.withOpacity(0.05 * (3 - i)),
                      Colors.transparent,
                    ],
                    stops: const [0.1, 0.5, 1.0],
                  ),
                ),
              ),

            // Profile Picture Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
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
                child:
                    _user?.profileImage != null &&
                        _user!.profileImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          _user!.profileImage!,
                          width: 116,
                          height: 116,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColors.cyberBlue,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 10),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 10),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
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
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 20),

        // Name and Information
        Column(
          children: [
            Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            if (profession.isNotEmpty)
              Text(
                profession,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),

            const SizedBox(height: 4),

            if (age.isNotEmpty)
              Text(
                age,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

            const SizedBox(height: 12),

            // Location and Info Row
            if (hasLocation || (_user?.interests?.isNotEmpty ?? false))
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  if (hasLocation)
                    _buildInfoChip(
                      icon: Icons.location_on_outlined,
                      text: city.isNotEmpty && country.isNotEmpty
                          ? '$city, $country'
                          : city.isNotEmpty
                          ? city
                          : country,
                      color: AppColors.cyberBlue,
                    ),

                  if (_user?.gender?.isNotEmpty ?? false)
                    _buildInfoChip(
                      icon: Icons.person_outline,
                      text: _user!.gender!,
                      color: AppColors.electricGold,
                    ),

                  if (_user?.lookingFor?.isNotEmpty ?? false)
                    _buildInfoChip(
                      icon: Icons.search,
                      text: _user!.lookingFor!,
                      color: Colors.purpleAccent,
                    ),
                ],
              ),

            // Interests
            if (_user?.interests?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _user!.interests!.take(5).map((interest) {
                    return Chip(
                      label: Text(
                        interest,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.1),
                      side: BorderSide(
                        color: AppColors.cyberBlue.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final likesReceived = _user?.likesReceived ?? 0;
    final profileViews = _user?.profileViews ?? 0;
    final matchesCount = _user?.matchesCount ?? 0;
    final unreadCount = _user?.unreadCount ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            offset: const Offset(0, 6),
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
          _buildStatItem(
            'Likes',
            likesReceived.toString(),
            Icons.favorite_outline,
          ),
          _buildStatItem(
            'Views',
            profileViews.toString(),
            Icons.visibility_outlined,
          ),
          _buildStatItem(
            'Matches',
            matchesCount.toString(),
            Icons.people_outline,
          ),
          _buildStatItem(
            'Unread',
            unreadCount.toString(),
            Icons.message_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
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
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          ...menuItems.map((item) => _buildMenuItem(item)).toList(),
          const SizedBox(height: 16.0),
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
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [item.color.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child: Icon(item.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
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
  final double screenWidth;
  final double screenHeight;

  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double direction;
  double velocityX;
  double velocityY;
  double rotation;
  double rotationSpeed;
  List<Color> colors;
  Color glowColor;

  _Particle({
    required this.random,
    required this.screenWidth,
    required this.screenHeight,
  }) : x = 0,
       y = 0,
       size = 0,
       speed = 0,
       opacity = 0,
       direction = 0,
       velocityX = 0,
       velocityY = 0,
       rotation = 0,
       rotationSpeed = 0,
       colors = [],
       glowColor = Colors.transparent {
    reset();
  }

  void reset() {
    // Random starting position across screen
    x = random.nextDouble() * screenWidth;
    y = random.nextDouble() * screenHeight * 0.6;

    // Varied particle sizes (small to medium)
    size = random.nextDouble() * 6 + 3;

    // Varied speeds
    speed = random.nextDouble() * 0.8 + 0.2;

    // Random direction
    direction = random.nextDouble() * math.pi * 2;
    velocityX = math.cos(direction) * speed;
    velocityY = math.sin(direction) * speed;

    // Random opacity with fade in/out effect
    opacity = random.nextDouble() * 0.4 + 0.3;

    // Rotation effects
    rotation = random.nextDouble() * math.pi * 2;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.02;

    // Color variations
    final colorOptions = [
      [Colors.white, AppColors.cyberBlue.withOpacity(0.6), Colors.transparent],
      [
        Colors.white,
        AppColors.electricGold.withOpacity(0.6),
        Colors.transparent,
      ],
      [Colors.white, Colors.purpleAccent.withOpacity(0.6), Colors.transparent],
      [Colors.white, Colors.blueAccent.withOpacity(0.6), Colors.transparent],
    ];
    colors = colorOptions[random.nextInt(colorOptions.length)];
    glowColor = colors[1];
  }

  void update() {
    // Move particle
    x += velocityX;
    y += velocityY;

    // Add slight random movement
    direction += (random.nextDouble() - 0.5) * 0.05;
    velocityX = math.cos(direction) * speed;
    velocityY = math.sin(direction) * speed;

    // Rotation
    rotation += rotationSpeed;

    // Pulsing opacity
    final time = DateTime.now().millisecondsSinceEpoch / 1000;
    opacity = 0.3 + (math.sin(time * 0.5 + x * 0.01) * 0.4).abs();

    // Bounce off edges
    if (x < 0 || x > screenWidth) {
      velocityX = -velocityX;
      direction = math.atan2(velocityY, velocityX);
    }
    if (y < 0 || y > screenHeight * 0.6) {
      velocityY = -velocityY;
      direction = math.atan2(velocityY, velocityX);
    }

    if (x < -50 || x > screenWidth + 50 || y < -50 || y > screenHeight + 50) {
      reset();
    }
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
