import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'register_crop_screen.dart';

class MyCropsScreen extends StatelessWidget {
  final AppState appState;

  const MyCropsScreen({super.key, required this.appState});

  // ── COLORS ─────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF9FCF7);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _darkGreen = Color(0xFF0F3B15);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _softGreen = Color(0xFFF1F8E9);
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
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildGreeting(),
                    const SizedBox(height: 16),
                    _buildWeatherCard(),
                    const SizedBox(height: 20),
                    _buildOverviewCard(),
                    const SizedBox(height: 24),
                    _buildCropsList(),
                    const SizedBox(height: 16),
                    _buildRegisterButton(context),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ABHIYANT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _darkGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Smart Procurement Centre',
                    style: TextStyle(
                      fontSize: 12,
                      color: _darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, color: _darkGreen, size: 30),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vanakkam, Ramasamy 👋',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _darkGreen,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.location_on, color: _primaryGreen, size: 16),
            SizedBox(width: 6),
            Text(
              'Thiruporur, Kanchipuram',
              style: TextStyle(
                fontSize: 14,
                color: _textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Color(0xFFFFCA28), size: 48),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '28°C',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Partly Cloudy',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today', style: TextStyle(fontSize: 12, color: _textSecondary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.arrow_upward, color: _textSecondary, size: 12),
                      Text(' 32°C', style: TextStyle(fontSize: 12, color: _textPrimary, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_downward, color: _textSecondary, size: 12),
                      Text(' 24°C', style: TextStyle(fontSize: 12, color: _textPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.umbrella, color: Colors.blueAccent, size: 12),
                      Text(' Rain Chance 20%', style: TextStyle(fontSize: 11, color: _textPrimary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Good weather for field work!',
                style: TextStyle(
                  fontSize: 13,
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _darkGreen)),
                    Icon(Icons.chevron_right, color: _darkGreen, size: 16),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.public, color: _primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'My Crops Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: const [
                      Text(
                        '3',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _darkGreen,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Registered Crops',
                        style: TextStyle(fontSize: 12, color: _textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: _borderColor,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '5.5',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _darkGreen,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Acres',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total Cultivated Area',
                        style: TextStyle(fontSize: 12, color: _textSecondary, fontWeight: FontWeight.w500),
                      ),
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

  Widget _buildCropsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Crops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
            Row(
              children: const [
                Text(
                  'View All',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryGreen),
                ),
                Icon(Icons.chevron_right, color: _primaryGreen, size: 16),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCropCard(
          title: 'Paddy',
          status: 'Growing',
          harvestDate: '15 Sep 2025',
          area: '2.0 Acres',
          quantity: '2,500 kg',
          imageUrl: 'https://images.unsplash.com/photo-1599839619722-39751411ea63?q=80&w=200&auto=format&fit=crop',
          statusColor: const Color(0xFF388E3C),
          statusBg: const Color(0xFFE8F5E9),
        ),
        const SizedBox(height: 12),
        _buildCropCard(
          title: 'Maize',
          status: 'Vegetative',
          harvestDate: '10 Oct 2025',
          area: '1.5 Acres',
          quantity: '1,800 kg',
          imageUrl: 'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?q=80&w=200&auto=format&fit=crop',
          statusColor: const Color(0xFFF57C00),
          statusBg: const Color(0xFFFFF3E0),
        ),
        const SizedBox(height: 12),
        _buildCropCard(
          title: 'Groundnut',
          status: 'Land Prepared',
          harvestDate: '25 Nov 2025',
          area: '2.0 Acres',
          quantity: '1,200 kg',
          imageUrl: 'https://images.unsplash.com/photo-1589923158776-cb4485d99fd6?q=80&w=200&auto=format&fit=crop',
          statusColor: const Color(0xFF1976D2),
          statusBg: const Color(0xFFE3F2FD),
        ),
      ],
    );
  }

  Widget _buildCropCard({
    required String title,
    required String status,
    required String harvestDate,
    required String area,
    required String quantity,
    required String imageUrl,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: _softGreen,
                child: const Icon(Icons.image, color: _primaryGreen),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _darkGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: _textSecondary, size: 14),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: _textSecondary),
                        children: [
                          const TextSpan(text: 'Harvest: '),
                          TextSpan(text: harvestDate, style: const TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: _textSecondary, size: 14),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: _textSecondary),
                        children: [
                          const TextSpan(text: 'Area: '),
                          TextSpan(text: area, style: const TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.monitor_weight_outlined, color: _textSecondary, size: 14),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: _textSecondary),
                        children: [
                          const TextSpan(text: 'Est. Quantity: '),
                          TextSpan(text: quantity, style: const TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _darkGreen, size: 28),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterCropScreen(appState: appState),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text(
          'Register New Crop',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
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
          _buildNavItem(Icons.home_filled, 'Home', true),
          _buildNavItem(Icons.eco, 'Crops', false),
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
