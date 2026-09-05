import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
import '../models/booking.dart';
import 'booking_screen.dart';

class QueueScreen extends StatefulWidget {
  final AppState appState;

  const QueueScreen({super.key, required this.appState});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.appState.activeBooking != null && widget.appState.activeBooking!.queuePosition > 0) {
        widget.appState.advanceQueue();
      } else if (widget.appState.activeBooking?.queuePosition == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;
    final active = widget.appState.activeBooking;

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
            Text(isTamil ? 'மையத்திற்கு என் பயணம்' : 'My Journey to Centre', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(isTamil ? 'தொந்தரவற்ற கொள்முதலுக்கான நிகழ்நேர வழிகாட்டுதல்' : 'Real-time guidance for a hassle-free procurement', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone, size: 16, color: Color(0xFF2E7D32)),
              label: Text(isTamil ? 'உதவி' : 'Need Help?', style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E7D32)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          )
        ],
      ),
      body: active == null
          ? _buildNoBookingView(context, isTamil)
          : _buildActiveQueueView(context, active, isTamil),
    );
  }

  Widget _buildNoBookingView(BuildContext context, bool isTamil) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.query_builder, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              AppTranslations.translate('no_active_booking', isTamil),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isTamil
                  ? 'விவசாய பொருளை அரசாங்க கொள்முதல் மையத்தில் விற்க முதலில் ஒரு டெலிவரி ஸ்லாட்டை முன்பதிவு செய்யவும்.'
                  : 'To sell your crop at the government procurement center, please book a delivery slot first.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(appState: widget.appState),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(
                AppTranslations.translate('book_slot', isTamil),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A24),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveQueueView(BuildContext context, Booking active, bool isTamil) {
    final int tokenNumberInt = int.tryParse(active.tokenNumber.split('-').last) ?? 2026;
    final int servingTokenInt = tokenNumberInt - active.queuePosition;
    final String servingTokenStr = 'ABY-2026-$servingTokenInt';

    final center = active.center;
    final int waitTime = active.queuePosition * center.averageWaitTime;
    final String cropName = Crop.getByType(active.cropType).type.name;
    final double kgAmount = active.quantity * 100;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Card (Token Info)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Token', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(active.tokenNumber, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.copy, size: 16, color: Color(0xFF2E7D32)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8E6C9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${cropName[0].toUpperCase()}${cropName.substring(1)} • ${kgAmount.toInt()} kg',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    // Middle Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Now Serving', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(servingTokenStr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: active.queuePosition == 0 ? 1.0 : (1.0 - (active.queuePosition / 25.0)).clamp(0.05, 0.95),
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${active.queuePosition} tokens ahead', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    // Right Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimated Waiting Time', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 20, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text('$waitTime min', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Today at 10:30 AM (approx)', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // 2. GET READY Banner
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  border: Border.all(color: Colors.amber.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time_filled, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('GET READY', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Please get ready to start your journey in about $waitTime minutes.', style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_active_outlined, size: 16),
                      label: const Text('Set Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade50,
                        foregroundColor: Colors.orange.shade900,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // 3. Weather & Travel Conditions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Weather & Travel Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                  Row(
                    children: [
                      Text('Updated 10:15 AM', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 4),
                      Icon(Icons.refresh, size: 14, color: Colors.grey.shade600),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 150, child: _buildConditionCard(Icons.cloud_queue, Colors.orange, '28°C', 'Partly Cloudy', 'Rain Chance: 20%')),
                    const SizedBox(width: 12),
                    SizedBox(width: 150, child: _buildConditionCard(Icons.water_drop, Colors.blue, 'No heavy rain', 'on route', 'Safe to travel', true)),
                    const SizedBox(width: 12),
                    SizedBox(width: 150, child: _buildConditionCard(Icons.directions_car, Colors.green, 'Traffic', 'Normal', '(As per live data)', false, true)),
                    const SizedBox(width: 12),
                    SizedBox(width: 150, child: _buildConditionCard(Icons.air, Colors.blueAccent, 'Good', 'travel conditions', 'Wind: 12 km/h')),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // 4. Your Route to Procurement Centre
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF1B3B36), size: 20),
                      SizedBox(width: 8),
                      Text('Your Route to Procurement Centre', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('View in Maps'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: const MapOptions(
                              initialCenter: LatLng(10.8050, 78.6856),
                              initialZoom: 13.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: const [
                                      LatLng(10.8050, 78.6856),
                                      LatLng(10.8120, 78.6920),
                                      LatLng(10.8200, 78.7000),
                                    ],
                                    color: Colors.blue,
                                    strokeWidth: 5.0,
                                  ),
                                ],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: const LatLng(10.8050, 78.6856),
                                    width: 140,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Your Location', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                              Text('(Thiruporur)', style: TextStyle(fontSize: 9, color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.circle, color: Colors.blue, size: 16),
                                      ],
                                    ),
                                  ),
                                  Marker(
                                    point: const LatLng(10.8200, 78.7000),
                                    width: 140,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.red, size: 24),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Procurement Centre', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                              Text('(Tiruchirappalli)', style: TextStyle(fontSize: 9, color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Overlay distance badge
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200, width: 2),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('35 min', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('12.4 km', style: TextStyle(color: Colors.blue, fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.route, color: Color(0xFF1B3B36), size: 24),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Distance', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('12.4 km', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Container(width: 1, height: 40, color: Colors.grey.shade200),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Color(0xFF1B3B36), size: 24),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Estimated Travel Time', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('35 min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Container(width: 1, height: 40, color: Colors.grey.shade200),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.directions_car, color: Color(0xFF1B3B36), size: 24),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Traffic Status', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('Normal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.navigation),
                                label: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start Journey', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Get live navigation', style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F5A24),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // 5. Journey Updates
              const Row(
                children: [
                  Icon(Icons.timeline, color: Color(0xFF1B3B36), size: 20),
                  SizedBox(width: 8),
                  Text('Journey Updates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTimelineStep('Preparing', 'You have marked that you are preparing for the journey.', '08:20 AM', 'Edit', Icons.edit, true, true),
                    _buildTimelineStep('Started Journey', 'Your journey has been started. Safe travels!', '08:55 AM', 'Edit', Icons.edit, true, false, isCurrent: true),
                    _buildTimelineStep('Arrived at Centre', 'Mark when you reach the procurement centre.', '-', 'Mark Arrived', Icons.location_on, false, false),
                    _buildTimelineStep('Checked In', 'Token verification at centre.', '-', 'Mark Checked In', Icons.qr_code_scanner, false, false, isDisabledButton: true),
                    _buildTimelineStep('Handover Completed', 'Grain handover done successfully.', '-', 'View Details', Icons.description, false, false, isLast: true, isDisabledButton: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Footer Banner
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: Color(0xFF2E7D32), size: 36),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Have a safe journey!', style: TextStyle(color: Color(0xFF1B3B36), fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('We are with you from your field to payment.', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 13)),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.eco, color: Color(0xFF2E7D32), size: 24),
                        SizedBox(height: 4),
                        Text('Farmers\' Prosperity', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 11, fontWeight: FontWeight.w600)),
                        Text('Our Priority', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionCard(IconData icon, Color iconColor, String title, String subtitle1, String subtitle2, [bool isSafe = false, bool isTraffic = false]) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isTraffic ? Colors.green : Colors.black87)),
                Text(subtitle1, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                isSafe 
                  ? Row(children: [const Icon(Icons.check_circle, size: 12, color: Colors.green), const SizedBox(width: 4), Expanded(child: Text(subtitle2, style: TextStyle(fontSize: 10, color: Colors.green)))])
                  : Text(subtitle2, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String desc, String time, String btnText, IconData btnIcon, bool isCompleted, bool isFirst, {bool isCurrent = false, bool isLast = false, bool isDisabledButton = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? const Color(0xFF2E7D32) : (isCurrent ? const Color(0xFF2E7D32) : Colors.grey.shade300),
                  ),
                  child: Center(
                    child: isCompleted 
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : (isCurrent ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)) : null),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: isCompleted || isCurrent ? const Color(0xFF1B3B36) : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (time != '-') Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      if (time != '-') const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isDisabledButton ? null : () {},
                        icon: Icon(btnIcon, size: 14),
                        label: Text(btnText, style: const TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDisabledButton ? Colors.grey : const Color(0xFF2E7D32),
                          side: BorderSide(color: isDisabledButton ? Colors.grey.shade300 : const Color(0xFF2E7D32)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
