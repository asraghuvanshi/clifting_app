import 'package:clifting_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:clifting_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token;
  
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordStrengthVisible = false;
  double _passwordStrength = 0.0;
  bool _showPasswordError = false;
  bool _showConfirmPasswordError = false;
  String _passwordErrorText = '';
  String _confirmPasswordErrorText = '';

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode.addListener(_onFocusChange);
    _confirmPasswordFocusNode.addListener(_onFocusChange);
    
    // Listen to password changes to calculate strength
    _newPasswordController.addListener(_updatePasswordStrength);
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _updatePasswordStrength() {
    final password = _newPasswordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrengthVisible = false;
        _passwordStrength = 0.0;
      });
      return;
    }

    setState(() {
      _passwordStrengthVisible = true;
      
      double strength = 0.0;
      
      // Length check
      if (password.length >= 8) strength += 0.25;
      
      // Uppercase check
      if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
      
      // Lowercase check
      if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
      
      // Number/Special character check
      if (password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
      
      _passwordStrength = strength;
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.removeListener(_onFocusChange);
    _confirmPasswordFocusNode.removeListener(_onFocusChange);
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _validatePassword() {
    final password = _newPasswordController.text;
    
    if (password.isEmpty) {
      setState(() {
        _showPasswordError = true;
        _passwordErrorText = 'Please enter a password';
      });
      return false;
    }
    
    if (password.length < 8) {
      setState(() {
        _showPasswordError = true;
        _passwordErrorText = 'Password must be at least 8 characters';
      });
      return false;
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _showPasswordError = true;
        _passwordErrorText = 'Include at least one uppercase letter';
      });
      return false;
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      setState(() {
        _showPasswordError = true;
        _passwordErrorText = 'Include at least one lowercase letter';
      });
      return false;
    }
    
    if (!password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _showPasswordError = true;
        _passwordErrorText = 'Include a number or special character';
      });
      return false;
    }
    
    setState(() {
      _showPasswordError = false;
      _passwordErrorText = '';
    });
    return true;
  }

  bool _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    
    if (confirmPassword.isEmpty) {
      setState(() {
        _showConfirmPasswordError = true;
        _confirmPasswordErrorText = 'Please confirm your password';
      });
      return false;
    }
    
    if (confirmPassword != _newPasswordController.text) {
      setState(() {
        _showConfirmPasswordError = true;
        _confirmPasswordErrorText = 'Passwords do not match';
      });
      return false;
    }
    
    setState(() {
      _showConfirmPasswordError = false;
      _confirmPasswordErrorText = '';
    });
    return true;
  }

  Future<void> _resetPassword() async {
    // Clear previous errors
    setState(() {
      _showPasswordError = false;
      _showConfirmPasswordError = false;
      _passwordErrorText = '';
      _confirmPasswordErrorText = '';
    });

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool isValid = true;

    // Validate new password
    if (!_validatePassword()) {
      isValid = false;
    }

    // Validate confirm password
    if (!_validateConfirmPassword()) {
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    try {
      // await ref.read(authProvider.notifier).resetPassword(
      //   email: widget.email,
      //   token: widget.token,
      //   newPassword: newPassword,
      // );

      final state = ref.read(authProvider);

      if (state is ResetPasswordSuccess) {
        final response = state.response;

        if (response.success) {
          _showSuccessMessage(response.message);
          
          Future.delayed(const Duration(milliseconds: 2000), () {
            // Navigate back to login or success screen
            Navigator.popUntil(context, (route) => route.isFirst);
          });
        } else {
          _showErrorDialog(response.message);
        }
      } else if (state is AuthError) {
        _showErrorDialog(state.message);
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              'Error',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'TRY AGAIN',
              style: TextStyle(color: AppColors.cyberBlue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _getPasswordStrengthText() {
    if (_passwordStrength >= 0.75) return 'Strong';
    if (_passwordStrength >= 0.5) return 'Good';
    if (_passwordStrength >= 0.25) return 'Fair';
    return 'Weak';
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrength >= 0.75) return Colors.green;
    if (_passwordStrength >= 0.5) return Colors.lightGreen;
    if (_passwordStrength >= 0.25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

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
                              AppColors.cyberBlue,
                              Color(0xFF00D4FF),
                              AppColors.electricGold,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(bounds),
                          child: const Text(
                            "New Password",
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
                                text: "Create a strong new password\n",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: "for your account ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const TextSpan(
                                text: "🔐",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),

                        // New Password Field
                        _buildNewPasswordField(isLoading),
                        const SizedBox(height: 8),
                        
                        // Password Error Text
                        if (_showPasswordError)
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _passwordErrorText,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),

                        // Password Strength Indicator
                        if (_passwordStrengthVisible)
                          _buildPasswordStrengthIndicator(),
                        if (_passwordStrengthVisible) const SizedBox(height: 20),

                        // Confirm Password Field
                        _buildConfirmPasswordField(isLoading),
                        const SizedBox(height: 8),
                        
                        // Confirm Password Error Text
                        if (_showConfirmPasswordError)
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _confirmPasswordErrorText,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 40),

                        // Password Requirements
                        _buildPasswordRequirements(),
                        const SizedBox(height: 40),

                        // Reset Button
                        _buildResetButton(isLoading),
                        const SizedBox(height: 30),

                        // Success Message
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_user_rounded,
                                    color: Colors.green.withOpacity(0.8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Secure & Encrypted",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Your password will be securely encrypted. After reset, you'll be redirected to login.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildNewPasswordField(bool isLoading) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          _newPasswordFocusNode.requestFocus();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showPasswordError
                ? Colors.red
                : _newPasswordFocusNode.hasFocus
                    ? AppColors.cyberBlue
                    : Colors.white.withOpacity(0.15),
            width: _newPasswordFocusNode.hasFocus || _showPasswordError ? 2.0 : 1.0,
          ),
          gradient: LinearGradient(
            colors: _newPasswordFocusNode.hasFocus
                ? [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.08),
                  ]
                : [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
          ),
          boxShadow: _newPasswordFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : _showPasswordError
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
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
                gradient: _newPasswordFocusNode.hasFocus
                    ? LinearGradient(
                        colors: [
                          AppColors.cyberBlue.withOpacity(0.3),
                          AppColors.electricGold.withOpacity(0.2),
                        ],
                      )
                    : null,
                color: _newPasswordFocusNode.hasFocus ? null : Colors.transparent,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: _showPasswordError
                    ? Colors.red
                    : _newPasswordFocusNode.hasFocus
                        ? AppColors.cyberBlue
                        : Colors.white.withOpacity(0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _newPasswordController,
                focusNode: _newPasswordFocusNode,
                obscureText: _obscureNewPassword,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.visiblePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // Clear error when user starts typing
                  if (_showPasswordError && value.isNotEmpty) {
                    setState(() {
                      _showPasswordError = false;
                      _passwordErrorText = '';
                    });
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(bool isLoading) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          _confirmPasswordFocusNode.requestFocus();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showConfirmPasswordError
                ? Colors.red
                : _confirmPasswordFocusNode.hasFocus
                    ? AppColors.cyberBlue
                    : Colors.white.withOpacity(0.15),
            width: _confirmPasswordFocusNode.hasFocus || _showConfirmPasswordError ? 2.0 : 1.0,
          ),
          gradient: LinearGradient(
            colors: _confirmPasswordFocusNode.hasFocus
                ? [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.08),
                  ]
                : [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
          ),
          boxShadow: _confirmPasswordFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.cyberBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : _showConfirmPasswordError
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
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
                gradient: _confirmPasswordFocusNode.hasFocus
                    ? LinearGradient(
                        colors: [
                          AppColors.cyberBlue.withOpacity(0.3),
                          AppColors.electricGold.withOpacity(0.2),
                        ],
                      )
                    : null,
                color: _confirmPasswordFocusNode.hasFocus ? null : Colors.transparent,
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                color: _showConfirmPasswordError
                    ? Colors.red
                    : _confirmPasswordFocusNode.hasFocus
                        ? AppColors.cyberBlue
                        : Colors.white.withOpacity(0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.visiblePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: "Confirm new password",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // Clear error when user starts typing
                  if (_showConfirmPasswordError && value.isNotEmpty) {
                    setState(() {
                      _showConfirmPasswordError = false;
                      _confirmPasswordErrorText = '';
                    });
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Password Strength:",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _getPasswordStrengthText(),
              style: TextStyle(
                color: _getPasswordStrengthColor(),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: _getPasswordStrengthColor().withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _passwordStrength,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getPasswordStrengthColor(),
                    _getPasswordStrengthColor().withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: _getPasswordStrengthColor().withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${(_passwordStrength * 100).toInt()}% secure",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.01),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: AppColors.electricGold.withOpacity(0.8),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Password Requirements",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildRequirementRow(
            "At least 8 characters",
            _newPasswordController.text.length >= 8,
          ),
          _buildRequirementRow(
            "One uppercase letter (A-Z)",
            _newPasswordController.text.contains(RegExp(r'[A-Z]')),
          ),
          _buildRequirementRow(
            "One lowercase letter (a-z)",
            _newPasswordController.text.contains(RegExp(r'[a-z]')),
          ),
          _buildRequirementRow(
            "One number or special character",
            _newPasswordController.text.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]')),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              border: Border.all(
                color: isMet ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Icon(
              isMet ? Icons.check : Icons.close,
              size: 14,
              color: isMet ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration: isMet ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(bool isLoading) {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
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
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: isLoading ? null : _resetPassword,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isLoading
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF00D4FF),
                        Color(0xFF00FF88),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xFF00D4FF), // Cyan
                        Color(0xFF00FF88), // Green for success
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  )
                else
                  const Text(
                    "RESET PASSWORD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                if (!isLoading) const SizedBox(width: 10),
                if (!isLoading)
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}