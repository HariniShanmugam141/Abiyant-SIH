import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
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
  final TextEditingController _otpController = TextEditingController();
  bool _otpGenerated = false;
  String? _simulatedOtp;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _generateOtp() {
    final mobile = _mobileController.text.trim();
    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'முறையான கைபேசி எண்ணை உள்ளிடவும் (10 இலக்கங்கள்)'
                : 'Please enter a valid 10-digit mobile number',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _otpGenerated = true;
      // Simple mock OTP for demo
      _simulatedOtp = '123456';
    });

    // Push simulated notification to state
    widget.appState.addNotification(
      'OTP for login: $_simulatedOtp. Valid for 10 minutes.',
      'உள்நுழைவுக்கான OTP: $_simulatedOtp. 10 நிமிடங்களுக்கு மட்டுமே செல்லுபடியாகும்.',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.appState.isTamil
              ? 'OTP அனுப்பப்பட்டது! (டெமோ OTP: 123456 - அறிவிப்பு மையத்தில் சரிபார்க்கவும்)'
              : 'OTP Sent! (Demo OTP: 123456 - check notification bar/app notifications)',
        ),
        duration: const Duration(seconds: 8),
        backgroundColor: const Color(0xFF0F5A24),
      ),
    );
  }

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length == 6) {
      widget.appState.login(_mobileController.text.trim());
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'தவறான OTP! தயவுசெய்து 6 இலக்க எண்ணை உள்ளிடவும்'
                : 'Invalid OTP! Please enter any 6-digit number.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Language Switcher Toggle
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => widget.appState.setLanguage(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isTamil ? const Color(0xFF0F5A24) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(19),
                                bottomLeft: Radius.circular(19),
                              ),
                            ),
                            child: Text(
                              'தமிழ்',
                              style: TextStyle(
                                color: isTamil ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.appState.setLanguage(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: !isTamil ? const Color(0xFF0F5A24) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(19),
                                bottomRight: Radius.circular(19),
                              ),
                            ),
                            child: Text(
                              'English',
                              style: TextStyle(
                                color: !isTamil ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Abhiyant Logo CustomPaint
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CustomPaint(
                    painter: AbhiyantLogoPainter(),
                  ),
                ),
                const SizedBox(height: 10),

                // App Title & Taglines
                Text(
                  AppTranslations.translate('app_name', isTamil),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F5A24),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppTranslations.translate('tagline_1', isTamil),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 25),

                // Mobile Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.phone_android, color: Color(0xFF0F5A24), size: 28),
                      ),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: AppTranslations.translate('mobile_number', isTamil),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // OTP Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.security, color: Color(0xFF0F5A24), size: 28),
                      ),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          enabled: _otpGenerated,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: AppTranslations.translate('enter_otp', isTamil),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Generate OTP Button
                ElevatedButton(
                  onPressed: _generateOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5A24),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    '${AppTranslations.translate('generate_otp', isTamil)} / Generate OTP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Verify OTP Button
                ElevatedButton(
                  onPressed: _otpGenerated ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _otpGenerated ? const Color(0xFF2E7D32) : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '${AppTranslations.translate('verify_otp', isTamil)} / Verify OTP',
                    style: TextStyle(
                      color: _otpGenerated ? Colors.white : Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Disclaimer Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    AppTranslations.translate('otp_disclaimer', isTamil),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Crops grid
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Crop.availableCrops.length,
                    itemBuilder: (context, index) {
                      final crop = Crop.availableCrops[index];
                      return GestureDetector(
                        onTap: () {
                          // Display a quick MSP information dialog when clicked on login screen
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Row(
                                children: [
                                  Icon(crop.iconData, color: crop.color),
                                  const SizedBox(width: 10),
                                  Text(AppTranslations.translate(crop.nameKey, isTamil)),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${isTamil ? 'அரசு ஆதரவு விலை (MSP):' : 'MSP Rate:'} ₹${crop.mspPrice.toStringAsFixed(2)} / Quintal',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('${isTamil ? 'அதிகபட்ச ஈரப்பதம்:' : 'Max Moisture Limit:'} ${crop.maxMoisture}%'),
                                  Text('${isTamil ? 'அதிகபட்ச குப்பை/தூசி:' : 'Max Foreign Matter:'} ${crop.maxTrash}%'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(isTamil ? 'சரி' : 'Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: crop.color.withOpacity(0.15),
                                radius: 22,
                                child: Icon(crop.iconData, color: crop.color, size: 24),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppTranslations.translate(crop.nameKey, isTamil),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // Government Logo CustomPaint
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: GovernmentLogoPainter(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Abhiyant Logo (Gear + Grain + Sun + Leaf)
class AbhiyantLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw gear outline (Green)
    final gearPaint = Paint()
      ..color = const Color(0xFF0F5A24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    
    canvas.drawCircle(center, radius, gearPaint);

    // Draw Gear teeth
    final teethPaint = Paint()
      ..color = const Color(0xFF0F5A24)
      ..style = PaintingStyle.fill;
    
    const teethCount = 12;
    for (int i = 0; i < teethCount; i++) {
      final double angle = (2 * 3.14159 * i) / teethCount;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final toothRect = Rect.fromLTWH(-6, -radius - 4, 12, 8);
      canvas.drawRect(toothRect, teethPaint);
      canvas.restore();
    }

    // Draw Sun inside (Top right quadrant) - Orange
    final sunPaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.fill;
    final sunCenter = Offset(center.dx + radius * 0.35, center.dy - radius * 0.35);
    canvas.drawCircle(sunCenter, radius * 0.25, sunPaint);
    
    // Sun rays
    final rayPaint = Paint()
      ..color = Colors.orange.shade700
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final double angle = (2 * 3.14159 * i) / 8;
      canvas.save();
      canvas.translate(sunCenter.dx, sunCenter.dy);
      canvas.rotate(angle);
      canvas.drawLine(Offset(radius * 0.3, 0), Offset(radius * 0.42, 0), rayPaint);
      canvas.restore();
    }

    // Draw Leaf (Green - left to center bottom)
    final leafPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.fill;
    
    final Path leafPath = Path();
    leafPath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.25);
    leafPath.quadraticBezierTo(
      center.dx + radius * 0.2, center.dy,
      center.dx + radius * 0.3, center.dy - radius * 0.15
    );
    leafPath.quadraticBezierTo(
      center.dx + radius * 0.4, center.dy + radius * 0.2,
      center.dx - radius * 0.2, center.dy + radius * 0.25
    );
    canvas.drawPath(leafPath, leafPaint);

    final Path leafPath2 = Path();
    leafPath2.moveTo(center.dx - radius * 0.1, center.dy + radius * 0.4);
    leafPath2.quadraticBezierTo(
      center.dx + radius * 0.35, center.dy + radius * 0.25,
      center.dx + radius * 0.48, center.dy + radius * 0.05
    );
    leafPath2.quadraticBezierTo(
      center.dx + radius * 0.52, center.dy + radius * 0.35,
      center.dx - radius * 0.1, center.dy + radius * 0.4
    );
    canvas.drawPath(leafPath2, leafPaint);

    // Draw Wheat Stalk (Gold - left side curving up)
    final wheatPaint = Paint()
      ..color = Colors.amber.shade700
      ..style = PaintingStyle.fill;

    // Wheat stem
    final stemPaint = Paint()
      ..color = Colors.amber.shade700
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final Path stemPath = Path();
    stemPath.moveTo(center.dx - radius * 0.5, center.dy + radius * 0.4);
    stemPath.quadraticBezierTo(
      center.dx - radius * 0.65, center.dy - radius * 0.2,
      center.dx - radius * 0.35, center.dy - radius * 0.6
    );
    canvas.drawPath(stemPath, stemPaint);

    // Wheat grains along stem
    for (int i = 0; i < 7; i++) {
      final double t = 0.2 + (i * 0.11);
      // Calculate quadratic Bezier point: B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
      final p0 = Offset(center.dx - radius * 0.5, center.dy + radius * 0.4);
      final p1 = Offset(center.dx - radius * 0.65, center.dy - radius * 0.2);
      final p2 = Offset(center.dx - radius * 0.35, center.dy - radius * 0.6);
      
      final dx = (1-t)*(1-t)*p0.dx + 2*(1-t)*t*p1.dx + t*t*p2.dx;
      final dy = (1-t)*(1-t)*p0.dy + 2*(1-t)*t*p1.dy + t*t*p2.dy;
      
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx - 5, dy), width: 7, height: 11),
        wheatPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx + 5, dy - 2), width: 7, height: 11),
        wheatPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Government of India logo
class GovernmentLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Left side: Draw State Emblem representation (simplified Sarnath lion capital structure)
    final emblemPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;

    const emblemCenter = Offset(35, 30);
    // Draw base abacus
    canvas.drawRect(
      Rect.fromCenter(center: Offset(emblemCenter.dx, emblemCenter.dy + 12), width: 28, height: 6),
      emblemPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(emblemCenter.dx, emblemCenter.dy + 8), width: 22, height: 6),
      emblemPaint,
    );
    // Draw bell base
    final Path bellPath = Path();
    bellPath.moveTo(emblemCenter.dx - 10, emblemCenter.dy + 18);
    bellPath.lineTo(emblemCenter.dx + 10, emblemCenter.dy + 18);
    bellPath.lineTo(emblemCenter.dx + 6, emblemCenter.dy + 23);
    bellPath.lineTo(emblemCenter.dx - 6, emblemCenter.dy + 23);
    bellPath.close();
    canvas.drawPath(bellPath, emblemPaint);

    // Draw main columns representing lions
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(emblemCenter.dx - 6, emblemCenter.dy - 2), width: 7, height: 16),
        const Radius.circular(1),
      ),
      emblemPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(emblemCenter.dx + 6, emblemCenter.dy - 2), width: 7, height: 16),
        const Radius.circular(1),
      ),
      emblemPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(emblemCenter.dx, emblemCenter.dy - 6), width: 9, height: 22),
        const Radius.circular(1),
      ),
      emblemPaint,
    );

    // Divider line between Emblem and Text
    final dividerPaint = Paint()
      ..color = Colors.orange.shade700
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(68, 12), const Offset(68, 48), dividerPaint);

    // Draw text: "भारत सरकार", "GOVERNMENT OF INDIA"
    final textPainter1 = TextPainter(
      text: const TextSpan(
        text: 'भारत सरकार',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter1.layout();
    textPainter1.paint(canvas, const Offset(76, 12));

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: 'GOVERNMENT OF INDIA',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(canvas, const Offset(76, 23));

    final greenTextPaint = Paint()
      ..color = Colors.green.shade700
      ..strokeWidth = 1;
    // Tiny indicator line under text
    canvas.drawLine(const Offset(76, 38), const Offset(190, 38), greenTextPaint);

    final textPainter3 = TextPainter(
      text: const TextSpan(
        text: 'सत्यमेव जयते',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter3.layout();
    textPainter3.paint(canvas, const Offset(76, 41));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
