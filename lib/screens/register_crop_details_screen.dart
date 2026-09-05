import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'register_crop_timeline_screen.dart';

class RegisterCropDetailsScreen extends StatefulWidget {
  final AppState appState;

  const RegisterCropDetailsScreen({super.key, required this.appState});

  @override
  State<RegisterCropDetailsScreen> createState() => _RegisterCropDetailsScreenState();
}

class _RegisterCropDetailsScreenState extends State<RegisterCropDetailsScreen> {
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);
  static const _tipBg = Color(0xFFFFF8E1);

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
                    _buildCropSummaryCard(),
                    const SizedBox(height: 24),
                    const Text('Cultivation & Harvest Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(height: 16),
                    const Text('Cultivation Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _darkGreen)),
                    const SizedBox(height: 8),
                    _buildTextField('10 Jun 2026', Icons.calendar_today),
                    const SizedBox(height: 16),
                    const Text('Expected Harvest Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _darkGreen)),
                    const SizedBox(height: 8),
                    _buildTextField('15 Sep 2026', Icons.event_available),
                    const SizedBox(height: 16),
                    const Text('Initial Estimated Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _darkGreen)),
                    const SizedBox(height: 8),
                    _buildTextFieldWithSuffix('2,500', 'kg', Icons.shopping_bag_outlined),
                    const SizedBox(height: 24),
                    const Text('Add Crop Photos (Optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _darkGreen)),
                    const SizedBox(height: 12),
                    _buildPhotoGallery(),
                    const SizedBox(height: 24),
                    _buildTipCard(),
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _darkGreen),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Register Crop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darkGreen,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: _darkGreen),
            onPressed: () {},
          ),
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
          _buildProgressStep('2', 'Details', isActive: true, isCompleted: false),
          _buildProgressLine(isActive: false),
          _buildProgressStep('3', 'Timeline', isActive: false, isCompleted: false),
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
            border: Border.all(
              color: isActive || isCompleted ? _primaryGreen : const Color(0xFFE0E0E0),
            ),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: isActive || isCompleted ? Colors.white : _textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w500,
            color: isActive || isCompleted ? _darkGreen : _textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
        height: 2,
        color: isActive ? _primaryGreen : const Color(0xFFE0E0E0),
      ),
    );
  }

  Widget _buildCropSummaryCard() {
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
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Paddy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                SizedBox(height: 4),
                Text('Variety: ADT 45', style: TextStyle(fontSize: 12, color: _textSecondary)),
                Text('Land: North Field (2.0 Acres)', style: TextStyle(fontSize: 12, color: _textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Icon(icon, color: _textSecondary, size: 20),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithSuffix(String value, String suffix, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Icon(icon, color: _textSecondary, size: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16, top: 14),
            child: Text(suffix, style: const TextStyle(color: _textSecondary, fontSize: 14)),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return Row(
      children: [
        _buildPhotoItem('https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=150&auto=format&fit=crop'),
        const SizedBox(width: 12),
        _buildPhotoItem('https://images.unsplash.com/photo-1589923158776-cb4485d99fd6?q=80&w=150&auto=format&fit=crop'),
        const SizedBox(width: 12),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt, color: _primaryGreen, size: 24),
              SizedBox(height: 4),
              Text('Add Photo', style: TextStyle(fontSize: 10, color: _darkGreen, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(url, width: 70, height: 70, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.white, size: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _tipBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lightbulb, color: Color(0xFFFFB300), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Keep your harvest estimate updated. This helps us prepare procurement capacity and provide you with a suitable slot.',
              style: TextStyle(fontSize: 13, color: _textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterCropTimelineScreen(appState: widget.appState),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor.withOpacity(0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 'Home', false),
          _buildNavItem(Icons.eco, 'Crops', true), // Highlights Crops
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
        Icon(
          icon,
          color: isActive ? _darkGreen : const Color(0xFF9E9E9E),
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? _darkGreen : const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
