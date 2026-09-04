import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import 'portal_menu_screen.dart';

class LinkFamilyMemberScreen extends StatefulWidget {
  final AppState appState;

  const LinkFamilyMemberScreen({super.key, required this.appState});

  @override
  State<LinkFamilyMemberScreen> createState() => _LinkFamilyMemberScreenState();
}

class _LinkFamilyMemberScreenState extends State<LinkFamilyMemberScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  bool _isMobileValid = false;
  bool _otpSent = false;

  bool _permViewProcurement = true;
  bool _permManageBookings = true;
  bool _permViewPayments = true;

  static const _green = Color(0xFF145A32);
  static const _medGreen = Color(0xFF2E7D32);
  static const _lightGreenBg = Color(0xFFF1F8E9);
  static const _borderGreen = Color(0xFFE8F5E9);
  static const _cream = Color(0xFFFDFDF8);

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(() {
      setState(() {
        _isMobileValid = _mobileController.text.trim().length == 10;
      });
    });
    for (var fn in _otpFocusNodes) {
      fn.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var n in _otpFocusNodes) n.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_isMobileValid) return;
    setState(() => _otpSent = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _otpFocusNodes[0].requestFocus();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent to family member! (Demo: 123456)'),
        backgroundColor: _green,
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  // ─── WIDGETS ────────────────────────────────────────────────────────────────

  Widget _stepBadge(int number) => Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderGreen, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _mobileInput() => Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.phone_android, color: _green, size: 22),
            ),
            const Text('+91',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 10),
            Container(width: 1, height: 28, color: Colors.grey.shade300),
            const SizedBox(width: 14),
            Expanded(
              child: TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter Mobile Number',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _otpBoxes() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) {
          final focused = _otpFocusNodes[i].hasFocus;
          return Container(
            width: 45,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: focused ? _medGreen : Colors.grey.shade300,
                width: focused ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _otpControllers[i],
              focusNode: _otpFocusNodes[i],
              enabled: _otpSent,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 1,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _green),
              decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: '—',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 20)),
              onChanged: (v) => _onOtpChanged(v, i),
            ),
          );
        }),
      );

  Widget _permissionRow({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _lightGreenBg,
              shape: BoxShape.circle,
              border: Border.all(color: _borderGreen, width: 1.5),
            ),
            child: Icon(icon, color: _green, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _green)),
                const SizedBox(height: 2),
                Text(description,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _green,
            activeTrackColor: _medGreen.withOpacity(0.4),
          ),
        ],
      );

  // ─── BUILD ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Stack(
          children: [
            // Bottom landscape
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 130,
              child: CustomPaint(painter: _FieldPainter()),
            ),

            // Scrollable content
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button row
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _lightGreenBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: _borderGreen),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: _green, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logo
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 14),

                  // Brand text
                  const Text('Abhiyant',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: _green,
                          letterSpacing: 0.4)),
                  const SizedBox(height: 4),
                  const Text('Empowering Farmers, Enriching India',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _medGreen)),
                  const SizedBox(height: 28),

                  // Page title
                  const Text('Link a Family Member',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _green)),
                  const SizedBox(height: 10),

                  // Subtitle with decorative lines
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 20,
                          height: 1,
                          color: _medGreen.withOpacity(0.4)),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'Let a trusted family member help you access all services',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                          width: 20,
                          height: 1,
                          color: _medGreen.withOpacity(0.4)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── STEP 1 ───────────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          _stepBadge(1),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Enter Family Member's Mobile Number",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _green),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                          'Provide the mobile number of the family member you want to link.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),
                        _mobileInput(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── STEP 2 ───────────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          _stepBadge(2),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'OTP / Consent Verification',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _green),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                          "We will send an OTP to the family member's number\nfor verification and consent.",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.4),
                        ),
                        const SizedBox(height: 18),

                        // Send OTP button
                        ElevatedButton(
                          onPressed: _isMobileValid ? _sendOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            disabledBackgroundColor:
                                _green.withOpacity(0.35),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: _isMobileValid ? 2 : 0,
                          ),
                          child: const Text('Send OTP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 18),

                        // OTP boxes
                        _otpBoxes(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── STEP 3 ───────────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          _stepBadge(3),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Permission Settings',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _green),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Text(
                          'Choose what access the family member will have.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 18),

                        _permissionRow(
                          icon: Icons.format_list_bulleted,
                          title: 'View procurement information',
                          description:
                              'Allow viewing of mandi details, schedules, and status.',
                          value: _permViewProcurement,
                          onChanged: (v) =>
                              setState(() => _permViewProcurement = v),
                        ),
                        Divider(height: 24, color: Colors.grey.shade200),

                        _permissionRow(
                          icon: Icons.article_outlined,
                          title: 'Manage bookings',
                          description:
                              'Allow booking and managing produce entries.',
                          value: _permManageBookings,
                          onChanged: (v) =>
                              setState(() => _permManageBookings = v),
                        ),
                        Divider(height: 24, color: Colors.grey.shade200),

                        _permissionRow(
                          icon: Icons.currency_rupee,
                          title: 'View payments',
                          description:
                              'Allow viewing of payments and settlements.',
                          value: _permViewPayments,
                          onChanged: (v) =>
                              setState(() => _permViewPayments = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── CONFIRM BUTTON ────────────────────────────────────────
                  ElevatedButton.icon(
                    onPressed: () {
                      // Show success dialog then navigate to portal
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: const EdgeInsets.all(28),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: _lightGreenBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle,
                                    color: _green, size: 40),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Family Member Linked!',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _green),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'The family member has been linked successfully with the selected permissions.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black54, height: 1.4),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PortalMenuScreen(appState: widget.appState),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _green,
                                  minimumSize:
                                      const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                                child: const Text('Continue to App',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.link, color: Colors.white, size: 20),
                    label: const Text(
                      'Link Family Member',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      elevation: 3,
                      shadowColor: _green.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel / Skip button
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _green,
                      side: const BorderSide(color: _medGreen, width: 1.5),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _green),
                    ),
                  ),
                  const SizedBox(height: 28),

                  const SizedBox(height: 140), // clearance for landscape
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable rolling-field painter (same as login/access screens)
class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void hill(Path path, Color color) {
      canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
    }

    final pathBack = Path()
      ..moveTo(0, size.height * 0.40)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.10,
          size.width * 0.60, size.height * 0.30)
      ..quadraticBezierTo(size.width * 0.80, size.height * 0.40,
          size.width, size.height * 0.20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(pathBack, const Color(0xFFE8F5E9));

    final pathMid = Path()
      ..moveTo(0, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.30, size.height * 0.70,
          size.width * 0.70, size.height * 0.40)
      ..quadraticBezierTo(size.width * 0.90, size.height * 0.30,
          size.width, size.height * 0.50)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(pathMid, const Color(0xFFC8E6C9).withOpacity(0.7));

    final pathFront = Path()
      ..moveTo(0, size.height * 0.70)
      ..quadraticBezierTo(size.width * 0.40, size.height * 0.40,
          size.width, size.height * 0.80)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    hill(pathFront, const Color(0xFFA5D6A7).withOpacity(0.6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
