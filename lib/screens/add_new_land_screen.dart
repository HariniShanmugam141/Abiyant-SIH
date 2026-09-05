import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'select_land_location_screen.dart';

class AddNewLandScreen extends StatefulWidget {
  final AppState appState;

  const AddNewLandScreen({super.key, required this.appState});

  @override
  State<AddNewLandScreen> createState() => _AddNewLandScreenState();
}

class _AddNewLandScreenState extends State<AddNewLandScreen> {
  // ── COLORS ─────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFFCFAF5);
  static const _primaryGreen = Color(0xFF075B32);
  static const _darkGreen = Color(0xFF064E2A);
  static const _lightGreen = Color(0xFFEAF5E8);
  static const _softGreen = Color(0xFFF3F8EF);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);

  // ── STATE ──────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  
  String? _landType; // 'Irrigated', 'Rain-fed', 'Wet Land', 'Dry Land'
  final Set<String> _waterSources = {};
  
  String _areaUnit = 'Acres';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildProgressIndicator(),
                      const SizedBox(height: 32),
                      _buildSectionTitle(Icons.grass, 'Basic Information'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Land Name (Optional)',
                        hint: 'e.g. North Paddy Field',
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Example: North Field, Home Farm, Paddy Land',
                        style: TextStyle(fontSize: 13, color: _textSecondary),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Survey / Reference Number *',
                        hint: 'Enter survey number',
                        isRequired: true,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enter the survey or reference number of your land.',
                        style: TextStyle(fontSize: 13, color: _textSecondary),
                      ),
                      const SizedBox(height: 24),
                      _buildAreaField(),
                      const SizedBox(height: 32),
                      _buildSectionTitle(Icons.location_on_outlined, 'Location Information'),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Village *',
                        hint: 'Select your village',
                        items: ['Thanjavur North', 'Thanjavur South', 'Kumbakonam', 'Papanasam', 'Pattukkottai'],
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 24),
                      _buildDropdownField(
                        label: 'District *',
                        hint: 'Select your district',
                        value: 'Thanjavur',
                        items: ['Thanjavur', 'Trichy', 'Madurai', 'Chennai', 'Coimbatore'],
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle(Icons.water_drop_outlined, 'Land Type', isRequired: true),
                      const SizedBox(height: 16),
                      _buildLandTypeGrid(),
                      const SizedBox(height: 32),
                      _buildSectionTitle(Icons.water_drop_outlined, 'Water Source (Optional)'),
                      const SizedBox(height: 16),
                      _buildWaterSourceGrid(),
                      const SizedBox(height: 32),
                      _buildInfoCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomActionArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _darkGreen),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Land',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter your agricultural land details',
                  style: TextStyle(
                    fontSize: 16,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1 of 3',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildProgressDot(isActive: true),
            _buildProgressLine(isActive: true),
            _buildProgressDot(isActive: false),
            _buildProgressLine(isActive: false),
            _buildProgressDot(isActive: false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: const Text('Location', style: TextStyle(fontSize: 12, color: _textSecondary)),
            ),
            const Text('Photos', style: TextStyle(fontSize: 12, color: _textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressDot({required bool isActive}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? _darkGreen : _bg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? _darkGreen : const Color(0xFFB0BEC5),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? _darkGreen : const Color(0xFFCFD8DC),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {bool isRequired = false}) {
    return Row(
      children: [
        Icon(icon, color: _primaryGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _darkGreen,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
            ),
          ),
          validator: isRequired
              ? (value) => value == null || value.isEmpty ? 'This field is required' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    String? value,
    List<String>? items,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
            children: [
              if (label.contains('*'))
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF9E9E9E))),
          icon: const Icon(Icons.keyboard_arrow_down, color: _darkGreen),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
            ),
          ),
          items: items != null
              ? items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList()
              : (value != null
                  ? [DropdownMenuItem(value: value, child: Text(value))]
                  : []),
          onChanged: onChanged ?? (val) {},
          validator: label.contains('*')
              ? (val) => val == null && value == null ? 'Please select an option' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildAreaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Land Area',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '2.5',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _borderColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _areaUnit,
                icon: const Icon(Icons.keyboard_arrow_down, color: _darkGreen),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _borderColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
                  ),
                ),
                items: ['Acres', 'Hectares', 'Cents']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _areaUnit = val);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLandTypeGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSelectableChip(
          title: 'Irrigated',
          icon: Icons.water_drop,
          iconColor: Colors.lightBlue,
          isSelected: _landType == 'Irrigated',
          onTap: () => setState(() => _landType = 'Irrigated'),
        ),
        _buildSelectableChip(
          title: 'Rain-fed',
          icon: Icons.cloud,
          iconColor: Colors.blueGrey,
          isSelected: _landType == 'Rain-fed',
          onTap: () => setState(() => _landType = 'Rain-fed'),
        ),
        _buildSelectableChip(
          title: 'Wet Land',
          icon: Icons.eco,
          iconColor: Colors.lightGreen,
          isSelected: _landType == 'Wet Land',
          onTap: () => setState(() => _landType = 'Wet Land'),
        ),
        _buildSelectableChip(
          title: 'Dry Land',
          icon: Icons.wb_sunny,
          iconColor: Colors.orange,
          isSelected: _landType == 'Dry Land',
          onTap: () => setState(() => _landType = 'Dry Land'),
        ),
      ],
    );
  }

  Widget _buildWaterSourceGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildMultiSelectChip(title: 'Borewell', icon: Icons.water_damage_outlined),
        _buildMultiSelectChip(title: 'Canal', icon: Icons.waves),
        _buildMultiSelectChip(title: 'Rainwater', icon: Icons.cloudy_snowing),
        _buildMultiSelectChip(title: 'River', icon: Icons.water),
        _buildMultiSelectChip(title: 'Other', icon: Icons.more_horiz),
      ],
    );
  }

  Widget _buildSelectableChip({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? _lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _primaryGreen : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? _darkGreen : _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectChip({
    required String title,
    required IconData icon,
  }) {
    final isSelected = _waterSources.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _waterSources.remove(title);
          } else {
            _waterSources.add(title);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryGreen : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? _primaryGreen : _textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? _darkGreen : _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: _primaryGreen, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why do we need these details?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your land information helps us provide accurate crop management, harvest planning, and procurement recommendations.',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor.withOpacity(0.5))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: _primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, color: _primaryGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Save as Draft',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_landType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a Land Type')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectLandLocationScreen(appState: widget.appState),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
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
          ),
        ],
      ),
    );
  }
}
