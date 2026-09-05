import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'add_land_photos_screen.dart';

class SelectLandLocationScreen extends StatefulWidget {
  final AppState appState;

  const SelectLandLocationScreen({super.key, required this.appState});

  @override
  State<SelectLandLocationScreen> createState() => _SelectLandLocationScreenState();
}

class _SelectLandLocationScreenState extends State<SelectLandLocationScreen> {
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
  bool _isLocationDetected = false;
  double _lat = 10.7867;
  double _lng = 79.1378;

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
                    const SizedBox(height: 32),
                    _buildGpsCard(),
                    const SizedBox(height: 24),
                    _buildOrDivider(),
                    const SizedBox(height: 24),
                    _buildMapSection(),
                    const SizedBox(height: 24),
                    _buildSelectedLocationCard(),
                    const SizedBox(height: 16),
                    _buildAccuracyStatus(),
                    const SizedBox(height: 24),
                    _buildOptionalBoundaryCard(),
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                    const SizedBox(height: 32),
                  ],
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
                  'Select Land Location',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pin your agricultural land location on the map.',
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
          'Step 2 of 3',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildProgressDot(isActive: true, isCompleted: true),
            _buildProgressLine(isActive: true),
            _buildProgressDot(isActive: true, isCompleted: false),
            _buildProgressLine(isActive: false),
            _buildProgressDot(isActive: false, isCompleted: false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
            const Text('Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
            const Text('Photos', style: TextStyle(fontSize: 12, color: _textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressDot({required bool isActive, required bool isCompleted}) {
    if (isCompleted) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: _darkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      );
    }
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

  Widget _buildGpsCard() {
    if (_isLocationDetected) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _softGreen,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: _primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Location Detected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _darkGreen,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Latitude:', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    Text('${_lat.toStringAsFixed(4)}° N', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Longitude:', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    Text('${_lng.toStringAsFixed(4)}° E', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accuracy:', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    const Text('± 12 meters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: _primaryGreen, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Use Current Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll use your device GPS to detect your current location.',
            style: TextStyle(fontSize: 15, color: _textSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() => _isLocationDetected = true);
              },
              icon: const Icon(Icons.my_location, color: Colors.white, size: 20),
              label: const Text(
                'Detect My Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: _borderColor, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textSecondary,
            ),
          ),
        ),
        Expanded(child: Divider(color: _borderColor, thickness: 1)),
      ],
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.map_outlined, color: _primaryGreen, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Select on Map',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap or drag the pin to mark your agricultural land location.',
          style: TextStyle(fontSize: 15, color: _textSecondary),
        ),
        const SizedBox(height: 16),
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1E4), // Map background simulation
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Map background mock
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: CustomPaint(
                  size: const Size(double.infinity, 320),
                  painter: _MapGridPainter(),
                ),
              ),
              
              // Center Pin
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: _darkGreen,
                      size: 48,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Text(
                        'Your Land',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen),
                      ),
                    ),
                  ],
                ),
              ),

              // Map Controls
              Positioned(
                right: 12,
                top: 12,
                child: Column(
                  children: [
                    _buildMapControlBtn(Icons.add),
                    const SizedBox(height: 8),
                    _buildMapControlBtn(Icons.remove),
                    const SizedBox(height: 16),
                    _buildMapControlBtn(Icons.my_location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: _primaryGreen, size: 22),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSelectedLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: _primaryGreen, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Selected Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined, color: _textSecondary, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Thanjavur, Tamil Nadu',
                style: TextStyle(fontSize: 15, color: _textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Latitude', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    const SizedBox(height: 2),
                    Text('${_lat.toStringAsFixed(4)}° N', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: _borderColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Longitude', style: TextStyle(fontSize: 13, color: _textSecondary)),
                    const SizedBox(height: 2),
                    Text('${_lng.toStringAsFixed(4)}° E', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: _borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nearest Village', style: TextStyle(fontSize: 14, color: _textSecondary)),
              const Text('Thanjavur', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('District', style: TextStyle(fontSize: 14, color: _textSecondary)),
              const Text('Thanjavur', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyStatus() {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'High Accuracy — Within 10 meters',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionalBoundaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Optional — Mark Land Boundary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
              Icon(Icons.share_location, color: _primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mark the corners of your agricultural land for more accurate area verification.',
            style: TextStyle(fontSize: 14, color: _textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: _primaryGreen, size: 18),
            label: const Text(
              'Mark Boundary',
              style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _primaryGreen, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
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
                  'Why do we need your location?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your land location helps us provide accurate weather updates, travel recommendations, and nearby procurement centre suggestions.',
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
                  Icon(Icons.arrow_back, color: _primaryGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Back',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLandPhotosScreen(appState: widget.appState),
                  ),
                );
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
                    'Confirm Location',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F1E4)..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    
    final riverPaint = Paint()
      ..color = const Color(0xFFB3E5FC)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final treePaint = Paint()..color = const Color(0xFFC5E1A5)..style = PaintingStyle.fill;

    // Draw river
    final river = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.1, size.height);
    canvas.drawPath(river, riverPaint);

    // Draw roads
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.6), roadPaint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.8, size.height), roadPaint);

    // Draw some mock field boundaries
    final fieldPaint = Paint()
      ..color = const Color(0xFFDCE7C5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.4, size.height * 0.2, 80, 60), fieldPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, size.height * 0.1, 60, 90), fieldPaint);

    // Scatter some trees
    final trees = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.4, size.height * 0.8),
      Offset(size.width * 0.45, size.height * 0.85),
      Offset(size.width * 0.85, size.height * 0.4),
      Offset(size.width * 0.9, size.height * 0.45),
    ];
    for (final t in trees) {
      canvas.drawCircle(t, 4, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
