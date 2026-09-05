import 'package:flutter/material.dart';
import '../state/app_state.dart';

class WeatherAlertsScreen extends StatelessWidget {
  final AppState appState;

  const WeatherAlertsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weather & Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3B36))),
            Text('Check weather, alerts and travel advisories', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.location_on, size: 14, color: Color(0xFF2E7D32)),
                  SizedBox(width: 4),
                  Text('Tiruchirappalli', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 740),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Weather Gradient Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [const Color(0xFF90CAF9), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Sun/Cloud Icon Placeholder (Using basic flutter icons for approximation)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
                              child: const Icon(Icons.cloud, color: Colors.white, size: 50),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Today', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                  const Text('28°C', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  const Text('Partly Cloudy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  Text('Feels like 30°C', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildWeatherStat('Humidity', '62%'),
                                const SizedBox(height: 8),
                                _buildWeatherStat('Wind', '12 km/h'),
                                const SizedBox(height: 8),
                                _buildWeatherStat('Rain Chance', '20%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.eco, color: Color(0xFF2E7D32), size: 18),
                            SizedBox(width: 8),
                            Expanded(child: Text('Good weather for field work!', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 13, fontWeight: FontWeight.bold))),
                            Icon(Icons.chevron_right, color: Color(0xFF1B3B36), size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // 2. Rain Alert Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.red.shade100)),
                            child: const Icon(Icons.cloudy_snowing, color: Colors.blue, size: 24),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Icon(Icons.priority_high, size: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rain Alert', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('High Priority', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Moderate to heavy rain is expected between 11:00 AM - 1:00 PM in your area and at the procurement centre. Travel time may increase.',
                              style: TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text('Today, 08:45 AM', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Travel Advisory Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.amber.shade100, shape: BoxShape.circle),
                        child: const Icon(Icons.directions_car, color: Color(0xFF665000), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Travel Advisory', style: TextStyle(color: Color(0xFF1B3B36), fontWeight: FontWeight.bold, fontSize: 14)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Be Prepared', style: TextStyle(color: Color(0xFF665000), fontSize: 9, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Roads may be wet. Please start your journey earlier and ensure proper grain protection.',
                              style: TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text('Today, 08:30 AM', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // 4. Hourly Forecast
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Hourly Forecast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                    Text('View More >', style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHourlyItem('9 AM', '26°', Icons.wb_sunny, Colors.orange, '10%', false),
                    _buildHourlyItem('11 AM', '30°', Icons.cloudy_snowing, Colors.blueGrey, '60%', false),
                    _buildHourlyItem('1 PM', '28°', Icons.cloudy_snowing, Colors.blueGrey, '80%', true),
                    _buildHourlyItem('3 PM', '27°', Icons.cloudy_snowing, Colors.blueGrey, '40%', false),
                    _buildHourlyItem('5 PM', '26°', Icons.wb_sunny, Colors.orange, '20%', false),
                  ],
                ),

                const SizedBox(height: 24),
                // 5. At Procurement Centre
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Color(0xFF2E7D32), size: 18),
                          SizedBox(width: 8),
                          Text('At Procurement Centre', style: TextStyle(color: Color(0xFF1B3B36), fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tiruchirappalli', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.cloudy_snowing, color: Colors.blueGrey, size: 40),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('27°C', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Text('Light Rain', style: TextStyle(fontSize: 12, color: Colors.black87)),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWeatherStat('Rain Chance', '70%'),
                              const SizedBox(height: 8),
                              _buildWeatherStat('Wind', '14 km/h'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // 6. Travel Impact
                const Text('Travel Impact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildImpactCard(Icons.directions_car, Colors.green, 'Traffic', 'Normal', 'As per live data')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildImpactCard(Icons.access_time, Colors.blue, 'Travel Time', '35 min', '(12.4 km)')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildImpactCard(Icons.security, Colors.orange, 'Travel Safety', 'Caution', 'Due to rain')),
                  ],
                ),

                const SizedBox(height: 24),
                // 7. Bottom Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.navigation, size: 20),
                        SizedBox(width: 8),
                        Text('View Route & Start Journey', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 70, child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
      ],
    );
  }

  Widget _buildHourlyItem(String time, String temp, IconData icon, Color iconColor, String rainProb, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFCE4EC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isHighlighted ? Colors.pink.shade100 : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal)),
          const SizedBox(height: 8),
          Text(temp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.blue, size: 10),
              const SizedBox(width: 2),
              Text(rainProb, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(IconData icon, Color iconColor, String title, String value, String subValue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: title == 'Traffic' ? Colors.green : (title == 'Travel Safety' ? Colors.orange : Colors.indigo))),
          const SizedBox(height: 4),
          Text(subValue, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
