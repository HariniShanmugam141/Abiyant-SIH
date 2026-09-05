import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'harvest_intimation_screen.dart';

class CropDetailsScreen extends StatelessWidget {
  final AppState appState;

  const CropDetailsScreen({super.key, required this.appState});

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
                child: Column(
                  children: [
                    _buildHeroImage(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildTimelineCard(),
                          const SizedBox(height: 16),
                          _buildInformationCard(),
                          const SizedBox(height: 24),
                          _buildActionButtons(context),
                          const SizedBox(height: 24),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: _darkGreen), onPressed: () => Navigator.pop(context)),
          const Text('Crop Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _darkGreen)),
          const SizedBox(width: 48), // Balance for centering
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=600&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Paddy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFC8E6C9), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Growing', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Variety: ADT 45   |   Land: North Field',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Crop Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
          const SizedBox(height: 16),
          _buildTimelineItem('Land Registered', '05 Jun 2025', isCompleted: true),
          _buildTimelineItem('Crop Registered', '10 Jun 2025', isCompleted: true),
          _buildTimelineItem('Currently Growing', 'Good progress', isCompleted: true, highlightSub: true),
          _buildTimelineItem('Harvest Approaching', 'In 25 days', isCompleted: false),
          _buildTimelineItem('Ready for Harvest', '-', isCompleted: false),
          _buildTimelineItem('Harvested', '-', isCompleted: false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, {required bool isCompleted, bool isLast = false, bool highlightSub = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted ? _primaryGreen : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: isCompleted ? _primaryGreen : const Color(0xFF9E9E9E), width: 1.5),
                  ),
                  child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                ),
                if (!isLast)
                  Expanded(child: Container(width: 1.5, color: isCompleted ? _primaryGreen : const Color(0xFFE0E0E0))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isCompleted ? _darkGreen : _textSecondary)),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: highlightSub ? _primaryGreen : _textSecondary, fontWeight: highlightSub ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Crop Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _borderColor),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: _primaryGreen, size: 16),
                    SizedBox(width: 4),
                    Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _primaryGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.eco, 'Cultivated Area', '2.0 Acres'),
          _buildDivider(),
          _buildInfoRow(Icons.calendar_today, 'Cultivation Date', '10 Jun 2025'),
          _buildDivider(),
          _buildInfoRow(Icons.event_available, 'Expected Harvest Date', '15 Sep 2025'),
          _buildDivider(),
          _buildInfoRow(Icons.inventory_2, 'Estimated Quantity', '2,500 kg'),
          _buildDivider(),
          _buildInfoRow(Icons.track_changes, 'Latest Update', '-'),
          _buildDivider(),
          _buildInfoRow(Icons.camera_alt, 'Photos', '2 Photos >'),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 24, color: Color(0xFFF0F0F0));
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _primaryGreen, size: 20),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: _textSecondary))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textPrimary)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: _primaryGreen, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit, color: _primaryGreen, size: 18),
                SizedBox(width: 8),
                Text('Update Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryGreen)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HarvestIntimationScreen(appState: appState),
                ),
              );
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
                Icon(Icons.notifications_active, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Harvest Intimation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
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
