import 'package:flutter/material.dart';
import '../state/app_state.dart';

class RegisterCropSuccessScreen extends StatelessWidget {
  final AppState appState;

  const RegisterCropSuccessScreen({super.key, required this.appState});

  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

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
                child: Column(
                  children: [
                    _buildHeroImage(),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text('Crop Registered Successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _darkGreen, height: 1.2)),
                          const SizedBox(height: 8),
                          const Text('Your Paddy crop has been successfully registered.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: _textSecondary)),
                          const SizedBox(height: 24),
                          _buildSummaryCard(),
                          const SizedBox(height: 24),
                          _buildWhatsNextSection(),
                          const SizedBox(height: 32),
                          _buildPrimaryAction(context),
                          const SizedBox(height: 16),
                          _buildSecondaryAction(context),
                        ],
                      ),
                    ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ABHIYANT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _darkGreen, letterSpacing: 0.5)),
                  Text('Smart Procurement Centre', style: TextStyle(fontSize: 11, color: _darkGreen, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network('https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=600&auto=format&fit=crop', width: double.infinity, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.2)),
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Registration Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
          const SizedBox(height: 16),
          _buildSummaryRow('Crop', 'Paddy (ADT 45)', Icons.grass),
          const SizedBox(height: 12),
          _buildSummaryRow('Land', 'North Field (2.0 Acres)', Icons.location_on_outlined),
          const SizedBox(height: 12),
          _buildSummaryRow('Expected Harvest', '15 Sep 2026', Icons.event_available),
          const SizedBox(height: 12),
          _buildSummaryRow('Estimated Quantity', '2,500 kg', Icons.shopping_bag_outlined),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _primaryGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: _textSecondary))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
      ],
    );
  }

  Widget _buildWhatsNextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What's Next?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
        const SizedBox(height: 12),
        _buildNextStep('1', 'Continue monitoring your crop'),
        _buildNextStep('2', 'Receive automatic harvest reminders'),
        _buildNextStep('3', 'Submit harvest intimation'),
        _buildNextStep('4', 'Get a procurement slot'),
      ],
    );
  }

  Widget _buildNextStep(String stepNumber, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
            child: Center(child: Text(stepNumber, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: _textPrimary))),
        ],
      ),
    );
  }

  Widget _buildPrimaryAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Go back to the root My Crops screen
          Navigator.popUntil(context, (route) => route.isFirst);
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
            Text('View My Crops', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: _primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryGreen)),
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
