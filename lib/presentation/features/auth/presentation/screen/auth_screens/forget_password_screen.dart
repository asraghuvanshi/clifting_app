import 'package:clifting_app/presentation/features/auth/presentation/screen/otp_verification_screen.dart';
import 'package:clifting_app/presentation/features/auth/providers/forget_password_provider.dart';
import 'package:clifting_app/presentation/widgets/button_widget/gradient_button.dart';
import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forgetPasswordProvider.notifier).clearData();
    });
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  Future<void> _forgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    try {
      await ref
          .read(forgetPasswordProvider.notifier)
          .forgetPassword(_emailController.text.trim());

      await Future.delayed(const Duration(milliseconds: 100));

      final state = ref.read(forgetPasswordProvider);

      if (state.data?.success == true) {
        final response = state.data!;
        final responseEmail = response.data?.email ?? "";
        final expiresIn = response.data?.expiresIn ?? "";
        final resendAfter = response.data?.resendAfter ?? "";
        final message = response.message;

        _showSuccessMessage(message);

        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                email: responseEmail,
                expiresIn: expiresIn,
                resendAfter: resendAfter,
              ),
            ),
          );
        });
      } else if (state.error != null) {
        _showErrorDialog(state.error!);
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.cyberBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forgetPasswordState = ref.watch(forgetPasswordProvider);
    final isLoading = forgetPasswordState.isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A0A0A),
                  AppColors.midnightBlue,
                  Color(0xFF1A1A2E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.02), Colors.transparent],
                radius: 1.5,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBackButton(),
                          const SizedBox(height: 40),

                          // Title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.cyberBlue,
                                Color(0xFF00D4FF),
                                AppColors.electricGold,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(bounds),
                            child: const Text(
                              "Reset Password",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Enter your email to receive\n",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: "password reset instructions ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const TextSpan(
                                  text: "📧",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),

                          // Email Field
                          _buildEmailField(isLoading),
                          const SizedBox(height: 40),

                          // Error message
                          if (forgetPasswordState.error != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade300,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      forgetPasswordState.error!,
                                      style: TextStyle(
                                        color: Colors.red.shade200,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.red.shade300,
                                      size: 18,
                                    ),
                                    onPressed: () => ref
                                        .read(forgetPasswordProvider.notifier)
                                        .clearError(),
                                  ),
                                ],
                              ),
                            ),

                          // Success message
                          if (forgetPasswordState.data?.success == true)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade300,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          forgetPasswordState.data!.message,
                                          style: TextStyle(
                                            color: Colors.green.shade200,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Code expires in: ${forgetPasswordState.data?.data?.expiresIn ?? ""}',
                                          style: TextStyle(
                                            color: Colors.green.shade200,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Illustration
                          _buildIllustration(),
                          const SizedBox(height: 50),

                          // Send Reset Link Button
                          PrimaryGradientButton(
                            title: "Send Verification Code",
                            icon: Icons.send_rounded,
                            isLoading: isLoading,
                            onTap: _forgotPassword,
                            gradientColors: [
                              AppColors.cyberBlue,
                              AppColors.electricGold,
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Help Text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "We'll send a 6-digit verification code to your email address to reset your password.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        ref.read(forgetPasswordProvider.notifier).clearData();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildEmailField(bool isLoading) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          _emailFocusNode.requestFocus();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _emailFocusNode.hasFocus
                ? AppColors.cyberBlue
                : Colors.white.withOpacity(0.15),
            width: _emailFocusNode.hasFocus ? 2.0 : 1.0,
          ),
          gradient: LinearGradient(
            colors: _emailFocusNode.hasFocus
                ? [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.08),
                  ]
                : [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
          ),
          boxShadow: _emailFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _emailFocusNode.hasFocus
                    ? LinearGradient(
                        colors: [
                          AppColors.cyberBlue.withOpacity(0.3),
                          AppColors.electricGold.withOpacity(0.2),
                        ],
                      )
                    : null,
                color: _emailFocusNode.hasFocus ? null : Colors.transparent,
              ),
              child: Icon(
                Icons.email_outlined,
                color: _emailFocusNode.hasFocus
                    ? AppColors.cyberBlue
                    : Colors.white.withOpacity(0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.cyberBlue.withOpacity(0.1),
            AppColors.electricGold.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.mail_outline,
              size: 80,
              color: AppColors.cyberBlue.withOpacity(0.3),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.security_rounded,
                  size: 40,
                  color: AppColors.electricGold.withOpacity(0.8),
                ),
                const SizedBox(height: 10),
                Text(
                  "Secure Reset",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
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
}
