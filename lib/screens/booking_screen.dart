import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
import '../models/booking.dart';

class BookingScreen extends StatefulWidget {
  final AppState appState;

  const BookingScreen({super.key, required this.appState});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMarket;
  String? _selectedMill;
  final TextEditingController _quantityController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  
  bool _isSuccess = false;
  String _generatedToken = '';

  final Color _darkGreen = const Color(0xFF1B5E20);
  final Color _lightGreen = const Color(0xFFE8F5E9);
  final Color _actionGreen = const Color(0xFF2E7D32);
  final Color _bgColor = const Color(0xFFF9FBF9);
  final Color _grayText = Colors.grey.shade600;
  final Color _borderColor = Colors.grey.shade300;

  // Mock data for dropdowns
  final List<String> _states = ['Tamil Nadu', 'Karnataka', 'Andhra Pradesh', 'Kerala'];
  final List<String> _districts = ['Chennai', 'Coimbatore', 'Madurai', 'Trichy'];
  final List<String> _markets = ['Central Market', 'North Market', 'South Market'];
  final List<String> _mills = ['Society A', 'Society B', 'Society C'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    if (_selectedState == null ||
        _selectedDistrict == null ||
        _selectedMarket == null ||
        _selectedMill == null ||
        _quantityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'தயவுசெய்து அனைத்து விவரங்களையும் நிரப்பவும்.'
                : 'Please fill in all details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'முறையான அளவை உள்ளிடவும்.'
                : 'Please enter a valid quantity.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bookingToken = "BKG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    setState(() {
      _generatedToken = bookingToken;
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;

    if (_isSuccess) {
      return _buildSuccessScreen(isTamil);
    }

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Icon(Icons.eco, color: _actionGreen, size: 20),
            Text(
              isTamil ? 'முன்பதிவு செய்' : 'Book Your Slot',
              style: TextStyle(
                color: _darkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isTamil ? 'உங்கள் நேரத்தை ஒதுக்குங்கள்' : 'Reserve your slot, save time and effort.',
              style: TextStyle(
                color: _grayText,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: _actionGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 90,
        actions: const [
          SizedBox(width: 48), // Balance for centering
        ],
      ),
      body: Stack(
        children: [
          // Top right decoration (placeholder for illustration)
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_lightGreen, Colors.transparent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100)),
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDropdownSection(
                    icon: Icons.map,
                    title: isTamil ? 'மாநிலம்' : 'State',
                    subtitle: isTamil ? 'மாநிலத்தைத் தேர்ந்தெடுக்கவும்' : 'Select your state',
                    value: _selectedState,
                    items: _states,
                    onChanged: (val) => setState(() => _selectedState = val),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdownSection(
                    icon: Icons.location_city,
                    title: isTamil ? 'மாவட்டம்' : 'District',
                    subtitle: isTamil ? 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select your district',
                    value: _selectedDistrict,
                    items: _districts,
                    onChanged: (val) => setState(() => _selectedDistrict = val),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdownSection(
                    icon: Icons.store,
                    title: isTamil ? 'சந்தை / மையம்' : 'Market / Procurement Centre',
                    subtitle: isTamil ? 'மையத்தைத் தேர்ந்தெடுக்கவும்' : 'Select market or centre',
                    value: _selectedMarket,
                    items: _markets,
                    onChanged: (val) => setState(() => _selectedMarket = val),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdownSection(
                    icon: Icons.factory,
                    title: isTamil ? 'ஆலை / சங்கம்' : 'Mill / Society',
                    subtitle: isTamil ? 'ஆலையைத் தேர்ந்தெடுக்கவும்' : 'Select mill or society',
                    value: _selectedMill,
                    items: _mills,
                    onChanged: (val) => setState(() => _selectedMill = val),
                  ),
                  const SizedBox(height: 24),
                  
                  // Expected Quantity Section (Updated)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.scale, color: _actionGreen),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTamil ? 'எதிர்பார்க்கப்படும் அளவு (குவிண்டால்)' : 'Approx Weight (Quintals)',
                              style: TextStyle(fontWeight: FontWeight.bold, color: _darkGreen, fontSize: 15),
                            ),
                            Text(
                              isTamil ? 'தோராயமான எடையை உள்ளிடவும்' : 'Enter approximate weight in quintals',
                              style: TextStyle(color: _grayText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'e.g., 25.00',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            isTamil ? 'குவிண்டால்' : 'Quintals',
                            style: TextStyle(color: _darkGreen, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Date Picker Section (Updated)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calendar_month, color: _actionGreen),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTamil ? 'தேதியைத் தேர்ந்தெடுக்கவும்' : 'Select Date',
                              style: TextStyle(fontWeight: FontWeight.bold, color: _darkGreen, fontSize: 16),
                            ),
                            Text(
                              isTamil ? 'விரும்பிய தேதியை தேர்வு செய்யவும்' : 'Choose a convenient date for your slot',
                              style: TextStyle(color: _grayText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCalendarCard(),
                  const SizedBox(height: 16),
                  
                  // Information Message (New)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _lightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.eco, color: _actionGreen, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTamil ? 'மேலே உள்ள காலெண்டரில் தேதியை தேர்வு செய்யவும்' : 'Please select a date from the calendar above',
                                style: TextStyle(fontWeight: FontWeight.bold, color: _darkGreen, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isTamil ? 'கிடைக்கக்கூடிய தேதிகள் மட்டுமே காட்டப்படும்.' : 'Only available dates are shown.',
                                style: TextStyle(color: _grayText, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Submit Button (Updated)
                  ElevatedButton.icon(
                    onPressed: _submitBooking,
                    icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                    label: Text(
                      isTamil ? 'தேர்ந்தெடுக்கப்பட்டதை உறுதிசெய்' : 'Confirm Selected Slot',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _darkGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Footer Illustration (Updated)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: _bgColor,
                border: Border(top: BorderSide(color: _borderColor, width: 0.5)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Icon(Icons.grass, color: _lightGreen, size: 40),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 16,
                    child: Icon(Icons.agriculture, color: _actionGreen, size: 40),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, color: _actionGreen, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          isTamil ? 'வலுவான பண்ணைகள், சிறந்த எதிர்காலம்' : 'Stronger Farms, Better Future',
                          style: TextStyle(
                            color: _darkGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.eco, color: _actionGreen, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _actionGreen),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: _darkGreen, fontSize: 15),
              ),
              Text(
                subtitle,
                style: TextStyle(color: _grayText, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text('Select', style: TextStyle(color: Colors.grey.shade400)),
              icon: Icon(Icons.keyboard_arrow_down, color: _darkGreen),
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday % 7; 
    
    final prevMonthDays = DateTime(now.year, now.month, 0).day;
    
    List<Widget> dayWidgets = [];
    
    // Previous month inactive days
    for (int i = firstWeekday - 1; i >= 0; i--) {
      dayWidgets.add(
        Center(
          child: Text(
            (prevMonthDays - i).toString(),
            style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          ),
        )
      );
    }
    
    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);
      final isSelected = _selectedDate.day == i && _selectedDate.month == now.month && _selectedDate.year == now.year;
      
      Color textColor = Colors.black87;
      if (date.weekday == DateTime.sunday) {
        textColor = Colors.red;
      } else if (date.weekday == DateTime.saturday) {
        textColor = _actionGreen;
      }
      
      if (isSelected) textColor = Colors.white;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? _darkGreen : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              i.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_left, color: _darkGreen, size: 20),
              ),
              Text(
                '${_getMonthName(now.month)} ${now.year}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right, color: _darkGreen, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((day) {
              Color headerColor = Colors.grey.shade800;
              if (day == 'Sun') headerColor = Colors.red;
              if (day == 'Sat') headerColor = _actionGreen;
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
            children: dayWidgets,
          ),
        ],
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // Keep the success screen
  Widget _buildSuccessScreen(bool isTamil) {
    return Scaffold(
      backgroundColor: _darkGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 70),
                  const SizedBox(height: 10),
                  Text(
                    AppTranslations.translate('booking_success', isTamil),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  
                  // Receipt Slip Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'GOVERNMENT PROCUREMENT SLIP',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedMarket ?? 'Market',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _darkGreen),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 30, thickness: 1.2),

                        // Token
                        Center(
                          child: Column(
                            children: [
                              Text(
                                AppTranslations.translate('your_token', isTamil),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber.shade600),
                                ),
                                child: Text(
                                  _generatedToken,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Grid values
                        _buildSlipRow(isTamil ? 'விவசாயி கைபேசி:' : 'Farmer Phone:', '+91 ${widget.appState.mobileNumber}'),
                        _buildSlipRow(isTamil ? 'மாநிலம்:' : 'State:', _selectedState ?? ''),
                        _buildSlipRow(isTamil ? 'மாவட்டம்:' : 'District:', _selectedDistrict ?? ''),
                        _buildSlipRow(isTamil ? 'எதிர்பார்க்கப்படும் அளவு:' : 'Expected Quantity:', '${_quantityController.text} Quintals'),
                        _buildSlipRow(isTamil ? 'தேதி:' : 'Scheduled Date:', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                        
                        const Divider(height: 30, thickness: 1.2),

                        // QR Code simulator widget
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CustomPaint(
                                  painter: QRGeneratorPainter(token: _generatedToken),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isTamil ? 'நுழைவாயிலில் இதை காண்பிக்கவும்' : 'Show this QR at the center gate',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Actions
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _darkGreen,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      AppTranslations.translate('go_back_home', isTamil),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlipRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}

class QRGeneratorPainter extends CustomPainter {
  final String token;
  const QRGeneratorPainter({required this.token});

  @override
  void paint(Canvas canvas, Size size) {
    final qrPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(const Rect.fromLTWH(0, 0, 25, 25), qrPaint);
    canvas.drawRect(const Rect.fromLTWH(5, 5, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(const Rect.fromLTWH(8, 8, 9, 9), qrPaint);

    canvas.drawRect(Rect.fromLTWH(size.width - 25, 0, 25, 25), qrPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 20, 5, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(size.width - 17, 8, 9, 9), qrPaint);

    canvas.drawRect(Rect.fromLTWH(0, size.height - 25, 25, 25), qrPaint);
    canvas.drawRect(Rect.fromLTWH(5, size.height - 20, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(8, size.height - 17, 9, 9), qrPaint);

    final int hash = token.hashCode;
    for (int x = 4; x < size.width - 4; x += 6) {
      for (int y = 4; y < size.height - 4; y += 6) {
        if (x < 28 && y < 28) continue;
        if (x > size.width - 28 && y < 28) continue;
        if (x < 28 && y > size.height - 28) continue;

        if ((x * y * hash) % 7 > 2.5) {
          canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 4, 4), qrPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
