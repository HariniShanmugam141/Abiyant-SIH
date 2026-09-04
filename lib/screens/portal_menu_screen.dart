import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'onboarding_wizard.dart';
import 'booking_screen.dart';
import 'queue_screen.dart';
import 'tracking_screen.dart';
import 'msp_info_screen.dart';
import 'notifications_screen.dart';
import 'admin_simulator.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PORTAL MENU SCREEN  –  Premium Agricultural Dashboard
// ─────────────────────────────────────────────────────────────────────────────
class PortalMenuScreen extends StatelessWidget {
  final AppState appState;
  const PortalMenuScreen({super.key, required this.appState});

  // ── brand colours ──────────────────────────────────────────────────────────
  static const _bg          = Color(0xFFFBF8F1); // warm ivory
  static const _deepGreen   = Color(0xFF064E2A); // forest green
  static const _medGreen    = Color(0xFF1B7A3E);
  static const _lightGreen  = Color(0xFF4CAF50);
  static const _iconBg      = Color(0xFFE8F5E9); // pale sage
  static const _cardBg      = Color(0xFFFEFDF9); // warm white
  static const _cardBorder  = Color(0xFFD7EAC8);
  static const _orange      = Color(0xFFD84315);
  static const _orangeLight = Color(0xFFFFF3E0);
  static const _orangeBorder= Color(0xFFFFCC80);
  static const _chevron     = Color(0xFF064E2A);

  // ── nav helper ─────────────────────────────────────────────────────────────
  void _go(BuildContext ctx, Widget w) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => w));

  void _needReg(BuildContext ctx, VoidCallback ok) {
    if (appState.isRegistered) { ok(); return; }
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.lock_rounded, color: Colors.orange),
          SizedBox(width: 10),
          Flexible(child: Text('Registration Required',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        ]),
        content: const Text(
            'Please complete Farmer Registration first to unlock this feature.',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _deepGreen),
            onPressed: () {
              Navigator.pop(ctx);
              _go(ctx, OnboardingWizardScreen(
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

  // ── menu data ──────────────────────────────────────────────────────────────
  List<_CardData> _cards(BuildContext ctx) => [
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.how_to_reg_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF2E7D32)),
      title: 'Farmer Registration',
      desc:  'Register and manage farmer identity and verification',
      onTap: () => _go(ctx, OnboardingWizardScreen(
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
      iconWidget: _AgriIcon(icon: Icons.terrain_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF33691E)),
      title: 'My Lands',
      desc:  'View registered lands and add/manage land details',
      onTap: () => _needReg(ctx, () => ScaffoldMessenger.of(ctx)
          .showSnackBar(const SnackBar(content: Text('My Lands – coming soon')))),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.grass_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF388E3C)),
      title: 'My Crops',
      desc:  'Register crops, view crop details and cultivation info',
      onTap: () => _needReg(ctx, () => ScaffoldMessenger.of(ctx)
          .showSnackBar(const SnackBar(content: Text('My Crops – coming soon')))),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.agriculture_rounded,
          bgColor: const Color(0xFFFFF8E1), iconColor: const Color(0xFFF57F17)),
      title: 'Harvest Management',
      desc:  'Update harvest readiness, expected date and quantity',
      onTap: () => _needReg(ctx, () => ScaffoldMessenger.of(ctx)
          .showSnackBar(const SnackBar(content: Text('Harvest – coming soon')))),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.calendar_month_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF1B5E20)),
      title: 'Reserve Your Slot',
      desc:  'Find procurement centres, check slots and book',
      onTap: () => _go(ctx, BookingScreen(appState: appState)),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.people_alt_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF2E7D32)),
      title: 'Live Queue & Smart Travel',
      desc:  'Check your token, queue status and travel recommendation',
      onTap: () => _needReg(ctx, () => _go(ctx, QueueScreen(appState: appState))),
    ),
    _CardData(
      iconWidget: _WeatherIcon(),
      title: 'Weather & Alerts',
      desc:  'Check weather, alerts and travel advisories',
      onTap: () => _go(ctx, NotificationsScreen(appState: appState)),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.local_shipping_rounded,
          bgColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF1B5E20)),
      title: 'Procurement & Grain Tracking',
      desc:  'Track check-in, handover, inspection and approval',
      onTap: () => _needReg(ctx, () => _go(ctx, TrackingScreen(appState: appState))),
    ),
    _CardData(
      iconWidget: _AgriIcon(icon: Icons.currency_rupee_rounded,
          bgColor: const Color(0xFFF1F8E9), iconColor: const Color(0xFF33691E)),
      title: 'Payments',
      desc:  'Track payments, status and view receipts',
      onTap: () => _needReg(ctx, () => _go(ctx, TrackingScreen(appState: appState))),
    ),
  ];

  // ── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cards = _cards(context);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(children: [
          // ── bottom agricultural landscape ───────────────────────────────
          const Positioned(left: 0, right: 0, bottom: 0, height: 220,
              child: _LandscapeWidget()),
          // ── decorative corner leaves ────────────────────────────────────
          const Positioned(top: 0, left: 0,
              child: _CornerLeaves(flipX: false)),
          const Positioned(top: 0, right: 0,
              child: _CornerLeaves(flipX: true)),
          // ── scrollable body ─────────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 740),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 240),
                children: [
                  // ── logo ──────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 210, height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 24, offset: const Offset(0, 8),
                        )],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/logo.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── tagline ────────────────────────────────────────────
                  const Text(
                    'Empowering Farmers, Enriching India',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600,
                      color: _deepGreen, letterSpacing: 0.15,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── commitment banner ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: _orangeLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _orangeBorder, width: 1.8),
                      boxShadow: [BoxShadow(
                        color: _orange.withOpacity(0.08),
                        blurRadius: 10, offset: const Offset(0, 3),
                      )],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.campaign_rounded, color: _orange, size: 28),
                        SizedBox(width: 12),
                        Flexible(child: Text(
                          'Your Crop, Your Right – Our Commitment!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700,
                            color: _orange,
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── menu cards ─────────────────────────────────────────
                  ...cards.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MenuCard(data: c),
                  )),

                  const SizedBox(height: 16),

                  // ── footer text ────────────────────────────────────────
                  const Text(
                    '🌿  Let\'s Protect Farming, Let\'s Prosper Together!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: _deepGreen, height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Admin shortcut
                  Center(
                    child: TextButton(
                      onPressed: () => _go(context,
                          AdminSimulatorScreen(appState: appState)),
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

// ─────────────────────────────────────────────────────────────────────────────
// Card data model
// ─────────────────────────────────────────────────────────────────────────────
class _CardData {
  final Widget iconWidget;
  final String title;
  final String desc;
  final VoidCallback onTap;
  const _CardData({required this.iconWidget, required this.title,
      required this.desc, required this.onTap});
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu card widget
// ─────────────────────────────────────────────────────────────────────────────
class _MenuCard extends StatefulWidget {
  final _CardData data;
  const _MenuCard({required this.data});
  @override State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _pressed = false;
  static const _deepGreen  = Color(0xFF064E2A);
  static const _cardBorder = Color(0xFFD7EAC8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      onTap: widget.data.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFFF1F8E9)
              : const Color(0xFFFEFDF9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder, width: 1.4),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(_pressed ? 0.07 : 0.04),
            blurRadius: _pressed ? 14 : 8,
            offset: const Offset(0, 4),
          )],
        ),
        child: Row(children: [
          // icon
          widget.data.iconWidget,
          const SizedBox(width: 16),
          // text
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.title,
                style: const TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w800,
                  color: _deepGreen, height: 1.2,
                )),
              const SizedBox(height: 4),
              Text(widget.data.desc,
                style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade700,
                  height: 1.35,
                )),
            ],
          )),
          const SizedBox(width: 8),
          // chevron
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right_rounded,
                color: _deepGreen, size: 22),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Standard agricultural icon (circular bg + material icon)
// ─────────────────────────────────────────────────────────────────────────────
class _AgriIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  const _AgriIcon({required this.icon, required this.bgColor,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58, height: 58,
      decoration: BoxDecoration(
        color: bgColor, shape: BoxShape.circle,
        border: Border.all(color: bgColor.withOpacity(0.6), width: 2),
        boxShadow: [BoxShadow(
          color: iconColor.withOpacity(0.12),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: Icon(icon, color: iconColor, size: 30),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom weather icon (sun + cloud + rain drops)
// ─────────────────────────────────────────────────────────────────────────────
class _WeatherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58, height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9FE), shape: BoxShape.circle,
        boxShadow: [BoxShadow(
          color: Colors.blue.withOpacity(0.10),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: CustomPaint(painter: _WeatherPainter()),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final sunP = Paint()..color = const Color(0xFFFFA000)..style = PaintingStyle.fill;
    final cloudP = Paint()..color = const Color(0xFF90CAF9)..style = PaintingStyle.fill;
    final rainP = Paint()..color = const Color(0xFF1565C0)
        ..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    // sun
    canvas.drawCircle(Offset(s.width * 0.65, s.height * 0.32), 9, sunP);
    // cloud
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width * 0.44, s.height * 0.52),
        width: 30, height: 18), cloudP);
    canvas.drawCircle(Offset(s.width * 0.35, s.height * 0.50), 9, cloudP);
    canvas.drawCircle(Offset(s.width * 0.54, s.height * 0.48), 7, cloudP);
    // rain
    for (int i = 0; i < 3; i++) {
      final x = s.width * (0.32 + i * 0.10);
      canvas.drawLine(Offset(x, s.height * 0.65), Offset(x - 2, s.height * 0.76), rainP);
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Corner Leaf Decoration
// ─────────────────────────────────────────────────────────────────────────────
class _CornerLeaves extends StatelessWidget {
  final bool flipX;
  const _CornerLeaves({required this.flipX});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: flipX,
      child: SizedBox(
        width: 105, height: 160,
        child: CustomPaint(painter: _CornerLeafPainter()),
      ),
    );
  }
}

class _CornerLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    void leaf(Path p, Color c, [double opacity = 1]) =>
        canvas.drawPath(p, Paint()..color = c.withOpacity(opacity)
            ..style = PaintingStyle.fill);

    // stem (thin vertical)
    canvas.drawLine(
      const Offset(10, 0), Offset(10, s.height * 0.85),
      Paint()..color = const Color(0xFF388E3C).withOpacity(0.45)
          ..strokeWidth = 2..style = PaintingStyle.stroke,
    );

    // leaves along the stem
    final specs = [
      [0.12, 0.05, 1.0],
      [0.25, 0.10, 0.85],
      [0.42, 0.15, 0.80],
      [0.58, 0.20, 0.70],
      [0.73, 0.25, 0.60],
    ];

    final colors = [
      const Color(0xFF66BB6A),
      const Color(0xFF4CAF50),
      const Color(0xFF43A047),
      const Color(0xFF388E3C),
      const Color(0xFF2E7D32),
    ];

    for (int i = 0; i < specs.length; i++) {
      final yFrac = specs[i][0];
      final xOff  = specs[i][1];
      final op    = specs[i][2];
      final y     = s.height * yFrac;
      final len   = s.width * (0.65 - xOff);

      final p = Path()
        ..moveTo(10, y)
        ..quadraticBezierTo(10 + len * 0.4, y - s.height * 0.06,
            10 + len, y + s.height * 0.01)
        ..quadraticBezierTo(10 + len * 0.4, y + s.height * 0.06, 10, y)
        ..close();
      leaf(p, colors[i], op);
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Agricultural Landscape
// ─────────────────────────────────────────────────────────────────────────────
class _LandscapeWidget extends StatelessWidget {
  const _LandscapeWidget();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LandscapePainter());
  }
}

class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    void hill(Path p, Color c) => canvas.drawPath(p,
        Paint()..color = c..style = PaintingStyle.fill);

    // layer 1 – far / lightest
    final l1 = Path()
      ..moveTo(0, s.height * 0.48)
      ..quadraticBezierTo(s.width * 0.18, s.height * 0.05,
          s.width * 0.50, s.height * 0.26)
      ..quadraticBezierTo(s.width * 0.72, s.height * 0.45,
          s.width, s.height * 0.20)
      ..lineTo(s.width, s.height)..lineTo(0, s.height)..close();
    hill(l1, const Color(0xFFDCEFDC));

    // layer 2
    final l2 = Path()
      ..moveTo(0, s.height * 0.60)
      ..quadraticBezierTo(s.width * 0.28, s.height * 0.28,
          s.width * 0.62, s.height * 0.48)
      ..quadraticBezierTo(s.width * 0.82, s.height * 0.60,
          s.width, s.height * 0.46)
      ..lineTo(s.width, s.height)..lineTo(0, s.height)..close();
    hill(l2, const Color(0xFFC5E8C5));

    // layer 3
    final l3 = Path()
      ..moveTo(0, s.height * 0.72)
      ..quadraticBezierTo(s.width * 0.35, s.height * 0.42,
          s.width * 0.65, s.height * 0.60)
      ..quadraticBezierTo(s.width * 0.85, s.height * 0.70,
          s.width, s.height * 0.62)
      ..lineTo(s.width, s.height)..lineTo(0, s.height)..close();
    hill(l3, const Color(0xFFA8D5A8));

    // layer 4 – nearest / darkest
    final l4 = Path()
      ..moveTo(0, s.height * 0.80)
      ..quadraticBezierTo(s.width * 0.42, s.height * 0.55,
          s.width, s.height * 0.82)
      ..lineTo(s.width, s.height)..lineTo(0, s.height)..close();
    hill(l4, const Color(0xFF81C784));

    // crops – left cluster
    _clusterCrops(canvas, s, leftSide: true);
    // crops – right cluster
    _clusterCrops(canvas, s, leftSide: false);

    // wheat stalks – scattered center-left and center-right
    _wheatRow(canvas, s, startX: s.width * 0.30, y: s.height * 0.68);
    _wheatRow(canvas, s, startX: s.width * 0.55, y: s.height * 0.72);
  }

  void _clusterCrops(Canvas canvas, Size s, {required bool leftSide}) {
    final bases = leftSide
        ? [
            Offset(s.width * 0.03, s.height * 0.82),
            Offset(s.width * 0.09, s.height * 0.74),
            Offset(s.width * 0.15, s.height * 0.80),
            Offset(s.width * 0.20, s.height * 0.86),
          ]
        : [
            Offset(s.width * 0.80, s.height * 0.86),
            Offset(s.width * 0.86, s.height * 0.78),
            Offset(s.width * 0.92, s.height * 0.72),
            Offset(s.width * 0.97, s.height * 0.80),
          ];
    final heights = [42.0, 56.0, 48.0, 38.0];
    for (int i = 0; i < bases.length; i++) {
      _drawCrop(canvas, bases[i], heights[i]);
    }
  }

  void _drawCrop(Canvas canvas, Offset base, double h) {
    final stemP = Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 2.2..style = PaintingStyle.stroke;
    final leafP = Paint()
      ..color = const Color(0xFF4CAF50)..style = PaintingStyle.fill;
    final leafP2 = Paint()
      ..color = const Color(0xFF2E7D32)..style = PaintingStyle.fill;

    canvas.drawLine(base, base.translate(0, -h), stemP);

    // left leaf
    final ll = Path()
      ..moveTo(base.dx, base.dy - h * 0.52)
      ..quadraticBezierTo(base.dx - 18, base.dy - h * 0.72,
          base.dx - 10, base.dy - h * 0.42)..close();
    canvas.drawPath(ll, leafP);

    // right leaf
    final rl = Path()
      ..moveTo(base.dx, base.dy - h * 0.68)
      ..quadraticBezierTo(base.dx + 18, base.dy - h * 0.88,
          base.dx + 10, base.dy - h * 0.56)..close();
    canvas.drawPath(rl, leafP2);
  }

  void _wheatRow(Canvas canvas, Size s, {required double startX, required double y}) {
    final stemP = Paint()
      ..color = const Color(0xFF558B2F)
      ..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final grainP = Paint()
      ..color = const Color(0xFF8BC34A)..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final x = startX + i * 12;
      canvas.drawLine(Offset(x, y), Offset(x, y - 26), stemP);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y - 28), width: 5, height: 10), grainP);
    }
  }

  @override bool shouldRepaint(_) => false;
}
