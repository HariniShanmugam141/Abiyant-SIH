import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'link_family_member_screen.dart';
import 'portal_menu_screen.dart';

class AccessTypeSelectionScreen extends StatelessWidget {
  final AppState appState;

  const AccessTypeSelectionScreen({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDF8), // Warm off-white/cream background
      body: SafeArea(
        child: Stack(
          children: [
            // Bottom Landscape Illustration
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 140,
              child: CustomPaint(
                painter: FieldPainter(),
              ),
            ),
            
            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Brand Name and Tagline
                  const Text(
                    'Abhiyant',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF145A32),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Empowering Farmers, Enriching India',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // Main Title
                  const Text(
                    'Choose Your Access Type',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF145A32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle with dashes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 24, height: 1, color: const Color(0xFF2E7D32).withOpacity(0.4)),
                      const SizedBox(width: 8),
                      const Text(
                        'Select the option that works best for you',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 24, height: 1, color: const Color(0xFF2E7D32).withOpacity(0.4)),
                    ],
                  ),
                  const SizedBox(height: 36),
                  
                  // Access Cards
                  _buildAccessCard(
                    context: context,
                    icon: Icons.smartphone,
                    title: 'I have a smartphone',
                    description: 'Access all features and services\non your personal smartphone',
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => PortalMenuScreen(appState: appState),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccessCard(
                    context: context,
                    icon: Icons.phone_android,
                    title: 'I use a basic phone',
                    description: 'Get updates and services through\nSMS and voice calls',
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccessCard(
                    context: context,
                    icon: Icons.group,
                    title: "Link a family member's smartphone",
                    description: 'Allow a trusted family member to\nhelp you access all services',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LinkFamilyMemberScreen(appState: appState),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Privacy Message
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.energy_savings_leaf, color: Color(0xFF2E7D32), size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        "Your information is safe and will only be used\nto improve your experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 140), // Extra space to scroll above the fixed landscape
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F5E9), width: 2), // Soft pale-green border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon section with circle and leaf accent
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9), // Very light green
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
                  ),
                  child: Icon(icon, color: const Color(0xFF2E7D32), size: 30),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: const Icon(
                      Icons.eco,
                      color: Color(0xFF66BB6A),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF145A32), // Dark green title
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Chevron arrow
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF2E7D32),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter for the bottom field/hills illustration (reused from login_screen)
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
