import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.appState,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isMobileValid = false;
  bool _otpGenerated = false;
  String? _simulatedOtp;
  bool _isVerifyEnabled = false;

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(() {
      setState(() {
        _isMobileValid = _mobileController.text.trim().length == 10;
      });
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var n in _otpFocusNodes) n.dispose();
    super.dispose();
  }

  void _generateOtp() {
    if (!_isMobileValid) return;

    setState(() {
      _otpGenerated = true;
      _simulatedOtp = '123456';
    });
    
    // Auto focus first OTP field
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _otpFocusNodes[0].requestFocus();
      }
    });

    widget.appState.addNotification(
      'OTP for login: $_simulatedOtp. Valid for 10 minutes.',
      'உள்நுழைவுக்கான OTP: $_simulatedOtp. 10 நிமிடங்களுக்கு மட்டுமே செல்லுபடியாகும்.',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP Sent! (Demo OTP: $_simulatedOtp)'),
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF145A32),
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    }
    _checkVerifyEnabled();
  }

  void _checkVerifyEnabled() {
    bool allFilled = _otpControllers.every((c) => c.text.isNotEmpty);
    if (_isVerifyEnabled != allFilled) {
      setState(() {
        _isVerifyEnabled = allFilled;
      });
    }
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp == _simulatedOtp || otp == '123456') {
      widget.appState.login(_mobileController.text.trim());
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP! Please enter the correct 6-digit number.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDF8), // Soft cream/white background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Brand Text
                    const Text(
                      'Abhiyant',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF145A32), // Dark Abhiyant green
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Empowering Farmers, Enriching India',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Page Title
                    const Text(
                      'Mobile Number Login',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 24, height: 1, color: const Color(0xFF2E7D32).withOpacity(0.3)),
                        const SizedBox(width: 8),
                        const Text(
                          'Enter your mobile number to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(width: 24, height: 1, color: const Color(0xFF2E7D32).withOpacity(0.3)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Mobile Number Input
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.phone_android, color: Color(0xFF145A32), size: 24),
                          ),
                          Row(
                            children: [
                              const Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 20),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              maxLength: 10,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Enter Mobile Number',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Generate OTP Button
                    ElevatedButton(
                      onPressed: _isMobileValid ? _generateOtp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF145A32),
                        disabledBackgroundColor: const Color(0xFF145A32).withOpacity(0.4),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: _isMobileValid ? 2 : 0,
                      ),
                      child: const Text(
                        'Generate OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // OTP Authentication Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FBF9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF145A32),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'OTP Authentication',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF145A32),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Enter the OTP sent to your mobile number',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // OTP Input Boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 45,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _otpFocusNodes[index].hasFocus 
                                      ? const Color(0xFF2E7D32) 
                                      : Colors.grey.shade300,
                                    width: _otpFocusNodes[index].hasFocus ? 2 : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  enabled: _otpGenerated,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  maxLength: 1,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF145A32)),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) => _onOtpChanged(value, index),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),
                          
                          // Verify OTP Button
                          ElevatedButton(
                            onPressed: _isVerifyEnabled ? _verifyOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF145A32),
                              disabledBackgroundColor: Colors.grey.shade400,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Verify OTP',
                              style: TextStyle(
                                color: _isVerifyEnabled ? Colors.white : Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Help Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.energy_savings_leaf, color: Color(0xFF2E7D32), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "We'll send a one-time password (OTP)\nto verify your mobile number.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60), // Space for bottom illustrations
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Agricultural Illustration using a Stack or fixed bottom widget
      bottomNavigationBar: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Abstract overlapping green curves to represent hills/fields
            Positioned(
              bottom: -20,
              left: -50,
              right: -50,
              height: 140,
              child: CustomPaint(
                painter: FieldPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple CustomPainter for the bottom field/hills illustration
class FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;
      
    final paintMid = Paint()
      ..color = const Color(0xFFC8E6C9).withOpacity(0.7)
      ..style = PaintingStyle.fill;
      
    final paintFront = Paint()
      ..color = const Color(0xFFA5D6A7).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Back Hill
    final pathBack = Path();
    pathBack.moveTo(0, size.height * 0.4);
    pathBack.quadraticBezierTo(size.width * 0.25, size.height * 0.1, size.width * 0.6, size.height * 0.3);
    pathBack.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.2);
    pathBack.lineTo(size.width, size.height);
    pathBack.lineTo(0, size.height);
    pathBack.close();
    canvas.drawPath(pathBack, paintBack);

    // Mid Hill
    final pathMid = Path();
    pathMid.moveTo(0, size.height * 0.5);
    pathMid.quadraticBezierTo(size.width * 0.3, size.height * 0.7, size.width * 0.7, size.height * 0.4);
    pathMid.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width, size.height * 0.5);
    pathMid.lineTo(size.width, size.height);
    pathMid.lineTo(0, size.height);
    pathMid.close();
    canvas.drawPath(pathMid, paintMid);

    // Front Hill
    final pathFront = Path();
    pathFront.moveTo(0, size.height * 0.7);
    pathFront.quadraticBezierTo(size.width * 0.4, size.height * 0.4, size.width, size.height * 0.8);
    pathFront.lineTo(size.width, size.height);
    pathFront.lineTo(0, size.height);
    pathFront.close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
