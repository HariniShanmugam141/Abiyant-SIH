import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
import '../models/booking.dart';
import 'booking_screen.dart';

class QueueScreen extends StatelessWidget {
  final AppState appState;

  const QueueScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isTamil = appState.isTamil;
    final active = appState.activeBooking;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Text(AppTranslations.translate('queue_title', isTamil)),
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
                    builder: (context) => BookingScreen(appState: appState),
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
    // Generate simulated active token in processing (a few tokens behind)
    final int tokenNumberInt = int.tryParse(active.tokenNumber.split('-').last) ?? 2026;
    final int servingTokenInt = tokenNumberInt - active.queuePosition;
    final String servingTokenStr = 'ABY-2026-$servingTokenInt';

    final crop = Crop.getByType(active.cropType);
    final center = active.center;
    final int waitTime = active.queuePosition * center.averageWaitTime;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center Header Details
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          backgroundColor: const Color(0xFFE8F5E9),
                          label: Text(
                            AppTranslations.translate(crop.nameKey, isTamil),
                            style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${active.quantity} Qtl',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isTamil ? center.nameTamil : center.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F5A24)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isTamil ? center.locationTamil : center.location,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Live Queue Visual Board
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Queue stats grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQueueStat(
                          isTamil ? 'தற்போதைய டோக்கன்' : 'Serving Token',
                          active.queuePosition == 0 ? active.tokenNumber : servingTokenStr,
                          Colors.green,
                        ),
                        Container(width: 1, height: 40, color: Colors.grey.shade300),
                        _buildQueueStat(
                          AppTranslations.translate('your_position', isTamil),
                          active.status == BookingStatus.booked
                              ? '#${active.queuePosition}'
                              : (isTamil ? 'அடைந்தது' : 'Arrived'),
                          active.queuePosition == 0 ? Colors.green : Colors.redAccent,
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    // Expected wait time card
                    if (active.status == BookingStatus.booked && active.queuePosition > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.hourglass_bottom, color: Colors.orange),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.translate('est_wait_time', isTamil),
                                  style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                                ),
                                Text(
                                  '$waitTime ${AppTranslations.translate('minutes', isTamil)} (${isTamil ? 'தோராயமாக' : 'approx.'})',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Interactive Lineup Visualizer
                    Text(
                      isTamil ? 'நேரடி வாகன வரிசை பட்டியல்' : 'Live Vehicle Lineup',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    _buildLineupGraphic(active),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Help section & Cancel details
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTamil ? 'வழிகாட்டுதல்கள் & உதவி' : 'Directions & Help',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    
                    // Conditionally show status info
                    if (active.status == BookingStatus.booked) ...[
                      _buildGuidelineItem(
                        Icons.info_outline,
                        isTamil
                            ? 'நுழைவுச் வாயிலில் உள்ள ஆபரேட்டருக்கு உங்கள் டோக்கன் எண்ணைக் காட்டி கேட் பாஸைப் பெறவும்.'
                            : 'Show your Token QR to the gate operator to generate a Gate Entry Pass.',
                      ),
                      _buildGuidelineItem(
                        Icons.timer,
                        isTamil
                            ? 'தாமதத்தைத் தவிர்க்க உங்களின் முன்பதிவு நேரத்திற்கு 15 நிமிடங்கள் முன்னதாகவே மையத்தை அடையவும்.'
                            : 'Arrive 15 minutes before your scheduled window to prevent slot expiration.',
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(isTamil ? 'முன்பதிவை ரத்து செய்கிறீர்களா?' : 'Cancel Booking?'),
                                content: Text(
                                  isTamil
                                      ? 'இந்த முன்பதிவை நீங்கள் நிச்சயமாக ரத்து செய்ய விரும்புகிறீர்களா?'
                                      : 'Are you sure you want to cancel this procurement slot?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(isTamil ? 'இல்லை' : 'No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      appState.cancelActiveBooking();
                                      Navigator.pop(context); // close dialog
                                      Navigator.pop(context); // close screen
                                    },
                                    child: Text(
                                      isTamil ? 'ஆம், ரத்து செய்' : 'Yes, Cancel',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            isTamil ? 'முன்பதிவை ரத்துசெய்' : 'Cancel Booking Slot',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildGuidelineItem(
                        Icons.check_circle_outline,
                        isTamil
                            ? 'நீங்கள் செக்-இன் செய்துவிட்டீர்கள். உங்கள் வாகனத்தை எடை மேடைக்கு கொண்டு செல்லவும்.'
                            : 'Checked in! Drive your vehicle onto the weighbridge scale now.',
                      ),
                      _buildGuidelineItem(
                        Icons.bar_chart,
                        isTamil
                            ? 'எடை சரிபார்ப்புக்குப் பிறகு, தரம் சரிபார்க்கும் ஆய்வக பகுதிக்குச் செல்லவும்.'
                            : 'After weight is recorded, wait at the quality checking bay for inspection.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Demo notice for SIH judges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Card(
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.amber.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isTamil
                              ? 'டெமோ குறிப்பு: வரிசையை நகர்த்தி நேரடி மாற்றத்தை பார்க்க "டெமோ சிமுலேட்டர்" சென்று "வரிசையை நகர்த்து" கிளிக் செய்யவும்.'
                              : 'Demo Tip: Go to the "Demo Simulator" from home and click "Advance Queue" to see vehicles move up in real time.',
                          style: TextStyle(fontSize: 10, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F5A24), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // Visual graph representation of queue line
  Widget _buildLineupGraphic(Booking active) {
    final int queuePos = active.queuePosition;
    final isArrived = active.status != BookingStatus.booked;

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: isArrived ? 3 : (queuePos > 5 ? 6 : queuePos + 2),
        itemBuilder: (context, index) {
          final isWeighBridge = index == 0;
          final isUserVehicle = isArrived ? (index == 1) : (index == (queuePos > 5 ? 5 : queuePos + 1));
          
          Color cardColor = Colors.grey.shade100;
          Color borderClr = Colors.grey.shade300;
          String label = 'Vehicle';
          IconData icon = Icons.local_shipping;

          if (isWeighBridge) {
            cardColor = Colors.green.shade50;
            borderClr = Colors.green;
            label = appState.isTamil ? 'எடை மேடை' : 'Scale';
            icon = Icons.scale;
          } else if (isUserVehicle) {
            cardColor = Colors.orange.shade50;
            borderClr = Colors.orange;
            label = appState.isTamil ? 'நீங்கள்' : 'YOU';
            icon = Icons.local_shipping;
          } else {
            label = '#${active.queuePosition - (index - 1)}';
          }

          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: borderClr, width: isUserVehicle || isWeighBridge ? 2 : 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isUserVehicle
                      ? Colors.orange
                      : (isWeighBridge ? Colors.green : Colors.grey.shade600),
                  size: 26,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isUserVehicle || isWeighBridge ? FontWeight.bold : FontWeight.normal,
                    color: isUserVehicle
                        ? Colors.orange.shade900
                        : (isWeighBridge ? Colors.green.shade900 : Colors.black87),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isWeighBridge && !isUserVehicle)
                  Text(
                    'Token',
                    style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
