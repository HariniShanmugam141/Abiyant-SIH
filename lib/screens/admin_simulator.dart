import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/booking.dart';
import '../models/crop.dart';
import '../utils/translations.dart';

class AdminSimulatorScreen extends StatelessWidget {
  final AppState appState;

  const AdminSimulatorScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final active = appState.activeBooking;
    final isTamil = appState.isTamil;

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F), // Red header to indicate it is a Developer/Demo tool
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.developer_mode),
            const SizedBox(width: 10),
            Text(isTamil ? 'அபியந்த் டெமோ சிமுலேட்டர்' : 'Abhiyant Demo Simulator'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Alert
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.blue.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue.shade800),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HACKATHON DEMO UTILITY',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 11),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Use this screen to mock real-time events that would normally happen at the procurement center (gate entries, weighbridge data, quality labs, bank updates). This lets you demonstrate the app\'s live responsiveness to the judges.',
                            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Active token details
            Text(
              isTamil ? 'செயலில் உள்ள டோக்கன் விவரங்கள்' : 'Active Token Details',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            active == null
                ? _buildNoActiveCard(isTamil)
                : _buildActiveBookingCard(active, isTamil),
            
            const SizedBox(height: 20),

            // Simulation Controls (enabled only if there is an active booking)
            Text(
              isTamil ? 'சிமுலேட்டர் கட்டுப்பாடுகள்' : 'Simulation Controls',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            _buildControlsCard(context, active, isTamil),

            const SizedBox(height: 20),

            // General alerts simulator
            Text(
              isTamil ? 'பொதுவான அறிவிப்பு சிமுலேஷன்' : 'General Notifications Simulation',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            _buildGeneralAlertsCard(isTamil),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActiveCard(bool isTamil) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.warning_amber_rounded, size: 40, color: Colors.orange.shade700),
              const SizedBox(height: 10),
              Text(
                isTamil
                    ? 'செயலில் உள்ள முன்பதிவு எதுவும் இல்லை!'
                    : 'No active booking found!',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                isTamil
                    ? 'சிமுலேட்டரை சோதிக்க, முதலில் முகப்புப் பக்கத்தில் இருந்து ஒரு ஸ்லாட்டை முன்பதிவு செய்யவும்.'
                    : 'To test the simulation, please book a procurement slot first from the dashboard.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveBookingCard(Booking active, bool isTamil) {
    final crop = Crop.getByType(active.cropType);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      backgroundColor: crop.color.withOpacity(0.15),
                      radius: 20,
                      child: Icon(crop.iconData, color: crop.color),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.translate(crop.nameKey, isTamil),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow(
              isTamil ? 'தற்போதைய நிலை:' : 'Current Status:',
              _getStepName(active.status, isTamil).toUpperCase(),
              valueColor: Colors.redAccent,
              isBold: true,
            ),
            _buildDetailRow(
              isTamil ? 'வரிசையில் வாகனங்கள்:' : 'Vehicles in Front:',
              active.queuePosition > 0 ? '${active.queuePosition} vehicles' : 'Arrived/Finished',
            ),
            _buildDetailRow(
              isTamil ? 'தேர்வு செய்த மையம்:' : 'Procurement Center:',
              isTamil ? active.center.nameTamil : active.center.name,
            ),
            if (active.netWeight != null)
              _buildDetailRow(
                isTamil ? 'பதிவு செய்யப்பட்ட நிகர எடை:' : 'Recorded Net Weight:',
                '${active.netWeight} kg',
              ),
            if (active.payoutAmount != null)
              _buildDetailRow(
                isTamil ? 'பில் தொகை (MSP):' : 'Invoice Total (MSP):',
                '₹${active.payoutAmount?.toStringAsFixed(2)}',
                valueColor: const Color(0xFF0F5A24),
                isBold: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsCard(BuildContext context, Booking? active, bool isTamil) {
    final activeVal = active;
    final bool isEnabled = activeVal != null;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Advance queue button
            ListTile(
              enabled: isEnabled && activeVal.queuePosition > 0,
              leading: Icon(
                Icons.skip_next,
                color: (isEnabled && activeVal.queuePosition > 0) ? Colors.orange : Colors.grey,
              ),
              title: Text(isTamil ? 'வரிசையை நகர்த்தவும்' : 'Advance Queue Position'),
              subtitle: Text(
                isTamil
                    ? 'வரிசையில் உள்ள வாகனத்தை 1 இடம் குறைக்கவும் (கேட் அடைந்தவுடன் செக்-இன் ஆகும்).'
                    : 'Reduce the queue position by 1. Automatically checks in vehicle when position is 0.',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: ElevatedButton(
                onPressed: (isEnabled && activeVal.queuePosition > 0)
                    ? () {
                        appState.advanceQueue();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isTamil
                                  ? 'வண்டி வரிசை முன்னோக்கி நகர்த்தப்பட்டது!'
                                  : 'Queue advanced! Vehicle moved up.',
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: Text(isTamil ? 'இயக்கு' : 'Trigger'),
              ),
            ),
            const Divider(),

            // Advance procurement step
            ListTile(
              enabled: isEnabled && activeVal.status != BookingStatus.paymentCompleted,
              leading: Icon(
                Icons.forward,
                color: (isEnabled && activeVal.status != BookingStatus.paymentCompleted)
                    ? const Color(0xFF0F5A24)
                    : Colors.grey,
              ),
              title: Text(isTamil ? 'அடுத்த கட்டத்திற்கு கொண்டுசெல்' : 'Advance Procurement Stage'),
              subtitle: Text(
                isTamil
                    ? 'கொள்முதல் நிலைகளை அடுத்த கட்டத்திற்கு கொண்டு செல்லவும் (எடை → தரம் → பில் → DBT).'
                    : 'Move the booking through the government procurement workflow step-by-step.',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: ElevatedButton(
                onPressed: (isEnabled && activeVal.status != BookingStatus.paymentCompleted)
                    ? () {
                        appState.advancePaymentStep();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isTamil
                                  ? 'கொள்முதல் நிலை புதுப்பிக்கப்பட்டது!'
                                  : 'Procurement status progressed successfully!',
                            ),
                            backgroundColor: const Color(0xFF0F5A24),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5A24), foregroundColor: Colors.white),
                child: Text(isTamil ? 'இயக்கு' : 'Trigger'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralAlertsCard(bool isTamil) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.amber),
              title: Text(isTamil ? 'மழை/காலநிலை எச்சரிக்கை' : 'Weather/Rain Warning'),
              subtitle: Text(
                isTamil
                    ? 'கொள்முதல் மையத்தில் பயிர்கள் நனையாமல் காக்க தார்பாலின் கொண்டுவர விவசாயிகளுக்கு எச்சரித்தல்.'
                    : 'Send crop protection warning alerts to farmers due to sudden rain predictions.',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  appState.addNotification(
                    'Weather alert: Rain predicted near Trichy. Farmers are advised to cover crop trucks with tarpaulin covers.',
                    'வானிலை எச்சரிக்கை: திருச்சிக்கு அருகில் மழை பெய்ய வாய்ப்புள்ளது. விவசாயிகள் விளைபொருட்களை தார்பாலின் போட்டு மூடி கொண்டுவருமாறு அறிவுறுத்தப்படுகிறார்கள்.',
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
                child: Text(isTamil ? 'அனுப்பு' : 'Send Alert'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.build, color: Colors.blueGrey),
              title: Text(isTamil ? 'மைய இயந்திர பழுது/தாமதம்' : 'Center Machine Breakdown'),
              subtitle: Text(
                isTamil
                    ? 'எடை போடும் இயந்திர பழுது காரணமாக கோயம்புத்தூர் கொள்முதல் மையத்தில் தாமதம் ஏற்படும் என எச்சரித்தல்.'
                    : 'Notify farmers booking in Coimbatore about delays due to scale machine maintenance.',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  appState.addNotification(
                    'Delay Alert: Technical maintenance on weighing scale at Coimbatore center. Wait times increased by 45 mins.',
                    'தாமத அறிவிப்பு: கோயம்புத்தூர் மையத்தில் எடை இயந்திர பழுதுபார்ப்புப் பணி நடக்கிறது. காத்திருப்பு நேரம் 45 நிமிடங்கள் அதிகரிக்கலாம்.',
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                child: Text(isTamil ? 'அனுப்பு' : 'Send Alert'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
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
