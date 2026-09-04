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

// ─────────────────────────────────────────────────────────────
// Portal Menu Screen – redesigned to match reference image
// ─────────────────────────────────────────────────────────────
class PortalMenuScreen extends StatelessWidget {
  final AppState appState;

  const PortalMenuScreen({super.key, required this.appState});

  // ── COLOURS ────────────────────────────────────────────────
  static const _bgColor     = Color(0xFFFCFAF5); // warm ivory
  static const _darkGreen   = Color(0xFF1B5E20); // deep forest green
  static const _medGreen    = Color(0xFF2E7D32);
  static const _iconBg      = Color(0xFFE8F5E9); // pale green
  static const _cardBorder  = Color(0xFFDCEDC8);
  static const _orange      = Color(0xFFE65100);
  static const _bannerBg    = Color(0xFFFFF8F0);
  static const _bannerBorder= Color(0xFFFFCC80);

  // ── NAV HELPER ─────────────────────────────────────────────
  void _go(BuildContext ctx, Widget screen) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));

  void _checkReg(BuildContext ctx, VoidCallback onOk) {
    if (appState.isRegistered) { onOk(); return; }
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(children: [
          Icon(Icons.lock_person, color: Colors.orange),
          SizedBox(width: 10),
          Text('Registration Required', style: TextStyle(fontSize: 17)),
        ]),
        content: const Text(
            'Please complete Farmer Registration first to access this feature.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _darkGreen),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => OnboardingWizardScreen(
                    appState: appState,
                    onRegistrationSuccess: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text('Registration completed!'),
                        backgroundColor: _darkGreen,
                      ));
                    },
                  ),
                ),
              );
            },
            child: const Text('Register Now',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── MENU ITEMS ─────────────────────────────────────────────
  List<_MenuItem> _buildMenuItems(BuildContext ctx) => [
    _MenuItem(
      icon: Icons.how_to_reg_outlined,
      title: 'Farmer Registration',
      description: 'Register and manage farmer identity and verification',
      onTap: () => _go(ctx, OnboardingWizardScreen(
        appState: appState,
        onRegistrationSuccess: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('Registration completed! Profile unlocked.'),
            backgroundColor: _darkGreen,
          ));
        },
      )),
    ),
    _MenuItem(
      icon: Icons.landscape_outlined,
      title: 'My Lands',
      description: 'View registered lands and add/manage land details',
      onTap: () => _checkReg(ctx, () => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('My Lands – coming soon')))),
    ),
    _MenuItem(
      icon: Icons.grass_outlined,
      title: 'My Crops',
      description: 'Register crops, view crop details and cultivation info',
      onTap: () => _checkReg(ctx, () => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('My Crops – coming soon')))),
    ),
    _MenuItem(
      icon: Icons.agriculture_outlined,
      title: 'Harvest Management',
      description: 'Update harvest readiness, expected date and quantity',
      onTap: () => _checkReg(ctx, () => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Harvest Management – coming soon')))),
    ),
    _MenuItem(
      icon: Icons.calendar_month_outlined,
      title: 'Reserve Your Slot',
      description: 'Find procurement centres, check slots and book',
      onTap: () => _go(ctx, BookingScreen(appState: appState)),
    ),
    _MenuItem(
      icon: Icons.people_alt_outlined,
      title: 'Live Queue & Smart Travel',
      description: 'Check your token, queue status and travel recommendation',
      onTap: () => _checkReg(ctx, () => _go(ctx, QueueScreen(appState: appState))),
    ),
    _MenuItem(
      icon: Icons.wb_cloudy_outlined,
      title: 'Weather & Alerts',
      description: 'Check weather, alerts and travel advisories',
      onTap: () => _go(ctx, NotificationsScreen(appState: appState)),
    ),
    _MenuItem(
      icon: Icons.local_shipping_outlined,
      title: 'Procurement & Grain Tracking',
      description: 'Track check-in, handover, inspection and approval',
      onTap: () => _checkReg(ctx, () => _go(ctx, TrackingScreen(appState: appState))),
    ),
    _MenuItem(
      icon: Icons.currency_rupee_outlined,
      title: 'Payments',
      description: 'Track payments, status and view receipts',
      onTap: () => _checkReg(ctx, () => _go(ctx, TrackingScreen(appState: appState))),
    ),
  ];

  // ── BUILD ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Bottom agricultural landscape ───────────────
            Positioned(
              left: 0, right: 0, bottom: 0,
              height: 180,
              child: CustomPaint(painter: _LandscapePainter()),
            ),

            // ── Top-left leaf decoration ────────────────────
            Positioned(
              top: 0, left: 0,
              child: _LeafDecoration(flip: false),
            ),
            // ── Top-right leaf decoration ───────────────────
            Positioned(
              top: 0, right: 0,
              child: _LeafDecoration(flip: true),
            ),

            // ── Main scrollable content ─────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 200),
                  children: [
                    // ── LOGO ─────────────────────────────────
                    Center(
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ── TAGLINE ───────────────────────────────
                    const Text(
                      'Empowering Farmers, Enriching India',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _darkGreen,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── COMMITMENT BANNER ─────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: _bannerBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _bannerBorder, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: _orange.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.campaign_outlined,
                              color: _orange, size: 26),
                          SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Your Crop, Your Right – Our Commitment!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: _orange,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── MENU CARDS ────────────────────────────
                    ...menuItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MenuCard(item: item),
                    )),

                    const SizedBox(height: 20),

                    // ── FOOTER ────────────────────────────────
                    const Text(
                      '🌿  Let\'s Protect Farming, Let\'s Prosper Together!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _darkGreen,
                        height: 1.5,
                      ),
                    ),

                    // Admin shortcut – kept for dev purposes
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => _go(context, AdminSimulatorScreen(appState: appState)),
                        child: Text(
                          'Admin Panel',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Data class for a menu item
// ─────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────
// Single Menu Card Widget
// ─────────────────────────────────────────────────────────────
class _MenuCard extends StatefulWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _hovered = false;

  static const _darkGreen  = Color(0xFF1B5E20);
  static const _iconBg     = Color(0xFFE8F5E9);
  static const _cardBorder = Color(0xFFDCEDC8);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFF1F8E9)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _cardBorder, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.06 : 0.03),
                blurRadius: _hovered ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Icon circle ─────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _iconBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFFC8E6C9), width: 1.5),
                ),
                child: Icon(widget.item.icon,
                    color: _darkGreen, size: 28),
              ),
              const SizedBox(width: 16),

              // ── Text ────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _darkGreen,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // ── Chevron ─────────────────────────────────
              const Icon(Icons.chevron_right,
                  color: _darkGreen, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Leaf Decoration
// ─────────────────────────────────────────────────────────────
class _LeafDecoration extends StatelessWidget {
  final bool flip;
  const _LeafDecoration({required this.flip});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: flip,
      child: Opacity(
        opacity: 0.65,
        child: SizedBox(
          width: 90,
          height: 110,
          child: CustomPaint(painter: _LeafPainter()),
        ),
      ),
    );
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF66BB6A).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Leaf 1
    final l1 = Path()
      ..moveTo(0, 10)
      ..quadraticBezierTo(40, 0, 80, 30)
      ..quadraticBezierTo(40, 20, 0, 10)
      ..close();
    canvas.drawPath(l1, p);

    // Leaf 2
    final l2 = Path()
      ..moveTo(0, 30)
      ..quadraticBezierTo(50, 10, 90, 50)
      ..quadraticBezierTo(40, 40, 0, 30)
      ..close();
    canvas.drawPath(l2, p..color = const Color(0xFF43A047).withOpacity(0.6));

    // Leaf 3
    final l3 = Path()
      ..moveTo(0, 55)
      ..quadraticBezierTo(60, 30, 88, 80)
      ..quadraticBezierTo(40, 65, 0, 55)
      ..close();
    canvas.drawPath(l3, p..color = const Color(0xFF388E3C).withOpacity(0.5));

    // Leaf 4 (tall)
    final l4 = Path()
      ..moveTo(10, 0)
      ..quadraticBezierTo(0, 55, 20, 110)
      ..quadraticBezierTo(25, 55, 10, 0)
      ..close();
    canvas.drawPath(l4, p..color = const Color(0xFF2E7D32).withOpacity(0.4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────
// Bottom Agricultural Landscape Painter
// ─────────────────────────────────────────────────────────────
class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void hill(Path path, Color color) =>
        canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);

    // Layer 1 – farthest / lightest
    final p1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.05, size.width * 0.50, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.48, size.width, size.height * 0.22)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(p1, const Color(0xFFE8F5E9));

    // Layer 2
    final p2 = Path()
      ..moveTo(0, size.height * 0.60)
      ..quadraticBezierTo(size.width * 0.30, size.height * 0.30, size.width * 0.65, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.62, size.width, size.height * 0.48)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(p2, const Color(0xFFC8E6C9));

    // Layer 3 – nearest / darkest
    final p3 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.40, size.height * 0.45, size.width, size.height * 0.78)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(p3, const Color(0xFFA5D6A7));

    // Crops – left corner
    _drawCrop(canvas, Offset(size.width * 0.05, size.height * 0.72), 36);
    _drawCrop(canvas, Offset(size.width * 0.12, size.height * 0.65), 44);
    _drawCrop(canvas, Offset(size.width * 0.19, size.height * 0.72), 32);

    // Crops – right corner
    _drawCrop(canvas, Offset(size.width * 0.82, size.height * 0.72), 36);
    _drawCrop(canvas, Offset(size.width * 0.89, size.height * 0.64), 48);
    _drawCrop(canvas, Offset(size.width * 0.95, size.height * 0.72), 34);
  }

  void _drawCrop(Canvas canvas, Offset base, double height) {
    final stemPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final leafPaint = Paint()
      ..color = const Color(0xFF43A047)
      ..style = PaintingStyle.fill;

    // Stem
    canvas.drawLine(base, base.translate(0, -height), stemPaint);

    // Left leaf
    final ll = Path()
      ..moveTo(base.dx, base.dy - height * 0.55)
      ..quadraticBezierTo(
          base.dx - 16, base.dy - height * 0.75,
          base.dx - 8, base.dy - height * 0.45)
      ..close();
    canvas.drawPath(ll, leafPaint);

    // Right leaf
    final rl = Path()
      ..moveTo(base.dx, base.dy - height * 0.70)
      ..quadraticBezierTo(
          base.dx + 16, base.dy - height * 0.88,
          base.dx + 9, base.dy - height * 0.58)
      ..close();
    canvas.drawPath(rl, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
