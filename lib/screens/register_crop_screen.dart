import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'register_crop_details_screen.dart';

class RegisterCropScreen extends StatefulWidget {
  final AppState appState;

  const RegisterCropScreen({super.key, required this.appState});

  @override
  State<RegisterCropScreen> createState() => _RegisterCropScreenState();
}

class _RegisterCropScreenState extends State<RegisterCropScreen> {
  // ── COLORS ─────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

  String _selectedCrop = 'Paddy';

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
                    _buildSectionTitle('Select Crop Type'),
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildCropGrid(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Select Variety (Optional)'),
                    const SizedBox(height: 8),
                    _buildDropdown('ADT 45'),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Link to Land Parcel'),
                    const SizedBox(height: 8),
                    _buildDropdown('North Field (2.0 Acres)'),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Cultivated Area (Acres)'),
                    const SizedBox(height: 8),
                    _buildTextField('2.0', 'Acres'),
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
          _buildProgressStep('1', 'Crop', isActive: true, isCompleted: false),
          _buildProgressLine(isActive: true),
          _buildProgressStep('2', 'Details', isActive: false, isCompleted: false),
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
            color: isActive ? _primaryGreen : const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? _primaryGreen : const Color(0xFFE0E0E0),
            ),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: isActive ? Colors.white : _textSecondary,
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
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? _darkGreen : _textSecondary,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: _darkGreen,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search crop (e.g., Paddy, Maize, Groundnut)',
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCropGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCropTile('Paddy', '🌾', isSelected: _selectedCrop == 'Paddy'),
        _buildCropTile('Maize', '🌽', isSelected: _selectedCrop == 'Maize'),
        _buildCropTile('Groundnut', '🥜', isSelected: _selectedCrop == 'Groundnut'),
        _buildCropTile('Sugarcane', '🎋', isSelected: _selectedCrop == 'Sugarcane'),
        _buildCropTile('Ragi', '🌿', isSelected: _selectedCrop == 'Ragi'),
        _buildCropTile('Others', '•••', isSelected: _selectedCrop == 'Others', isOther: true),
      ],
    );
  }

  Widget _buildCropTile(String title, String emoji, {required bool isSelected, bool isOther = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCrop = title;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? _lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primaryGreen : _borderColor,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isOther)
                    const Icon(Icons.more_horiz, color: _textSecondary, size: 32)
                  else
                    Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? _darkGreen : _textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 6,
              right: 6,
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
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: _textSecondary),
          items: [
            DropdownMenuItem(value: value, child: Text(value, style: const TextStyle(fontSize: 14, color: _textPrimary))),
          ],
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildTextField(String value, String suffix) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16, top: 14),
            child: Text(suffix, style: const TextStyle(color: _textSecondary, fontSize: 14)),
          ),
        ),
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
              builder: (context) => RegisterCropDetailsScreen(appState: widget.appState),
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
            Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
