import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'land_details_screen.dart';

class AddLandPhotosScreen extends StatefulWidget {
  final AppState appState;

  const AddLandPhotosScreen({super.key, required this.appState});

  @override
  State<AddLandPhotosScreen> createState() => _AddLandPhotosScreenState();
}

class _AddLandPhotosScreenState extends State<AddLandPhotosScreen> {
  // ── COLORS ─────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFFCFAF5);
  static const _primaryGreen = Color(0xFF075B32);
  static const _darkGreen = Color(0xFF064E2A);
  static const _lightGreen = Color(0xFFEAF5E8);
  static const _softGreen = Color(0xFFF3F8EF);
  static const _borderColor = Color(0xFFD5E3CB);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF66716B);
  static const _warningMuted = Color(0xFFFDEFD2);
  static const _warningText = Color(0xFFB57008);

  // ── STATE ──────────────────────────────────────────────────────────────
  int _photoCount = 3;

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
                    _buildMainUploadCard(),
                    const SizedBox(height: 16),
                    _buildUploadActionCards(),
                    const SizedBox(height: 32),
                    _buildUploadedPhotosHeader(),
                    const SizedBox(height: 16),
                    _buildPhotoGrid(),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined, color: _primaryGreen, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Recommended Photos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _darkGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedPhotosGrid(),
                    const SizedBox(height: 32),
                    _buildVerificationCard(),
                    const SizedBox(height: 24),
                    _buildSecurityNote(),
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
                  'Add Land Photos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Upload clear photos of your agricultural land.',
                  style: TextStyle(
                    fontSize: 15,
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
          'Step 3 of 3',
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
            _buildProgressDot(isActive: true, isCompleted: true),
            _buildProgressLine(isActive: true),
            _buildProgressDot(isActive: true, isCompleted: false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
            const Text('Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
            const Text('Photos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
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
      width: 20,
      height: 20,
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

  Widget _buildMainUploadCard() {
    return CustomPaint(
      painter: _DashedBorderPainter(color: _primaryGreen.withOpacity(0.5)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBF4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: _primaryGreen, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Photos of Your Land',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a photo or upload from\nyour gallery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            subtitle: 'Use your camera',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.photo_library_outlined,
            title: 'Upload from Gallery',
            subtitle: 'Choose existing photos',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: _primaryGreen, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _darkGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedPhotosHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            'Uploaded Photos ($_photoCount/10)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darkGreen,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$_photoCount of 10 photos uploaded',
              style: const TextStyle(fontSize: 13, color: _textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index < _photoCount ? _primaryGreen : const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildPhotoTile(imageUrl: 'https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=300&auto=format&fit=crop'),
        _buildPhotoTile(imageUrl: 'https://images.unsplash.com/photo-1589923158776-cb4485d99fd6?q=80&w=300&auto=format&fit=crop'),
        _buildPhotoTile(imageUrl: 'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?q=80&w=300&auto=format&fit=crop'),
        _buildAddMoreTile(),
      ],
    );
  }

  Widget _buildPhotoTile({required String imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: _borderColor,
                child: const Center(child: Icon(Icons.broken_image, color: _textSecondary)),
              );
            },
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(Icons.close, color: _darkGreen, size: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreTile() {
    return CustomPaint(
      painter: _DashedBorderPainter(color: _primaryGreen.withOpacity(0.5)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBF4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: _primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add More',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedPhotosGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildRecommendedCard(icon: Icons.grass, title: 'Overall Land View', isAdded: true),
        _buildRecommendedCard(icon: Icons.spa, title: 'Current Crop Area', isAdded: true),
        _buildRecommendedCard(icon: Icons.location_on, title: 'Land Boundary', isAdded: false),
        _buildRecommendedCard(icon: Icons.edit_road, title: 'Access Road / Entrance', isAdded: false),
      ],
    );
  }

  Widget _buildRecommendedCard({
    required IconData icon,
    required String title,
    required bool isAdded,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryGreen, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          if (isAdded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                const SizedBox(width: 4),
                const Text('Added', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: _warningMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Optional',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _warningText),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
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
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: _primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'For Better Verification',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _darkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload clear and recent photos of your land. Avoid blurry, dark, or unrelated images.',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChecklistItem('Clear image'),
                const SizedBox(height: 6),
                _buildChecklistItem('Good lighting'),
                const SizedBox(height: 6),
                _buildChecklistItem('Recent photo'),
                const SizedBox(height: 6),
                _buildChecklistItem('Shows agricultural land'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: _textPrimary, height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.shield_outlined, color: _primaryGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: const Text(
            'Your photos are securely stored and used only for land verification and farm management.',
            style: TextStyle(
              fontSize: 13,
              color: _textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
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
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                if (_photoCount == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please add at least one photo of your land to continue.')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandDetailsScreen(appState: widget.appState),
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    const double dashWidth = 8;
    const double dashSpace = 6;
    
    // Top
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    // Bottom
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }
    // Left
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
    // Right
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
