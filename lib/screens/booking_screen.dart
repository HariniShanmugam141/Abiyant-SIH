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
  int _currentStep = 0;
  CropType? _selectedCrop;
  final TextEditingController _quantityController = TextEditingController();
  ProcurementCenter? _selectedCenter;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  
  bool _isSuccess = false;
  String _generatedToken = '';

  final List<String> _timeSlots = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  double get _estimatedPayout {
    if (_selectedCrop == null) return 0.0;
    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    final crop = Crop.getByType(_selectedCrop!);
    return qty * crop.mspPrice;
  }

  void _submitBooking() {
    if (_selectedCrop == null ||
        _selectedCenter == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null ||
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

    // Combine date and time slot details
    final bookingToken = widget.appState.createBooking(
      _selectedCrop!,
      qty,
      _selectedCenter!,
      _selectedDate!,
    );

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Text(AppTranslations.translate('booking_title', isTamil)),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0F5A24),
          ),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 0 && _selectedCrop == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isTamil ? 'பயிரைத் தேர்ந்தெடுக்கவும்' : 'Please select a crop')),
              );
              return;
            }
            if (_currentStep == 1) {
              final qty = double.tryParse(_quantityController.text) ?? 0.0;
              if (qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isTamil ? 'அளவு விவரத்தை உள்ளிடவும்' : 'Please enter quantity')),
                );
                return;
              }
            }
            if (_currentStep == 2 && _selectedCenter == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isTamil ? 'கொள்முதல் மையத்தைத் தேர்ந்தெடுக்கவும்' : 'Please select center')),
              );
              return;
            }

            if (_currentStep < 3) {
              setState(() => _currentStep += 1);
            } else {
              _submitBooking();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5A24),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep == 3 ? (isTamil ? 'முன்பதிவு செய்' : 'Confirm Book') : (isTamil ? 'தொடரவும்' : 'Continue')),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(isTamil ? 'பின்செல்லவும்' : 'Back'),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Crop Selection
            Step(
              title: Text(AppTranslations.translate('select_crop', isTamil)),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.editing,
              content: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Crop.availableCrops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final crop = Crop.availableCrops[index];
                  final isSelected = _selectedCrop == crop.type;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCrop = crop.type);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? crop.color.withOpacity(0.15) : Colors.white,
                        border: Border.all(
                          color: isSelected ? crop.color : Colors.grey.shade300,
                          width: isSelected ? 2.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(crop.iconData, color: crop.color, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            AppTranslations.translate(crop.nameKey, isTamil),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${crop.mspPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Step 2: Quantity
            Step(
              title: Text(AppTranslations.translate('enter_quantity', isTamil)),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.editing,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: isTamil ? 'உதாரணம்: 25.5' : 'e.g. 25.5',
                      suffixText: isTamil ? 'குவிண்டால்' : 'Quintals (100 Kg)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.scale),
                    ),
                    onChanged: (val) {
                      setState(() {}); // Recalculate estimated payout
                    },
                  ),
                  if (_selectedCrop != null && _quantityController.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      color: const Color(0xFFE8F5E9),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: Color(0xFF2E7D32)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isTamil ? 'மதிப்பிடப்பட்ட கொள்முதல் தொகை:' : 'Estimated Payout:',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                                Text(
                                  '₹${_estimatedPayout.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F5A24),
                                  ),
                                ),
                                Text(
                                  isTamil
                                      ? '*MSP விலைப்படி கணக்கிடப்பட்டது. தரம் அடிப்படையில் மாறுபடலாம்.'
                                      : '*Calculated on MSP. Actual price depends on quality inspection.',
                                  style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Step 3: Center Selection with Congestion Indicators
            Step(
              title: Text(AppTranslations.translate('select_center', isTamil)),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.editing,
              content: Column(
                children: ProcurementCenter.availableCenters.map((center) {
                  final isSelected = _selectedCenter?.id == center.id;
                  
                  // Congestion color styling
                  Color congestionColor = Colors.green;
                  String congestionTextKey = 'congestion_low';
                  if (center.congestionLevel == 'medium') {
                    congestionColor = Colors.orange;
                    congestionTextKey = 'congestion_med';
                  } else if (center.congestionLevel == 'high') {
                    congestionColor = Colors.red;
                    congestionTextKey = 'congestion_high';
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F5A24) : Colors.grey.shade200,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() => _selectedCenter = center);
                      },
                      title: Text(
                        isTamil ? center.nameTamil : center.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isTamil ? center.locationTamil : center.location, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: congestionColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppTranslations.translate(congestionTextKey, isTamil),
                                style: TextStyle(
                                  color: congestionColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '(${isTamil ? 'காத்திருப்பு:' : 'Wait:'} ~${center.averageWaitTime} ${AppTranslations.translate('minutes', isTamil)})',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF0F5A24))
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),

            // Step 4: DateTime Picker
            Step(
              title: Text(AppTranslations.translate('select_date_time', isTamil)),
              isActive: _currentStep >= 3,
              state: _currentStep == 3 ? StepState.editing : StepState.complete,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date selection button
                  OutlinedButton.icon(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                      );
                      if (selected != null) {
                        setState(() => _selectedDate = selected);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, color: Color(0xFF0F5A24)),
                    label: Text(
                      _selectedDate == null
                          ? (isTamil ? 'தேதியைத் தேர்ந்தெடுக்கவும்' : 'Pick Delivery Date')
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(color: Color(0xFF0F5A24)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (_selectedDate != null) ...[
                    Text(
                      isTamil ? 'கிடைக்கும் நேரங்கள்:' : 'Available Time Slots:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _timeSlots.map((slot) {
                        final isSelected = _selectedTimeSlot == slot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0F5A24),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTimeSlot = slot);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful Success Slip layout
  Widget _buildSuccessScreen(bool isTamil) {
    final crop = Crop.getByType(_selectedCrop!);
    final center = _selectedCenter!;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F5A24),
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
                                isTamil ? center.nameTamil : center.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F5A24)),
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
                        _buildSlipRow(isTamil ? 'பயிர் வகை:' : 'Crop Type:', AppTranslations.translate(crop.nameKey, isTamil)),
                        _buildSlipRow(isTamil ? 'எதிர்பார்க்கப்படும் அளவு:' : 'Expected Quantity:', '${_quantityController.text} Quintals'),
                        _buildSlipRow(isTamil ? 'தேதி:' : 'Scheduled Date:', '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                        _buildSlipRow(isTamil ? 'நேரம்:' : 'Time Window:', _selectedTimeSlot!),
                        _buildSlipRow(isTamil ? 'மதிப்பிடப்பட்ட விலை:' : 'Est. Value:', '₹${_estimatedPayout.toStringAsFixed(2)}'),
                        
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
                      Navigator.pop(context); // Close Booking screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F5A24),
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

// Vector Painter to simulate a custom QR code for the digital slip
class QRGeneratorPainter extends CustomPainter {
  final String token;
  const QRGeneratorPainter({required this.token});

  @override
  void paint(Canvas canvas, Size size) {
    final qrPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    // Draw 3 corner alignment boxes
    // Top-Left Box
    canvas.drawRect(const Rect.fromLTWH(0, 0, 25, 25), qrPaint);
    canvas.drawRect(const Rect.fromLTWH(5, 5, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(const Rect.fromLTWH(8, 8, 9, 9), qrPaint);

    // Top-Right Box
    canvas.drawRect(Rect.fromLTWH(size.width - 25, 0, 25, 25), qrPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 20, 5, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(size.width - 17, 8, 9, 9), qrPaint);

    // Bottom-Left Box
    canvas.drawRect(Rect.fromLTWH(0, size.height - 25, 25, 25), qrPaint);
    canvas.drawRect(Rect.fromLTWH(5, size.height - 20, 15, 15), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(8, size.height - 17, 9, 9), qrPaint);

    // Draw some random barcode/QR pixels using simple loops based on token hash
    final int hash = token.hashCode;
    for (int x = 4; x < size.width - 4; x += 6) {
      for (int y = 4; y < size.height - 4; y += 6) {
        // Skip corner finder boxes
        if (x < 28 && y < 28) continue;
        if (x > size.width - 28 && y < 28) continue;
        if (x < 28 && y > size.height - 28) continue;

        // Psuedo random decision
        if ((x * y * hash) % 7 > 2.5) {
          canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 4, 4), qrPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
