import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import 'onboarding_wizard.dart';
import 'booking_screen.dart';
import 'queue_screen.dart';
import 'tracking_screen.dart';
import 'msp_info_screen.dart';
import 'notifications_screen.dart';
import 'admin_simulator.dart';
import 'login_screen.dart'; // import to reuse LogoPainter

class PortalMenuScreen extends StatelessWidget {
  final AppState appState;

  const PortalMenuScreen({super.key, required this.appState});

  void _checkRegistration(BuildContext context, VoidCallback onSuccess) {
    if (!appState.isRegistered) {
      // Alert dialog asking them to register first
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.lock_person, color: Colors.orange),
              SizedBox(width: 10),
              Text('Registration Required'),
            ],
          ),
          content: Text(
            appState.isTamil
                ? 'இந்த சேவையைப் பயன்படுத்த நீங்கள் முதலில் விவசாயி பதிவை முடிக்க வேண்டும். இப்போது பதிவு செய்ய விரும்புகிறீர்களா?'
                : 'You need to complete your Farmer Onboarding registration first to use this service. Register now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(appState.isTamil ? 'இல்லை' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingWizardScreen(
                      appState: appState,
                      onRegistrationSuccess: () {
                        Navigator.pop(context); // Close onboarding
                        onSuccess(); // Run the action
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5A24)),
              child: Text(appState.isTamil ? 'பதிவு செய்' : 'Register Now'),
            ),
          ],
        ),
      );
    } else {
      onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = appState.isTamil;

    // List of menu options from Image 4
    final List<Map<String, dynamic>> menuItems = [
      {
        'titleEn': 'Farmer Registration',
        'titleTa': 'பதிவு செய்யுங்கள்',
        'icon': Icons.person_add_alt_1,
        'color': const Color(0xFF0F5A24), // Green
        'action': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => OnboardingWizardScreen(
                appState: appState,
                onRegistrationSuccess: () {
                  Navigator.pop(context); // Pop onboarding
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Registration completed! Profile unlocked.'),
                      backgroundColor: Color(0xFF0F5A24),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
      {
        'titleEn': 'Reserve Your Slot',
        'titleTa': 'உங்கள் நேரத்தை முன்பதிவு செய்யுங்கள்',
        'icon': Icons.calendar_month,
        'color': Colors.orange.shade800,
        'action': (BuildContext ctx) {
          _checkRegistration(ctx, () {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => BookingScreen(appState: appState)),
            );
          });
        }
      },
      {
        'titleEn': 'Check Your Queue Status',
        'titleTa': 'உங்கள் வரிசை நிலையை பார்க்கவும்',
        'icon': Icons.people,
        'color': Colors.blue.shade800,
        'action': (BuildContext ctx) {
          _checkRegistration(ctx, () {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => QueueScreen(appState: appState)),
            );
          });
        }
      },
      {
        'titleEn': 'Alerts & Notifications',
        'titleTa': 'அறிவிப்புகள் மற்றும் செய்திகள்',
        'icon': Icons.notifications,
        'color': Colors.teal.shade700,
        'action': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => NotificationsScreen(appState: appState)),
          );
        }
      },
      {
        'titleEn': 'Track Procurement Status',
        'titleTa': 'கொள்முதல் நிலையை கண்காணிக்கவும்',
        'icon': Icons.check_box_outlined,
        'color': Colors.indigo.shade800,
        'action': (BuildContext ctx) {
          _checkRegistration(ctx, () {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => TrackingScreen(appState: appState)),
            );
          });
        }
      },
      {
        'titleEn': 'View Payment Status',
        'titleTa': 'கட்டண நிலையை பார்க்கவும்',
        'icon': Icons.account_balance_wallet,
        'color': Colors.cyan.shade800,
        'action': (BuildContext ctx) {
          _checkRegistration(ctx, () {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => TrackingScreen(appState: appState)),
            );
          });
        }
      },
      {
        'titleEn': 'Procurement Centres',
        'titleTa': 'கொள்முதல் மையங்கள்',
        'icon': Icons.location_on,
        'color': Colors.red.shade800,
        'action': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => MspInfoScreen(appState: appState)),
          );
        }
      },
      {
        'titleEn': 'Help & Support',
        'titleTa': 'உதவி மற்றும் ஆதரவு',
        'icon': Icons.headset_mic,
        'color': Colors.purple.shade700,
        'action': (BuildContext ctx) {
          _showHelpDialog(ctx, isTamil);
        }
      },
      {
        'titleEn': 'Reports & Insights',
        'titleTa': 'முன்னேற்ற அறிக்கைகள்',
        'icon': Icons.analytics,
        'color': Colors.green.shade800,
        'action': (BuildContext ctx) {
          _showReportsDialog(ctx, isTamil);
        }
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                // Top Header containing Language switch & Admin simulator access
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.developer_mode, color: Colors.redAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminSimulatorScreen(appState: appState)),
                        );
                      },
                      tooltip: 'Demo Simulator',
                    ),
                    // Language Switcher Toggle
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => appState.setLanguage(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => appState.setLanguage(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Abhiyant Logo CustomPaint
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CustomPaint(painter: AbhiyantLogoPainter()),
                ),
                const SizedBox(height: 10),

                // Abhiyant Title
                Text(
                  AppTranslations.translate('app_name', isTamil),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F5A24),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                
                // Tagline 1
                Text(
                  isTamil ? 'விவசாயியின் முன்னேற்றம், நாட்டின் வளர்ச்சி' : 'Growth of Farmers, Strength of Nation',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 15),

                // Mega Info Banner (Image 4 orange banner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.campaign, color: Colors.orange.shade800, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTamil
                                  ? 'உங்கள் பயிர், உங்கள் உரிமை - எங்கள் உறுதி சேவை!'
                                  : 'Your Crop, Your Right - Our Commitment!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // List of 9 Menu Items
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    final title = isTamil ? item['titleTa'] : item['titleEn'];
                    
                    // Show small check icon if user has already completed registration
                    final isRegItem = index == 0;
                    final bool showCompleted = isRegItem && appState.isRegistered;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        onTap: () => item['action'](context),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'], color: item['color'], size: 22),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showCompleted) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Text(
                                  isTamil ? 'சரிபார்க்கப்பட்டது' : 'Completed',
                                  style: TextStyle(color: Colors.green.shade800, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Footer Text & Tractor Landscape Design
                Center(
                  child: Column(
                    children: [
                      Text(
                        isTamil ? 'விவசாயம் காப்போம், வளம் பெருக்குவோம்!' : "Let's Protect Farming, Let's Prosper Together!",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      // Tractor illustration
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: FarmFooterPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context, bool isTamil) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.purple),
            const SizedBox(width: 10),
            Text(isTamil ? 'உதவி மற்றும் ஆதரவு' : 'Help & Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isTamil ? 'அரசு கொள்முதல் உதவி எண்கள்:' : 'Govt Procurement Helpline Numbers:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(isTamil ? 'தொலைபேசி: 1800 180 1551 (இலவசம்)' : 'Toll-Free: 1800 180 1551'),
            Text(isTamil ? 'மின்னஞ்சல்: support.abhiyant@gov.in' : 'Email: support.abhiyant@gov.in'),
            const SizedBox(height: 15),
            Text(
              isTamil ? 'துரித உதவி அரட்டை:' : 'Quick Helper Chatbot:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isTamil ? 'அரட்டை சேவை விரைவில் தொடங்கப்படும்!' : 'AI Chatbot service will launch shortly!'),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
              icon: const Icon(Icons.chat),
              label: Text(isTamil ? 'AI உதவியாளரைத் தொடங்கு' : 'Start AI Assistant'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isTamil ? 'மூடு' : 'Close'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog(BuildContext context, bool isTamil) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.bar_chart, color: Colors.green),
            const SizedBox(width: 10),
            Text(isTamil ? 'கொள்முதல் முன்னேற்றம் (Thanjavur)' : 'District Progress (Thanjavur)'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTargetProgress(isTamil ? 'நெல் (Paddy)' : 'Paddy target', 0.85, isTamil),
            _buildTargetProgress(isTamil ? 'கோதுமை (Wheat)' : 'Wheat target', 0.62, isTamil),
            _buildTargetProgress(isTamil ? 'பருத்தி (Cotton)' : 'Cotton target', 0.44, isTamil),
            _buildTargetProgress(isTamil ? 'கரும்பு (Sugarcane)' : 'Sugarcane target', 0.91, isTamil),
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
  }

  Widget _buildTargetProgress(String label, double value, bool isTamil) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text('${(value * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Farm Landscape & Tractor (matching footer banner in mockup)
class FarmFooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw green hills
    final hillPaint = Paint()
      ..color = Colors.green.shade100
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height - 15, size.width * 0.5, size.height);
    path.quadraticBezierTo(size.width * 0.75, size.height - 20, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, hillPaint);

    final hillPaint2 = Paint()
      ..color = Colors.green.shade200
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(size.width * 0.35, size.height - 8, size.width * 0.7, size.height - 12);
    path2.quadraticBezierTo(size.width * 0.85, size.height - 6, size.width, size.height);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, hillPaint2);

    // Draw a small simplified tractor on the right side
    final tractorPaint = Paint()
      ..color = const Color(0xFF0F5A24)
      ..style = PaintingStyle.fill;

    final double xOffset = size.width - 60;
    final double yOffset = size.height - 22;

    // Body
    canvas.drawRect(Rect.fromLTWH(xOffset, yOffset, 20, 10), tractorPaint);
    // Cabin
    canvas.drawRect(Rect.fromLTWH(xOffset + 4, yOffset - 8, 10, 8), tractorPaint);
    
    // Wheels (Black)
    final wheelPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(xOffset + 4, yOffset + 10), 5, wheelPaint); // Front wheel
    canvas.drawCircle(Offset(xOffset + 16, yOffset + 8), 7, wheelPaint); // Back wheel

    // Chimney (Smoke pipe)
    final pipePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(xOffset + 2, yOffset), Offset(xOffset + 2, yOffset - 10), pipePaint);

    // Draw some tiny wheat icons on the left side
    final wheatPaint = Paint()
      ..color = Colors.amber.shade700
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final double wx = 20.0 + (i * 20.0);
      final double wy = size.height - 5;
      
      canvas.drawOval(Rect.fromCenter(center: Offset(wx, wy - 10), width: 3, height: 8), wheatPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(wx - 3, wy - 8), width: 2, height: 6), wheatPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(wx + 3, wy - 8), width: 2, height: 6), wheatPaint);
      
      final stemPaint = Paint()
        ..color = Colors.green.shade600
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(wx, wy), Offset(wx, wy - 10), stemPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
