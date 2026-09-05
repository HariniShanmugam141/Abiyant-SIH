import 'package:flutter/material.dart';
import '../state/app_state.dart';

class LandDetailsScreen extends StatefulWidget {
  final AppState appState;

  const LandDetailsScreen({super.key, required this.appState});

  @override
  State<LandDetailsScreen> createState() => _LandDetailsScreenState();
}

class _LandDetailsScreenState extends State<LandDetailsScreen> {
  // ── COLORS ─────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFFCFAF5);
  static const _primaryGreen = Color(0xFF075B32);
  static const _darkGreen = Color(0xFF064E2A);
  static const _lightGreen = Color(0xFFEAF5E8);
  static const _softGreen = Color(0xFFF3F8EF);
  static const _borderColor = Color(0xFFD8E5D0);
  static const _textPrimary = Color(0xFF26352D);
  static const _textSecondary = Color(0xFF68736C);
  
  static const _warningMuted = Color(0xFFFDF3D9);
  static const _warningText = Color(0xFFB87808);
  static const _destructiveText = Color(0xFFD32F2F);
  static const _destructiveBorder = Color(0xFFEF9A9A);

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
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _buildQuickOverview(),
                    const SizedBox(height: 16),
                    _buildBasicInfo(),
                    const SizedBox(height: 16),
                    _buildTwoColumnGrid(),
                    const SizedBox(height: 16),
                    _buildVerificationCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: _darkGreen),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Land Details',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: _darkGreen, size: 20),
            label: const Text(
              'Edit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=600&auto=format&fit=crop',
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 190, color: _borderColor),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'North Paddy Field',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Thanjavur, Tamil Nadu',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Verified', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.aspect_ratio,
            value: '2.5',
            unit: 'Acres',
            label: 'Land Area',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.spa,
            value: '1',
            unit: '',
            label: 'Active Crop',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today,
            value: '12',
            unit: 'Days',
            label: 'Upcoming Harvest',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String unit, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
        children: [
          Icon(icon, color: _primaryGreen, size: 24),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _darkGreen),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _darkGreen),
                ),
              ]
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
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
              const Icon(Icons.list_alt, color: _primaryGreen, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Land Name', 'North Paddy Field'),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('Survey Number', '234/5A'),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('Land Area', '2.5 Acres'),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('Village', 'Thanjavur'),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('District', 'Thanjavur'),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('Land Type', '💧 Irrigated', isValueStrong: true),
          const Divider(height: 24, color: _borderColor),
          _buildInfoRow('Water Source', 'Canal'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isValueStrong = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: _textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isValueStrong ? FontWeight.bold : FontWeight.w500,
              color: _textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoColumnGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLandLocationCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildCropsCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLandPhotosCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildLandDocumentsCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLandLocationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.location_on_outlined, color: _primaryGreen, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Land Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1E4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: _MiniMapPainter(),
                  ),
                ),
                Center(
                  child: const Icon(Icons.location_on, color: _darkGreen, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Thanjavur, Tamil Nadu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 8),
          const Text('Latitude: 10.7867° N', style: TextStyle(fontSize: 12, color: _textSecondary)),
          const Text('Longitude: 79.1378° E', style: TextStyle(fontSize: 12, color: _textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('View Full Map', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, color: _darkGreen, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCropsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.spa_outlined, color: _primaryGreen, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Crops on This Land',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.grass, color: _primaryGreen, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Paddy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
                          const SizedBox(height: 2),
                          const Text('Variety: ADT-43', style: TextStyle(fontSize: 12, color: _textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Cultivated Area: 2 Acres', style: TextStyle(fontSize: 12, color: _textPrimary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                    const SizedBox(width: 4),
                    const Text('Growing', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Expected Harvest: 20 May', style: TextStyle(fontSize: 12, color: _textSecondary)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, color: _darkGreen, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: _primaryGreen, size: 16),
              label: const Text('Add Crop', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryGreen)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: _primaryGreen, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandPhotosCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.camera_alt_outlined, color: _primaryGreen, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Land Photos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMiniPhoto('https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=150&auto=format&fit=crop'),
              _buildMiniPhoto('https://images.unsplash.com/photo-1589923158776-cb4485d99fd6?q=80&w=150&auto=format&fit=crop'),
              _buildMiniPhoto('https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?q=80&w=150&auto=format&fit=crop'),
              Container(
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderColor, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('+2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen)),
                    Text('More', style: TextStyle(fontSize: 12, color: _darkGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Manage Photos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _darkGreen)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, color: _darkGreen, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPhoto(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: _borderColor),
      ),
    );
  }

  Widget _buildLandDocumentsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.folder_outlined, color: _primaryGreen, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Land Documents',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDocItem('Land Survey Record.pdf', '10 May 2026', 'Verified', true),
          const Divider(height: 16, color: _borderColor),
          _buildDocItem('Land Supporting Document.pdf', '10 May 2026', 'Under Review', false),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: _primaryGreen, size: 16),
              label: const Text('Upload New Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _primaryGreen), textAlign: TextAlign.center),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                side: const BorderSide(color: _primaryGreen, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(String title, String date, String status, bool isVerified) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.insert_drive_file_outlined, color: _primaryGreen, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('Uploaded: $date', style: const TextStyle(fontSize: 10, color: _textSecondary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isVerified ? _lightGreen : _warningMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isVerified ? _darkGreen : _warningText,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const Icon(Icons.remove_red_eye_outlined, color: _textSecondary, size: 18),
            const SizedBox(height: 4),
            const Icon(Icons.more_vert, color: _textSecondary, size: 18),
          ],
        )
      ],
    );
  }

  Widget _buildVerificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: _primaryGreen, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Land Verification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Verified', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your land information has been successfully verified.',
                  style: TextStyle(fontSize: 14, color: _textPrimary, height: 1.4),
                ),
              ],
            ),
          ),
          Icon(Icons.verified_user, color: _primaryGreen.withOpacity(0.1), size: 64),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
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
            flex: 4,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.white, size: 18),
              label: const Text('Edit Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _darkGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined, color: _primaryGreen, size: 18),
              label: const Text('Manage Photos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryGreen), maxLines: 1, overflow: TextOverflow.ellipsis),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: _primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: _destructiveBorder, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, color: _destructiveText, size: 16),
                  SizedBox(width: 4),
                  Expanded(child: Text('Remove', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _destructiveText), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F1E4)..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    final riverPaint = Paint()
      ..color = const Color(0xFFB3E5FC)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final river = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width * 0.3, size.height);
    canvas.drawPath(river, riverPaint);

    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.6), roadPaint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.8, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
