import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String expiresIn;
  final String resendAfter;

  const OTPVerificationScreen({super.key, required this.email, required this.expiresIn ,required this.resendAfter});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  int _currentIndex = 0;
  int _resendCountdown = 30;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();

    // Set up focus listeners
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (_otpFocusNodes[i].hasFocus) {
          setState(() => _currentIndex = i);
        }
      });
    }
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendCountdown();
      }
    });
  }

  void _handleOTPChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    bool allFilled = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (allFilled) {
      _verifyOTP();
    }
  }

  void _verifyOTP() {
    HapticFeedback.heavyImpact();
    setState(() => _isVerifying = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isVerifying = false);
      // Navigate to reset password screen or show success
      // Navigator.pushReplacement(...);
    });
  }

  void _resendOTP() {
    if (_resendCountdown == 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _resendCountdown = 30;
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _otpFocusNodes[0].requestFocus();
      });
      _startResendCountdown();

      // Simulate OTP resend
      // TODO: Implement OTP resend logic
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackButton(),
                        const SizedBox(height: 40),

                        // Animated Title
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.electricGold,
                              Color(0xFFFFD700),
                              AppColors.cyberBlue,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(bounds),
                          child: const Text(
                            "Verification",
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
                                text: "Enter the 6-digit code sent to\n",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: widget.email,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.cyberBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: " 🔒",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),

                        // OTP Input Fields
                        _buildOTPInput(),
                        const SizedBox(height: 40),

                        // Resend Code
                        _buildResendCode(),
                        const SizedBox(height: 50),

                        // Verification Button
                        _buildVerifyButton(),
                        const SizedBox(height: 30),

                        // Help Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "The code will expire in 5 minutes. Make sure to enter it before it expires.",
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
              ],
            ),
          ),

          // Loading Overlay
          if (_isVerifying) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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

  Widget _buildOTPInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return _buildOTPBox(index);
          }),
        ),
        const SizedBox(height: 30),

        // Visual Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentIndex == index
                    ? AppColors.cyberBlue
                    : Colors.white.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOTPBox(int index) {
    bool isFocused = _otpFocusNodes[index].hasFocus;
    bool hasValue = _otpControllers[index].text.isNotEmpty;

    return GestureDetector(
      onTap: () {
        _otpFocusNodes[index].requestFocus();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 52,
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused
                ? AppColors.cyberBlue
                : hasValue
                ? AppColors.electricGold
                : Colors.white.withOpacity(0.15),
            width: isFocused ? 2.0 : 1.0,
          ),
          gradient: isFocused
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.08),
                  ],
                )
              : hasValue
              ? LinearGradient(
                  colors: [
                    AppColors.electricGold.withOpacity(0.1),
                    AppColors.electricGold.withOpacity(0.05),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : hasValue
              ? [
                  BoxShadow(
                    color: AppColors.electricGold.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              isCollapsed: true,
            ),
            onChanged: (value) => _handleOTPChange(value, index),
          ),
        ),
      ),
    );
  }

  Widget _buildResendCode() {
    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _resendOTP,
          child: MouseRegion(
            cursor: _resendCountdown == 0
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: _resendCountdown == 0
                    ? LinearGradient(
                        colors: [
                          AppColors.cyberBlue.withOpacity(0.2),
                          AppColors.electricGold.withOpacity(0.1),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                border: Border.all(
                  color: _resendCountdown == 0
                      ? AppColors.cyberBlue.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    color: _resendCountdown == 0
                        ? AppColors.cyberBlue
                        : Colors.white.withOpacity(0.4),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _resendCountdown == 0
                        ? "RESEND CODE"
                        : "Resend in $_resendCountdown", // ✅ CORRECTED - removed the extra 's'
                    style: TextStyle(
                      color: _resendCountdown == 0
                          ? AppColors.cyberBlue
                          : Colors.white.withOpacity(0.4),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    bool isEnabled = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );

    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: isEnabled && !_isVerifying
            ? [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF00FF88).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: isEnabled && !_isVerifying ? _verifyOTP : null,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isEnabled && !_isVerifying
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF00D4FF), // Cyan
                        Color(0xFF00FF88), // Green
                        Color(0xFF00D4FF), // Cyan
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isEnabled && !_isVerifying
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isVerifying)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  )
                else
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                const SizedBox(width: 10),
                Text(
                  _isVerifying ? "VERIFYING..." : "VERIFY CODE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    shadows: isEnabled && !_isVerifying
                        ? const [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.cyberBlue),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
