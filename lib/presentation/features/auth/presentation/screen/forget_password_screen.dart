// import 'package:clifting_app/features/auth/presentation/notifier/auth_notifier.dart';
// import 'package:clifting_app/features/auth/presentation/provider/auth_provider.dart';
// import 'package:clifting_app/features/auth/presentation/screen/otp_verification_screen.dart';
// import 'package:clifting_app/utility/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ForgotPasswordScreen extends ConsumerStatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   ConsumerState<ForgotPasswordScreen> createState() =>
//       _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
//   final _emailController = TextEditingController();
//   final _emailFocusNode = FocusNode();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _emailFocusNode.addListener(_onFocusChange);
//   }

//   void _onFocusChange() {
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _emailFocusNode.removeListener(_onFocusChange);
//     _emailFocusNode.dispose();
//     super.dispose();
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }

//     final emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );

//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }

//     return null;
//   }

//   Future<void> _forgotPassword() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final email = _emailController.text.trim();

//     try {
//       await ref.read(authProvider.notifier).forgetPassword(email);

//       final state = ref.read(authProvider);

//       if (state is ResetPasswordSuccess) {
//         final response = state.response;

//         if (response.success && response.data != null) {
//           final responseEmail = response.data?.email ?? email;
//           final expiresIn = response.data?.expiresIn ?? '10 minutes';
//           final resendAfter = response.data?.resendAfter ?? '60 seconds';
//           final message = response.message;

//           _showSuccessMessage(message);

//           Future.delayed(const Duration(milliseconds: 1500), () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OTPVerificationScreen(
//                   email: responseEmail,
//                   expiresIn: expiresIn,
//                   resendAfter: resendAfter,
//                 ),
//               ),
//             );
//           });
//         } else if (response.success && response.data == null) {
//           _showErrorDialog(
//             'Email not registered. Please check your email address.',
//           );
//         } else {
//           _showErrorDialog(response.message);
//         }
//       } else if (state is AuthError) {
//         _showErrorDialog(state.message);
//       }
//     } catch (error) {
//       _showErrorDialog(error.toString());
//     }
//   }

//   void _showSuccessMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A2E),
//         surfaceTintColor: Colors.transparent,
//         title: const Text(
//           'Error',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Text(message, style: const TextStyle(color: Colors.white70)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'OK',
//               style: TextStyle(color: AppColors.cyberBlue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final isLoading = authState is AuthLoading;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0A0A0A),
//                   AppColors.midnightBlue,
//                   Color(0xFF1A1A2E),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.0, 0.5, 1.0],
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 colors: [Colors.white.withOpacity(0.02), Colors.transparent],
//                 radius: 1.5,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 40,
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildBackButton(),
//                           const SizedBox(height: 40),

//                           // Animated Title
//                           ShaderMask(
//                             shaderCallback: (bounds) => const LinearGradient(
//                               colors: [
//                                 AppColors.cyberBlue,
//                                 Color(0xFF00D4FF),
//                                 AppColors.electricGold,
//                               ],
//                               stops: [0.0, 0.5, 1.0],
//                             ).createShader(bounds),
//                             child: const Text(
//                               "Reset Password",
//                               style: TextStyle(
//                                 fontSize: 42,
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: 2,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Enter your email to receive\n",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white.withOpacity(0.9),
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "password reset instructions ",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white.withOpacity(0.9),
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                                 const TextSpan(
//                                   text: "📧",
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 60),

//                           // Email Field
//                           _buildEmailField(isLoading),
//                           const SizedBox(height: 40),

//                           // Illustration
//                           _buildIllustration(),
//                           const SizedBox(height: 50),

//                           // Send Reset Link Button
//                           _buildSendResetButton(isLoading),
//                           const SizedBox(height: 30),

//                           // Help Text
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Text(
//                               "We'll send a 6-digit verification code to your email address to reset your password.",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.6),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w300,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackButton() {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//             colors: [
//               Colors.white.withOpacity(0.1),
//               Colors.white.withOpacity(0.05),
//             ],
//           ),
//           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//         ),
//         child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
//       ),
//     );
//   }

//   Widget _buildEmailField(bool isLoading) {
//     return GestureDetector(
//       onTap: () {
//         if (!isLoading) {
//           _emailFocusNode.requestFocus();
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         height: 60,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: _emailFocusNode.hasFocus
//                 ? AppColors.cyberBlue
//                 : Colors.white.withOpacity(0.15),
//             width: _emailFocusNode.hasFocus ? 2.0 : 1.0,
//           ),
//           gradient: LinearGradient(
//             colors: _emailFocusNode.hasFocus
//                 ? [
//                     Colors.white.withOpacity(0.12),
//                     Colors.white.withOpacity(0.08),
//                   ]
//                 : [
//                     Colors.white.withOpacity(0.05),
//                     Colors.white.withOpacity(0.02),
//                   ],
//           ),
//           boxShadow: _emailFocusNode.hasFocus
//               ? [
//                   BoxShadow(
//                     color: AppColors.cyberBlue.withOpacity(0.3),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                   ),
//                 ]
//               : [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                 ],
//         ),
//         child: Row(
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: _emailFocusNode.hasFocus
//                     ? LinearGradient(
//                         colors: [
//                           AppColors.cyberBlue.withOpacity(0.3),
//                           AppColors.electricGold.withOpacity(0.2),
//                         ],
//                       )
//                     : null,
//                 color: _emailFocusNode.hasFocus ? null : Colors.transparent,
//               ),
//               child: Icon(
//                 Icons.email_outlined,
//                 color: _emailFocusNode.hasFocus
//                     ? AppColors.cyberBlue
//                     : Colors.white.withOpacity(0.7),
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: TextFormField(
//                 controller: _emailController,
//                 focusNode: _emailFocusNode,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: _validateEmail,
//                 enabled: !isLoading, // Disable field when loading
//                 decoration: InputDecoration(
//                   hintText: "Enter your email",
//                   hintStyle: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontWeight: FontWeight.w300,
//                   ),
//                   border: InputBorder.none,
//                   isCollapsed: true,
//                   errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
//                 ),
//                 textInputAction: TextInputAction.done,
//                 // Only submit when button is pressed, not on keyboard done
//                 onFieldSubmitted: isLoading
//                     ? null
//                     : (_) {
//                         // Remove API call from here
//                         // Keep empty or add a different action if needed
//                       },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIllustration() {
//     return Container(
//       height: 150,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: LinearGradient(
//           colors: [
//             AppColors.cyberBlue.withOpacity(0.1),
//             AppColors.electricGold.withOpacity(0.05),
//           ],
//         ),
//         border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             right: 20,
//             top: 20,
//             child: Icon(
//               Icons.mail_outline,
//               size: 80,
//               color: AppColors.cyberBlue.withOpacity(0.3),
//             ),
//           ),
//           Positioned(
//             left: 30,
//             bottom: 30,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.security_rounded,
//                   size: 40,
//                   color: AppColors.electricGold.withOpacity(0.8),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Secure Reset",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSendResetButton(bool isLoading) {
//     return Container(
//       height: 58,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF00D4FF).withOpacity(0.4),
//             blurRadius: 25,
//             spreadRadius: 0,
//             offset: const Offset(0, 10),
//           ),
//           BoxShadow(
//             color: const Color(0xFFFF0080).withOpacity(0.3),
//             blurRadius: 15,
//             spreadRadius: 0,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(30),
//           onTap: isLoading
//               ? null
//               : () {
//                   HapticFeedback.heavyImpact();
//                   _forgotPassword();
//                 },
//           splashColor: Colors.white.withOpacity(0.3),
//           highlightColor: Colors.white.withOpacity(0.2),
//           child: Ink(
//             decoration: BoxDecoration(
//               gradient: isLoading
//                   ? LinearGradient(colors: [Colors.grey, Colors.grey.shade700])
//                   : const LinearGradient(
//                       colors: [
//                         Color(0xFF00D4FF), // Cyan
//                         Color(0xFFFF0080), // Magenta
//                         Color(0xFFFF8C00), // Orange
//                       ],
//                       stops: [0.0, 0.5, 1.0],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (isLoading)
//                   SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.white.withOpacity(0.8),
//                       ),
//                     ),
//                   )
//                 else
//                   const Text(
//                     "SEND VERIFICATION CODE",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: 1.5,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black26,
//                           blurRadius: 4,
//                           offset: Offset(1, 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (!isLoading) const SizedBox(width: 10),
//                 if (!isLoading)
//                   const Icon(
//                     Icons.send_rounded,
//                     color: Colors.white,
//                     size: 22,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black26,
//                         blurRadius: 4,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
