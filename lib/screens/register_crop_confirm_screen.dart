import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'register_crop_success_screen.dart';

class RegisterCropConfirmScreen extends StatefulWidget {
  final AppState appState;

  const RegisterCropConfirmScreen({super.key, required this.appState});

  @override
  State<RegisterCropConfirmScreen> createState() => _RegisterCropConfirmScreenState();
}

class _RegisterCropConfirmScreenState extends State<RegisterCropConfirmScreen> {
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

  bool _isConfirmed = true;

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
                    const Text('Review Your Crop Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(height: 4),
                    const Text('Please check the information before submitting.', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    const SizedBox(height: 16),
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    _buildSmartAutomationCard(),
                    const SizedBox(height: 24),
                    _buildConfirmationCheckbox(),
                    const SizedBox(height: 24),
                    _buildRegisterButton(),
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
          _buildProgressStep('3', 'Timeline', isActive: true, isCompleted: true),
          _buildProgressLine(isActive: true),
          _buildProgressStep('4', 'Confirm', isActive: true, isCompleted: false),
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

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
      child: Column(
        children: [
          _buildSummaryRow(
            icon: Icons.grass,
            label: 'Crop',
            value: 'Paddy\nVariety: ADT 45',
            imagePreview: 'https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=150&auto=format&fit=crop',
          ),
          const Divider(height: 32, color: _borderColor),
          _buildSummaryRow(icon: Icons.location_on_outlined, label: 'Land Parcel', value: 'North Field\nArea: 2.0 Acres'),
          const Divider(height: 32, color: _borderColor),
          _buildSummaryRow(icon: Icons.calendar_today, label: 'Cultivation Date', value: '10 Jun 2026'),
          const Divider(height: 32, color: _borderColor),
          _buildSummaryRow(icon: Icons.event_available, label: 'Expected Harvest Date', value: '15 Sep 2026'),
          const Divider(height: 32, color: _borderColor),
          _buildSummaryRow(icon: Icons.shopping_bag_outlined, label: 'Estimated Quantity', value: '2,500 kg', isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required IconData icon, required String label, required String value, String? imagePreview, bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: _primaryGreen, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isHighlight ? _darkGreen : _textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (imagePreview != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imagePreview, width: 40, height: 40, fit: BoxFit.cover),
          ),
      ],
    );
  }

  Widget _buildSmartAutomationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.settings, color: _primaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Smart Automation Enabled', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
                SizedBox(height: 4),
                Text('Your crop will be automatically monitored based on your harvest timeline. We will send reminders and help you with procurement slot booking.', style: TextStyle(fontSize: 12, color: _textPrimary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCheckbox() {
    return InkWell(
      onTap: () => setState(() => _isConfirmed = !_isConfirmed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: _isConfirmed ? _lightGreen : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _isConfirmed ? _primaryGreen : _borderColor)),
        child: Row(
          children: [
            Icon(_isConfirmed ? Icons.check_circle : Icons.radio_button_unchecked, color: _primaryGreen, size: 24),
            const SizedBox(width: 12),
            const Expanded(child: Text('I confirm that the above information is correct.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _darkGreen))),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isConfirmed
            ? () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterCropSuccessScreen(appState: widget.appState)));
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          disabledBackgroundColor: const Color(0xFFA5D6A7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Register Crop', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(width: 8),
            Text('🌾', style: TextStyle(fontSize: 16)),
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
