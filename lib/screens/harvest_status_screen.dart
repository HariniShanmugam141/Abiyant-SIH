import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'harvest_confirmation_screen.dart';

class HarvestStatusScreen extends StatelessWidget {
  final AppState appState;

  const HarvestStatusScreen({super.key, required this.appState});

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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildTitleSection(),
                    const SizedBox(height: 20),
                    _buildCropCard(),
                    const SizedBox(height: 16),
                    _buildTimelineCard(),
                    const SizedBox(height: 16),
                    _buildStatusActionCard(),
                    const SizedBox(height: 16),
                    _buildQuickInfoCard(context),
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
              Text('Harvest Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _darkGreen)),
              SizedBox(height: 4),
              Text('Track the current stage of your harvest.', style: TextStyle(fontSize: 13, color: _textSecondary)),
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

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineStep(icon: Icons.check, label: 'Growing', state: 0),
          _buildTimelineDivider(solid: true),
          _buildTimelineStep(icon: Icons.spa, label: 'Harvest\nApproaching', state: 1),
          _buildTimelineDivider(solid: true),
          _buildTimelineStep(icon: Icons.agriculture, label: 'Ready for\nHarvest', state: 2),
          _buildTimelineDivider(solid: false),
          _buildTimelineStep(icon: Icons.eco, label: 'Harvested', state: 2),
        ],
      ),
    );
  }

  Widget _buildTimelineDivider({required bool solid}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Container(
          height: 1.5,
          color: solid ? _primaryGreen : const Color(0xFFBDBDBD),
          // Note: Flutter doesn't have a native dashed line container without custom paint, 
          // but a thin grey line suffices for the mockup appearance.
        ),
      ),
    );
  }

  Widget _buildTimelineStep({required IconData icon, required String label, required int state}) {
    // state 0: completed, 1: active, 2: future
    Color circleColor;
    Color iconColor;
    Color borderColor;
    
    if (state == 0) {
      circleColor = _primaryGreen;
      iconColor = Colors.white;
      borderColor = _primaryGreen;
    } else if (state == 1) {
      circleColor = Colors.white;
      iconColor = _primaryGreen;
      borderColor = _primaryGreen;
    } else {
      circleColor = const Color(0xFFEEEEEE);
      iconColor = const Color(0xFF9E9E9E);
      borderColor = const Color(0xFFEEEEEE);
    }

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (state == 0 || state == 1)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: _primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: state == 1 ? FontWeight.bold : FontWeight.w500,
              color: state == 2 ? const Color(0xFF757575) : _darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusActionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Image.network(
              'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: _lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.spa, color: _primaryGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Harvest Approaching', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                      SizedBox(height: 4),
                      Text('Your crop is expected to be ready for harvest in 10 days. Please update your harvest details or book a slot.', style: TextStyle(fontSize: 12, color: _textSecondary, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _darkGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(Icons.calendar_today, 'Expected Date', '15 Sep 2026'),
              Container(width: 1, height: 30, color: _borderColor),
              _buildInfoItem(Icons.shopping_bag, 'Estimated Quantity', '1,200 kg'),
              Container(width: 1, height: 30, color: _borderColor),
              _buildInfoItem(Icons.location_on, 'Centre', 'Trichy APMC'),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HarvestConfirmationScreen(appState: appState)));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, color: _primaryGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Update Harvest Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryGreen))),
                  Icon(Icons.chevron_right, color: _primaryGreen, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _primaryGreen, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, color: _textSecondary)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textPrimary)),
                ],
              ),
            ),
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
