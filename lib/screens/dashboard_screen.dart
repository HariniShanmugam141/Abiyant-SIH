import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
import '../models/booking.dart';
import 'booking_screen.dart';
import 'queue_screen.dart';
import 'tracking_screen.dart';
import 'msp_info_screen.dart';
import 'notifications_screen.dart';
import 'admin_simulator.dart';

class DashboardScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isTamil = appState.isTamil;
    final active = appState.activeBooking;

    // Calculate total sold (sum of netWeight or quantity for completed / historical bookings)
    double totalQuantitySold = 0.0;
    double pendingAmount = 0.0;

    for (var b in appState.bookings) {
      if (b.status == BookingStatus.paymentCompleted) {
        totalQuantitySold += b.quantity;
      } else {
        // If not paid yet, but weight is recorded or billing is done, count it
        if (b.payoutAmount != null) {
          pendingAmount += b.payoutAmount!;
        } else {
          // Estimate payout based on crop price
          final crop = Crop.getByType(b.cropType);
          pendingAmount += b.quantity * crop.mspPrice;
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.agriculture, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.translate('app_name', isTamil),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
                Text(
                  isTamil ? 'விவசாயி போர்டல்' : 'Farmer Procurement Portal',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Language Quick Toggle
          IconButton(
            icon: Icon(isTamil ? Icons.translate : Icons.g_translate, color: Colors.white70),
            onPressed: () {
              appState.setLanguage(!isTamil);
            },
            tooltip: 'Toggle Language / மொழியை மாற்றவும்',
          ),
          
          // Notifications Bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(appState: appState),
                    ),
                  );
                },
              ),
              if (appState.unreadNotificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${appState.unreadNotificationCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          
          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: isTamil ? 'வெளியேறு' : 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0F5A24).withOpacity(0.1),
                        radius: 28,
                        child: const Icon(Icons.person, color: Color(0xFF0F5A24), size: 32),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.translate('welcome', isTamil),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${isTamil ? 'அலைபேசி' : 'Phone'}: +91 ${appState.mobileNumber}',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        backgroundColor: const Color(0xFFE8F5E9),
                        label: Text(
                          isTamil ? 'சரிபார்க்கப்பட்டது' : 'Verified',
                          style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      title: AppTranslations.translate('active_token', isTamil),
                      value: active != null ? active.tokenNumber : (isTamil ? 'இல்லை' : 'None'),
                      icon: Icons.confirmation_number,
                      color: active != null ? Colors.orange : Colors.grey,
                      onTap: active != null
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QueueScreen(appState: appState),
                                ),
                              )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      title: AppTranslations.translate('pending_payout', isTamil),
                      value: '₹${pendingAmount.toStringAsFixed(0)}',
                      icon: Icons.account_balance_wallet,
                      color: pendingAmount > 0 ? const Color(0xFF2E7D32) : Colors.grey,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingScreen(appState: appState),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      title: isTamil ? 'விற்பனை' : 'Total Sold',
                      value: '${totalQuantitySold.toStringAsFixed(1)} Qtl',
                      icon: Icons.shopping_basket,
                      color: Colors.blueGrey,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingScreen(appState: appState),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Active booking warning / tracking quick card
              if (active != null) ...[
                Text(
                  isTamil ? 'தற்போதைய முன்பதிவு நிலை' : 'Active Procurement Status',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.orangeAccent, width: 1.5),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Crop.getByType(active.cropType).color.withOpacity(0.15),
                                  radius: 20,
                                  child: Icon(
                                    Crop.getByType(active.cropType).iconData,
                                    color: Crop.getByType(active.cropType).color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTranslations.translate(Crop.getByType(active.cropType).nameKey, isTamil),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${active.quantity} Quintals',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange.shade300),
                              ),
                              child: Text(
                                active.tokenNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        
                        // Active Step Status Indicator
                        Row(
                          children: [
                            const Icon(Icons.watch_later_outlined, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isTamil ? 'தற்போதைய நிலை:' : 'Current Step:',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    _getStepName(active.status, isTamil),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            if (active.queuePosition > 0 && active.status == BookingStatus.booked) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    isTamil ? 'வரிசை எண்:' : 'Queue Position:',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    '#${active.queuePosition}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QueueScreen(appState: appState),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.my_location, size: 18),
                                label: Text(
                                  AppTranslations.translate('live_queue', isTamil),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0F5A24),
                                  side: const BorderSide(color: Color(0xFF0F5A24)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackingScreen(appState: appState),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.receipt_long, size: 18),
                                label: Text(
                                  isTamil ? 'காலவரிசை' : 'Track Details',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F5A24),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Grid Menu
              Text(
                isTamil ? 'மெனு சேவைகள்' : 'Services Menu',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
                children: [
                  _buildMenuCard(
                    title: AppTranslations.translate('book_slot', isTamil),
                    subtitle: isTamil ? 'புதிய முன்பதிவு செய்ய' : 'Reserve a delivery slot',
                    icon: Icons.calendar_month,
                    color: Colors.teal.shade700,
                    onTap: () {
                      if (active != null) {
                        // Alert user that they already have an active booking
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(isTamil ? 'முன்பதிவு உள்ளது' : 'Active Booking Exists'),
                            content: Text(
                              isTamil
                                  ? 'உங்களிடம் ஏற்கனவே ஒரு முன்பதிவு செயலில் உள்ளது. மற்றொரு முன்பதிவு செய்ய தற்போதைய முன்பதிவை முடிக்கவும் அல்லது ரத்து செய்யவும்.'
                                  : 'You already have an active booking. Please complete or cancel it before reserving another slot.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(isTamil ? 'சரி' : 'OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(appState: appState),
                          ),
                        );
                      }
                    },
                  ),
                  _buildMenuCard(
                    title: AppTranslations.translate('live_queue', isTamil),
                    subtitle: isTamil ? 'நேரடி காத்திருப்பு நிலை' : 'Check waiting queues',
                    icon: Icons.people_outline,
                    color: Colors.blue.shade800,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueueScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: AppTranslations.translate('track_payout', isTamil),
                    subtitle: isTamil ? 'பணம் பெற்ற நிலை' : 'Weights & DBT payouts',
                    icon: Icons.currency_rupee,
                    color: Colors.purple.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: AppTranslations.translate('msp_rates', isTamil),
                    subtitle: isTamil ? 'அரசு கொள்முதல் விலை' : 'Government crop prices',
                    icon: Icons.info_outline,
                    color: Colors.orange.shade800,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MspInfoScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: AppTranslations.translate('notifications', isTamil),
                    subtitle: isTamil ? 'அறிவிப்புகள்' : 'SMS & system alerts',
                    icon: Icons.notifications_none,
                    color: Colors.indigo.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  
                  // Hackathon Simulator Card
                  _buildMenuCard(
                    title: AppTranslations.translate('admin_sim', isTamil),
                    subtitle: isTamil ? 'டெமோ சிமுலேட்டர்' : 'Simulate state updates',
                    icon: Icons.developer_mode,
                    color: const Color(0xFFD32F2F), // Bright red for attention
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminSimulatorScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Bottom Footer
              const Center(
                child: Column(
                  children: [
                    Text(
                      'SMART INDIA HACKATHON 2026 - PROBLEM ID 26032',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Developed by Team Abhiyant for Ministry of Consumer Affairs',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepName(BookingStatus status, bool isTamil) {
    switch (status) {
      case BookingStatus.booked:
        return AppTranslations.translate('stage_booked', isTamil);
      case BookingStatus.checkedIn:
        return AppTranslations.translate('stage_checked_in', isTamil);
      case BookingStatus.weighed:
        return AppTranslations.translate('stage_weighed', isTamil);
      case BookingStatus.qualityApproved:
        return AppTranslations.translate('stage_quality_approved', isTamil);
      case BookingStatus.billing:
        return AppTranslations.translate('stage_billing', isTamil);
      case BookingStatus.paymentInitiated:
        return AppTranslations.translate('stage_payment_initiated', isTamil);
      case BookingStatus.paymentCompleted:
        return AppTranslations.translate('stage_payment_completed', isTamil);
    }
  }
}
