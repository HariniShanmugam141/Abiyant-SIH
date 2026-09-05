import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'register_crop_confirm_screen.dart';

class RegisterCropTimelineScreen extends StatefulWidget {
  final AppState appState;

  const RegisterCropTimelineScreen({super.key, required this.appState});

  @override
  State<RegisterCropTimelineScreen> createState() => _RegisterCropTimelineScreenState();
}

class _RegisterCropTimelineScreenState extends State<RegisterCropTimelineScreen> {
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

  bool _appNotif = true;
  bool _smsNotif = true;
  bool _familyNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildProgressIndicator(),
                    const SizedBox(height: 24),
                    const Text('Crop Journey', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(height: 16),
                    _buildTimelineItem(Icons.eco, 'Cultivation Started', '10 Jun 2026', 'Your crop has been registered and cultivation has started.', isPast: true),
                    _buildTimelineItem(Icons.spa, 'Crop Growing', 'Current Stage', 'We will monitor your crop progress.', isPast: true),
                    _buildTimelineItem(Icons.notifications_active, 'Harvest Approaching', 'In 25 days (approx.)', 'You will receive a reminder to confirm your harvest details.', isPast: false, iconColor: const Color(0xFFF57F17)),
                    _buildTimelineItem(Icons.grass, 'Expected Harvest', '15 Sep 2026', 'Planned harvest date.', isPast: false, isLast: true, iconColor: const Color(0xFFF57C00)),
                    const SizedBox(height: 16),
                    _buildSmartReminderCard(),
                    const SizedBox(height: 24),
                    const Text('Notification Preferences', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(height: 8),
                    _buildCheckbox('App Notification', _appNotif, (val) => setState(() => _appNotif = val!)),
                    _buildCheckbox('SMS Notification', _smsNotif, (val) => setState(() => _smsNotif = val!)),
                    _buildCheckbox('Family Member Notification (if linked)', _familyNotif, (val) => setState(() => _familyNotif = val!)),
                    const SizedBox(height: 24),
                    _buildNextButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: _darkGreen), onPressed: () => Navigator.pop(context)),
          const Text('Register Crop', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _darkGreen)),
          IconButton(icon: const Icon(Icons.help_outline, color: _darkGreen), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProgressStep('1', 'Crop', isActive: true, isCompleted: true),
          _buildProgressLine(isActive: true),
          _buildProgressStep('2', 'Details', isActive: true, isCompleted: true),
          _buildProgressLine(isActive: true),
          _buildProgressStep('3', 'Timeline', isActive: true, isCompleted: false),
          _buildProgressLine(isActive: false),
          _buildProgressStep('4', 'Confirm', isActive: false, isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String stepNumber, String label, {required bool isActive, required bool isCompleted}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? _primaryGreen : (isActive ? _primaryGreen : const Color(0xFFF5F5F5)),
            shape: BoxShape.circle,
            border: Border.all(color: isActive || isCompleted ? _primaryGreen : const Color(0xFFE0E0E0)),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(stepNumber, style: TextStyle(color: isActive ? Colors.white : _textSecondary, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w500, color: isActive || isCompleted ? _darkGreen : _textSecondary)),
      ],
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(child: Container(margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8), height: 2, color: isActive ? _primaryGreen : const Color(0xFFE0E0E0)));
  }

  Widget _buildTimelineItem(IconData icon, String title, String subtitle, String desc, {required bool isPast, bool isLast = false, Color? iconColor}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isPast ? _lightGreen : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: isPast ? _primaryGreen : const Color(0xFFE0E0E0)),
                  ),
                  child: Icon(icon, color: iconColor ?? (isPast ? _primaryGreen : const Color(0xFF9E9E9E)), size: 18),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: isPast ? _primaryGreen : const Color(0xFFE0E0E0))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _darkGreen)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isPast ? _textPrimary : _textSecondary)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 12, color: _textSecondary, height: 1.3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartReminderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.smart_toy, color: _primaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Smart Harvest Reminder', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
                SizedBox(height: 4),
                Text('We will automatically remind you before your expected harvest date to confirm your harvest quantity and readiness.', style: TextStyle(fontSize: 12, color: _textPrimary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: value ? _primaryGreen : _borderColor),
              ),
              child: value ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14, color: _textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCropConfirmScreen(appState: widget.appState)));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _borderColor.withOpacity(0.5)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 'Home', false),
          _buildNavItem(Icons.eco, 'Crops', true),
          _buildNavItem(Icons.calendar_today, 'Booking', false),
          _buildNavItem(Icons.local_shipping, 'Tracking', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? _darkGreen : const Color(0xFF9E9E9E), size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? _darkGreen : const Color(0xFF9E9E9E))),
      ],
    );
  }
}
