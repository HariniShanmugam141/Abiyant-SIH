import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'harvest_status_screen.dart';

class HarvestIntimationScreen extends StatefulWidget {
  final AppState appState;

  const HarvestIntimationScreen({super.key, required this.appState});

  @override
  State<HarvestIntimationScreen> createState() => _HarvestIntimationScreenState();
}

class _HarvestIntimationScreenState extends State<HarvestIntimationScreen> {
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
                    const SizedBox(height: 16),
                    _buildTopCard(),
                    const SizedBox(height: 24),
                    const Text('Harvest Intimation Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(height: 12),
                    _buildFormCard(),
                    const SizedBox(height: 16),
                    _buildInfoBanner(),
                    const SizedBox(height: 24),
                    _buildSendButton(),
                    const SizedBox(height: 12),
                    _buildCancelButton(context),
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
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: _darkGreen), onPressed: () => Navigator.pop(context)),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ABHIYANT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _darkGreen, letterSpacing: 0.5)),
                  Text('SMART PROCUREMENT CENTRE', style: TextStyle(fontSize: 8, color: _darkGreen, fontWeight: FontWeight.bold)),
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
    return Center(
      child: Column(
        children: const [
          Text('Harvest Intimation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _darkGreen)),
          SizedBox(height: 4),
          Text('Inform the procurement centre', style: TextStyle(fontSize: 14, color: _textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            child: Image.network(
              'https://images.unsplash.com/photo-1586528116311-ad8ed7c83f98?q=80&w=250&auto=format&fit=crop', // Warehouse/Procurement centre
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Inform the procurement centre that you are planning to harvest soon.',
                      style: TextStyle(fontSize: 12, color: _textPrimary, height: 1.4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: _borderColor),
                    ),
                    child: const Icon(Icons.notifications, color: _primaryGreen, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
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
          _buildExpectedHarvestField(),
          const SizedBox(height: 20),
          _buildExpectedQuantityField(),
        ],
      ),
    );
  }

  Widget _buildExpectedHarvestField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expected Harvest Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.calendar_today, color: _textSecondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                    hintText: '15 September 2026',
                    hintStyle: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                    suffixIcon: Icon(Icons.calendar_today, color: _textSecondary, size: 20),
                  ),
                  style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpectedQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expected Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: _textSecondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
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
                    hintText: '1,200',
                    hintStyle: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: 'Kilograms (kg)',
                    icon: const Icon(Icons.keyboard_arrow_down, color: _textSecondary),
                    items: ['Kilograms (kg)', 'Quintals (q)'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 13, color: _textPrimary, fontWeight: FontWeight.w500)),
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

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
            child: const Icon(Icons.info, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Once intimated, we will notify you when slots are available at your nearest centre.',
              style: TextStyle(fontSize: 13, color: _textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Harvest Intimation Sent Successfully\nWe will notify you when procurement slots become available.'),
              backgroundColor: Color(0xFF1B5E20),
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HarvestStatusScreen(appState: widget.appState),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text('Send Intimation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: _primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryGreen)),
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
