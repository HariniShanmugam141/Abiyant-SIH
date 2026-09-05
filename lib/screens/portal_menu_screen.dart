import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'my_crops_screen.dart';
import 'onboarding_wizard.dart';
import 'booking_screen.dart';
import 'queue_screen.dart';
import 'tracking_screen.dart';
import 'msp_info_screen.dart';
import 'notifications_screen.dart';
import 'admin_simulator.dart';
import 'my_lands_screen.dart';
import 'weather_alerts_screen.dart';
import 'payment_details_screen.dart';
class PortalMenuScreen extends StatelessWidget {
  final AppState appState;
  const PortalMenuScreen({super.key, required this.appState});

  static const _bg = Color(0xFFFBF8F1);
  static const _deepGreen = Color(0xFF064E2A);
  static const _orange = Color(0xFFD84315);
  static const _orangeLight = Color(0xFFFFF3E0);
  static const _orangeBorder = Color(0xFFFFCC80);

  void _go(BuildContext ctx, Widget w) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => w));

  void _needReg(BuildContext ctx, VoidCallback ok) {
    if (appState.isRegistered) {
      ok();
      return;
    }
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.lock_rounded, color: Colors.orange),
          SizedBox(width: 10),
          Flexible(
              child: Text('Registration Required',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        ]),
        content: const Text(
            'Please complete Farmer Registration first to unlock this feature.',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _deepGreen),
            onPressed: () {
              Navigator.pop(ctx);
              _go(
                  ctx,
                  OnboardingWizardScreen(
                    appState: appState,
                    onRegistrationSuccess: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text('Registration completed!'),
                        backgroundColor: _deepGreen,
                      ));
                    },
                  ));
            },
            child: const Text('Register Now',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<_CardData> _cards(BuildContext ctx) => [
        _CardData(
          icon: Icons.person_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          hasCheckmark: true,
          title: 'Farmer Registration',
          desc: 'Register and manage farmer identity and verification',
          onTap: () => _go(
              ctx,
              OnboardingWizardScreen(
                appState: appState,
                onRegistrationSuccess: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                    content: Text('Registration completed! Profile unlocked.'),
                    backgroundColor: _deepGreen,
                  ));
                },
              )),
        ),
        _CardData(
          icon: Icons.location_on_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF33691E),
          hasLeaves: true,
          title: 'My Lands',
          desc: 'View registered lands and add/manage land details',
          onTap: () => _needReg(
              ctx,
              () => _go(ctx, MyLandsScreen(appState: appState))),
        ),
        _CardData(
          icon: Icons.grass_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF388E3C),
          title: 'My Crops',
          desc: 'Register crops, view crop details and cultivation info',
          onTap: () => _needReg(
              ctx,
              () => _go(ctx, MyCropsScreen(appState: appState))),
        ),
        _CardData(
          icon: Icons.eco_rounded,
          iconBg: const Color(0xFFF1F8E9),
          iconColor: const Color(0xFFF57F17),
          title: 'Harvest Management',
          desc: 'Update harvest readiness, expected date and quantity',
          onTap: () => _needReg(
              ctx,
              () => ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Harvest – coming soon')))),
        ),
        _CardData(
          icon: Icons.calendar_today_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF1B5E20),
          title: 'Reserve Your Slot',
          desc: 'Find procurement centres, check slots and book',
          onTap: () => _go(ctx, BookingScreen(appState: appState)),
        ),
        _CardData(
          icon: Icons.people_alt_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          title: 'Live Queue & Smart Travel',
          desc: 'Check your token, queue status and travel recommendation',
          onTap: () =>
              _needReg(ctx, () => _go(ctx, QueueScreen(appState: appState))),
        ),
        _CardData(
          isWeatherIcon: true,
          iconBg: const Color(0xFFF1F8E9),
          iconColor: Colors.transparent, // handled by custom painter
          title: 'Weather & Alerts',
          desc: 'Check weather, alerts and travel advisories',
          onTap: () => _go(ctx, WeatherAlertsScreen(appState: appState)),
        ),
        _CardData(
          icon: Icons.local_shipping_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF1B5E20),
          hasGrain: true,
          title: 'Procurement & Grain Tracking',
          desc: 'Track check-in, handover, inspection and approval',
          onTap: () =>
              _needReg(ctx, () => _go(ctx, TrackingScreen(appState: appState))),
        ),
        _CardData(
          icon: Icons.currency_rupee_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF33691E),
          title: 'Payments',
          desc: 'Track payments, status and view receipts',
          onTap: () =>
              _needReg(ctx, () => _go(ctx, PaymentDetailsScreen(appState: appState))),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final cards = _cards(context);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(children: [
          // Background is just the off-white color now
          
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 740),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 240),
                children: [
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Empowering Farmers, Enriching India',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: _deepGreen,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: _orangeLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _orangeBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: _orange.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.campaign_rounded, color: _orange, size: 28),
                        SizedBox(width: 12),
                        Flexible(
                            child: Text(
                          'Your Crop, Your Right – Our Commitment!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _orange,
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...cards.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _MenuCard(data: c),
                      )),
                  const SizedBox(height: 20),
                  const Text(
                    '🌿  Let\'s Protect Farming, Let\'s Prosper Together!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _deepGreen,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          _go(context, AdminSimulatorScreen(appState: appState)),
                      child: Text('Admin Panel',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _CardData {
  final IconData? icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final bool isWeatherIcon;
  final bool hasCheckmark;
  final bool hasLeaves;
  final bool hasGrain;

  const _CardData({
    this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.desc,
    required this.onTap,
    this.isWeatherIcon = false,
    this.hasCheckmark = false,
    this.hasLeaves = false,
    this.hasGrain = false,
  });
}

class _MenuCard extends StatefulWidget {
  final _CardData data;
  const _MenuCard({required this.data});
  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _pressed = false;
  static const _deepGreen = Color(0xFF064E2A);
  static const _cardBorder = Color(0xFFD7EAC8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.data.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFF1F8E9) : const Color(0xFFFEFDF9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_pressed ? 0.08 : 0.05),
              blurRadius: _pressed ? 12 : 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: widget.data.iconBg,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.data.isWeatherIcon)
                  CustomPaint(
                    size: const Size(58, 58),
                    painter: _WeatherPainter(),
                  )
                else
                  Icon(widget.data.icon, color: widget.data.iconColor, size: 32),
                
                if (widget.data.hasCheckmark)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 16),
                    ),
                  ),
                if (widget.data.hasLeaves)
                  const Positioned(
                    bottom: 4,
                    child: Icon(Icons.eco, color: Color(0xFF4CAF50), size: 18),
                  ),
                if (widget.data.hasGrain)
                  const Positioned(
                    bottom: 10,
                    right: 8,
                    child: Icon(Icons.grass, color: Color(0xFFF57F17), size: 16),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _deepGreen,
                    height: 1.2,
                  )),
              const SizedBox(height: 4),
              Text(widget.data.desc,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  )),
            ],
          )),
          const SizedBox(width: 10),
          const Icon(Icons.chevron_right_rounded, color: _deepGreen, size: 30),
        ]),
      ),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sunP = Paint()..color = const Color(0xFFFFA000);
    final cloudP = Paint()..color = const Color(0xFF546E7A);
    final rainP = Paint()
      ..color = const Color(0xFF546E7A)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.4), 8, sunP);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.55), 12, cloudP);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.55), 8, cloudP);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.55), 8, cloudP);
    
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.7), Offset(size.width * 0.45, size.height * 0.8), rainP);
    canvas.drawLine(Offset(size.width * 0.55, size.height * 0.7), Offset(size.width * 0.55, size.height * 0.8), rainP);
  }
  @override
  bool shouldRepaint(_) => false;
}

