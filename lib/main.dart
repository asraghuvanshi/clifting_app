import 'dart:math' as math;
import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: ClifitingApp(),
    ),
  );
}

class ClifitingApp extends StatelessWidget {
  const ClifitingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clifiting',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A15),
        fontFamily: 'SFPro',
        useMaterial3: true,
      ),
      home:  ClifitingOnboardingScreen(),
    );
  }
}

class NewSplashScreen extends StatelessWidget {
  final AnimationController animation;

  const NewSplashScreen({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.spaceBlack, AppColors.midnightBlue],
            ),
          ),
        ),

        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return GoldBlueParticles(
              animation: animation.value.clamp(0.0, 1.0),
            );
          },
        ),

        Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final value = animation.value.clamp(0.0, 1.0);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.6 + 0.4 * value,
                    child: GoldBlueHeartLogo(animation: value),
                  ),

                  SizedBox(height: 40),

                  Opacity(
                    opacity: value > 0.5 ? (value - 0.5) * 2 : 0.0,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  AppColors.electricGold,
                                  AppColors.cyberBlue,
                                ],
                                stops: [0.0, 1.0],
                              ).createShader(bounds);
                            },
                            child: Text(
                              "CLIFITING",
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Where Connections Begin",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class GoldBlueHeartLogo extends StatelessWidget {
  final double animation;

  const GoldBlueHeartLogo({Key? key, required this.animation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.electricGold.withOpacity(0.9),
            AppColors.cyberBlue.withOpacity(0.7),
            Colors.transparent,
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricGold.withOpacity(0.4),
            blurRadius: 50,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: AppColors.cyberBlue.withOpacity(0.3),
            blurRadius: 70,
            spreadRadius: 15,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            width: 200 + math.sin(animation * math.pi * 4) * 15,
            height: 200 + math.sin(animation * math.pi * 4) * 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electricGold.withOpacity(0.3),
                  AppColors.cyberBlue.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Icon(Icons.favorite, color: Colors.white, size: 80),
        ],
      ),
    );
  }
}

class GoldBlueParticles extends StatefulWidget {
  final double animation;

  const GoldBlueParticles({Key? key, required this.animation})
    : super(key: key);

  @override
  State<GoldBlueParticles> createState() => _GoldBlueParticlesState();
}

class _GoldBlueParticlesState extends State<GoldBlueParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<GoldBlueParticle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
    particles = List.generate(20, (index) => GoldBlueParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: GoldBlueParticlePainter(
            particles: particles,
            time: _controller.value,
            intensity: widget.animation.clamp(0.0, 1.0),
          ),
        );
      },
    );
  }
}

class GoldBlueParticle {
  double x, y, vx, vy, life, maxLife, size;
  Color color;

  GoldBlueParticle()
    : x = 0,
      y = 0,
      vx = 0,
      vy = 0,
      life = 0,
      maxLife = 0,
      size = 0,
      color = Colors.transparent {
    reset();
  }

  void reset() {
    x = (math.Random().nextDouble() - 0.5) * 1000;
    y = (math.Random().nextDouble() - 0.5) * 800;
    vx = (math.Random().nextDouble() - 0.5) * 3;
    vy = (math.Random().nextDouble() - 0.5) * 3;
    life = 0;
    maxLife = 2.0 + math.Random().nextDouble();
    size = 2 + math.Random().nextDouble() * 4;

    final colors = [AppColors.electricGold, AppColors.cyberBlue];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update(double time, double intensity) {
    x += vx * intensity;
    y += vy * intensity;
    life = math.min(life + 0.02 * intensity, maxLife);
  }

  bool get isDead => life >= maxLife;
}

class GoldBlueParticlePainter extends CustomPainter {
  final List<GoldBlueParticle> particles;
  final double time;
  final double intensity;

  const GoldBlueParticlePainter({
    required this.particles,
    required this.time,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = intensity.clamp(0.0, 1.0);
    for (var particle in particles) {
      particle.update(time, clamped);

      final alpha = (1.0 - (particle.life / particle.maxLife)).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withOpacity(alpha * clamped * 0.7);

      canvas.drawCircle(
        Offset(particle.x + size.width / 2, particle.y + size.height / 2),
        particle.size,
        paint,
      );

      if (particle.isDead) particle.reset();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ClifitingOnboardingScreen extends StatefulWidget {
  @override
  _ClifitingOnboardingScreenState createState() =>
      _ClifitingOnboardingScreenState();
}

class _ClifitingOnboardingScreenState extends State<ClifitingOnboardingScreen>
    with TickerProviderStateMixin {
  PageController? _pageController;
  late List<AnimationController> _controllers;
  int currentPage = 0;
  bool _isControllerReady = false;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: "Find Your\nSoulmate",
      subtitle: "AI-powered matching for\ntrue compatibility",
      icon: Icons.favorite,
      gradient: [AppColors.neonPink, AppColors.electricGold],
    ),
    OnboardingPage(
      title: "Real\nConnections",
      subtitle: "Meaningful conversations\nthat spark love",
      icon: Icons.chat_bubble_outline,
      gradient: [AppColors.electricGold, AppColors.cyberBlue],
    ),
    OnboardingPage(
      title: "Forever\nLove",
      subtitle: "Build lasting relationships\nwith your perfect match",
      icon: Icons.favorite,
      gradient: [AppColors.neonPink, AppColors.electricGold],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1000),
        vsync: this,
      ),
    );

    for (var controller in _controllers) {
      controller.forward();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _pageController = PageController();
          _isControllerReady = true;
        });

        _pageController?.addListener(() {
          if (_pageController != null && _pageController!.hasClients) {
            final page = (_pageController!.page ?? 0).round();
            if (page != currentPage && mounted) {
              setState(() => currentPage = page);
              HapticFeedback.lightImpact();
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController?.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_pageController != null && _pageController!.hasClients) {
      if (currentPage < pages.length - 1) {
        _pageController!.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        HapticFeedback.heavyImpact();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                NewMainAppScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spaceBlack,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  pages[currentPage].gradient.first.withOpacity(0.2),
                  pages[currentPage].gradient.last.withOpacity(0.1),
                  AppColors.spaceBlack,
                ],
                center: Alignment.topLeft,
                radius: 1.5,
              ),
            ),
          ),

          if (_isControllerReady)
            PageView.builder(
              controller: _pageController!,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controllers[index],
                  builder: (context, child) {
                    final pageAnimation = _controllers[index].value.clamp(
                      0.0,
                      1.0,
                    );
                    return SimpleOnboardingCard(
                      page: pages[index],
                      animation: pageAnimation,
                    );
                  },
                );
              },
            )
          else
            Center(child: CircularProgressIndicator(color: AppColors.neonPink)),

          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                final isActive = index == currentPage;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 10,
                  width: isActive ? 35 : 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: pages[index].gradient),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: pages[index].gradient.first.withOpacity(0.7),
                        blurRadius: isActive ? 20 : 10,
                        spreadRadius: isActive ? 2 : 0,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          Positioned(
            bottom: 60,
            right: 30,
            child: GestureDetector(
              onTap: _nextPage,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: currentPage == pages.length - 1 ? 160 : 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: pages[currentPage].gradient),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: pages[currentPage].gradient.first.withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (currentPage < pages.length - 1)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    if (currentPage == pages.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.favorite, color: Colors.white, size: 18),
                          ],
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
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class SimpleOnboardingCard extends StatelessWidget {
  final OnboardingPage page;
  final double animation;

  const SimpleOnboardingCard({
    Key? key,
    required this.page,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = animation.clamp(0.0, 1.0);
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.8 + value * 0.2,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: page.gradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: page.gradient.first.withOpacity(0.6),
                      blurRadius: 50,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Icon(page.icon, color: Colors.white, size: 55),
              ),
            ),
          ),
          SizedBox(height: 60),
          Opacity(
            opacity: value,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  LinearGradient(colors: page.gradient).createShader(bounds),
              blendMode: BlendMode.srcATop,
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Opacity(
            opacity: value,
            child: Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewMainAppScreen extends StatelessWidget {
  const NewMainAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.spaceBlack, AppColors.midnightBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.electricGold, AppColors.cyberBlue],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricGold.withOpacity(0.4),
                        blurRadius: 60,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: Icon(Icons.favorite, color: Colors.white, size: 90),
                ),
                SizedBox(height: 50),
                Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.electricGold, AppColors.cyberBlue],
                  ).createShader(bounds),
                  child: Text(
                    "CLIFITING",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 5,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "Find your true love\nand build forever together 💕",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.electricGold, AppColors.cyberBlue],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.electricGold.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "START FINDING LOVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.favorite, color: Colors.white, size: 24),
                        ],
                      ),
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
}
