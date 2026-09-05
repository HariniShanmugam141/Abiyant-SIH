import 'package:flutter/material.dart';
import '../state/app_state.dart';

class HarvestConfirmationScreen extends StatefulWidget {
  final AppState appState;

  const HarvestConfirmationScreen({super.key, required this.appState});

  @override
  State<HarvestConfirmationScreen> createState() => _HarvestConfirmationScreenState();
}

class _HarvestConfirmationScreenState extends State<HarvestConfirmationScreen> {
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

  String _readiness = 'Ready Soon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTitleSection(),
                    const SizedBox(height: 24),
                    _buildCropCard(),
                    const SizedBox(height: 24),
                    _buildExpectedHarvestField(),
                    const SizedBox(height: 20),
                    _buildQuantityField(),
                    const SizedBox(height: 20),
                    _buildReadinessSection(),
                    const SizedBox(height: 24),
                    _buildInfoBanner(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                    const SizedBox(height: 32),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: _darkGreen), onPressed: () => Navigator.pop(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ABHIYANT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _darkGreen, letterSpacing: 0.5)),
                  Text('Smart Procurement Centre', style: TextStyle(fontSize: 11, color: _darkGreen, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, color: _darkGreen, size: 28),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(color: _lightGreen, shape: BoxShape.circle),
          child: const Icon(Icons.spa, color: _darkGreen, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Harvest Confirmation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _darkGreen)),
              SizedBox(height: 4),
              Text('Update your harvest details as the date approaches.', style: TextStyle(fontSize: 13, color: _textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=150&auto=format&fit=crop',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Paddy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen)),
                SizedBox(height: 4),
                Text('Token: ABY-2026-8910', style: TextStyle(fontSize: 12, color: _textSecondary)),
                Text('Centre: Trichy APMC', style: TextStyle(fontSize: 12, color: _textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _darkGreen),
        ],
      ),
    );
  }

  Widget _buildExpectedHarvestField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.event_available, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('Expected Harvest Date', style: TextStyle(fontSize: 14, color: _textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: const TextField(
            controller: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: '15 Sep 2026',
              hintStyle: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
              suffixIcon: Icon(Icons.calendar_today, color: _textSecondary, size: 20),
            ),
            style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.shopping_bag, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('Estimated Quantity', style: TextStyle(fontSize: 14, color: _textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor),
                ),
                child: const TextField(
                  controller: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintText: '1200',
                    hintStyle: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Kilograms (kg)',
                    icon: const Icon(Icons.keyboard_arrow_down, color: _textSecondary),
                    items: ['Kilograms (kg)', 'Quintals (q)'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14, color: _textPrimary, fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadinessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.eco, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('Crop Readiness', style: TextStyle(fontSize: 14, color: _textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildReadinessOption('Almost Ready', '(1–7 days)'),
            const SizedBox(width: 8),
            _buildReadinessOption('Ready Soon', '(7–15 days)'),
            const SizedBox(width: 8),
            _buildReadinessOption('Not Ready', '(more than 15 days)'),
          ],
        ),
      ],
    );
  }

  Widget _buildReadinessOption(String title, String subtitle) {
    bool isSelected = _readiness == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _readiness = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? _lightGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? _primaryGreen : _borderColor, width: isSelected ? 1.5 : 1.0),
          ),
          child: Column(
            children: [
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? _darkGreen : _textPrimary)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info, color: _primaryGreen, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please update the details to help us plan the procurement slot for you.',
              style: TextStyle(fontSize: 13, color: _textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Save Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
          _buildNavItem(Icons.eco, 'My Crops', true),
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
        Icon(icon, color: isActive ? _primaryGreen : const Color(0xFF9E9E9E), size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? _primaryGreen : const Color(0xFF9E9E9E))),
      ],
    );
  }
}
