import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';
import '../models/booking.dart';

class TrackingScreen extends StatefulWidget {
  final AppState appState;

  const TrackingScreen({super.key, required this.appState});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Default to Active if there is an active booking, else History
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.appState.activeBooking != null ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;
    final active = widget.appState.activeBooking;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Text(AppTranslations.translate('payout_title', isTamil)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: [
            Tab(text: isTamil ? 'செயலில் உள்ளவை' : 'Active Status'),
            Tab(text: isTamil ? 'விற்பனை வரலாறு' : 'Sales History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Tab
          active == null
              ? _buildNoActiveView(isTamil)
              : _buildActiveTimeline(active, isTamil),
          
          // History Tab
          _buildHistoryList(isTamil),
        ],
      ),
    );
  }

  Widget _buildNoActiveView(bool isTamil) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 15),
            Text(
              isTamil ? 'செயலில் உள்ள கொள்முதல் ஏதும் இல்லை.' : 'No active procurement in progress.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              isTamil
                  ? 'விவரங்களை பார்க்க உங்கள் விற்பனை வரலாற்றை சரிபார்க்கவும் அல்லது புதிய முன்பதிவு செய்யவும்.'
                  : 'Check your sales history for completed payouts, or create a new booking.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTimeline(Booking active, bool isTamil) {
    final crop = Crop.getByType(active.cropType);
    
    // Timeline steps metadata
    final List<Map<String, dynamic>> steps = [
      {
        'title': AppTranslations.translate('stage_booked', isTamil),
        'descEn': 'Slot reserved at ${active.center.name}. Scheduled for ${active.dateTime.day}/${active.dateTime.month}/${active.dateTime.year}.',
        'descTa': '${active.center.nameTamil} இல் ஸ்லாட் முன்பதிவு செய்யப்பட்டுள்ளது. தேதி: ${active.dateTime.day}/${active.dateTime.month}/${active.dateTime.year}.',
        'status': BookingStatus.booked,
      },
      {
        'title': AppTranslations.translate('stage_checked_in', isTamil),
        'descEn': 'Vehicle checked in at direct purchase gate. Gate pass generated.',
        'descTa': 'நேரடி கொள்முதல் கேட்டில் வாகனம் சரிபார்க்கப்பட்டது. கேட் பாஸ் உருவாக்கப்பட்டது.',
        'status': BookingStatus.checkedIn,
      },
      {
        'title': AppTranslations.translate('stage_weighed', isTamil),
        'descEn': active.netWeight != null
            ? 'Weighment recorded. Gross: ${active.grossWeight} kg, Tare: ${active.tareWeight} kg, Net Weight: ${active.netWeight} kg.'
            : 'Vehicle on scale. Weighing in progress.',
        'descTa': active.netWeight != null
            ? 'எடை பதிவு செய்யப்பட்டது. மொத்த எடை: ${active.grossWeight} கிலோ, வண்டி எடை: ${active.tareWeight} கிலோ, நிகர எடை: ${active.netWeight} கிலோ.'
            : 'வாகனம் எடை மேடையில் உள்ளது. எடை சரிபார்ப்பு நடக்கிறது.',
        'status': BookingStatus.weighed,
      },
      {
        'title': AppTranslations.translate('stage_quality_approved', isTamil),
        'descEn': active.moistureContent != null
            ? 'Moisture: ${active.moistureContent}%, Foreign Matter: ${active.trashContent}%. Quality conforms to MSP standards.'
            : 'Crop sampling and testing in progress.',
        'descTa': active.moistureContent != null
            ? 'ஈரப்பதம்: ${active.moistureContent}%, உமி/தூசி: ${active.trashContent}%. தரம் அரசு MSP தரத்திற்கு உட்பட்டுள்ளது.'
            : 'பயிர் மாதிரி பரிசோதனை மற்றும் தரம் சரிபார்ப்பு நடக்கிறது.',
        'status': BookingStatus.qualityApproved,
      },
      {
        'title': AppTranslations.translate('stage_billing', isTamil),
        'descEn': active.payoutAmount != null
            ? 'Invoice generated. MSP Rate: ₹${crop.mspPrice}/Quintal. Purchase amount: ₹${active.payoutAmount?.toStringAsFixed(2)}.'
            : 'Calculating billing amount based on net weight and quality grades.',
        'descTa': active.payoutAmount != null
            ? 'விலைப்பட்டியல் உருவாக்கப்பட்டது. அரசு MSP: ₹${crop.mspPrice}/குவிண்டால். மொத்தத் தொகை: ₹${active.payoutAmount?.toStringAsFixed(2)}.'
            : 'நிகர எடை மற்றும் தரம் அடிப்படையில் பில் தொகை கணக்கிடப்படுகிறது.',
        'status': BookingStatus.billing,
      },
      {
        'title': AppTranslations.translate('stage_payment_initiated', isTamil),
        'descEn': active.paymentReference != null
            ? 'Direct Benefit Transfer (DBT) NEFT payout initiated. Trans Ref ID: ${active.paymentReference}.'
            : 'Payment approval received. Initiating electronic fund transfer.',
        'descTa': active.paymentReference != null
            ? 'நேரடி பலன் பரிமாற்றம் (DBT) NEFT பரிவர்த்தனை தொடங்கப்பட்டது. குறிப்பு எண்: ${active.paymentReference}.'
            : 'கட்டண ஒப்புதல் பெறப்பட்டது. மின்பரிமாற்ற வேலைகள் தொடங்கப்படுகிறது.',
        'status': BookingStatus.paymentInitiated,
      },
      {
        'title': AppTranslations.translate('stage_payment_completed', isTamil),
        'descEn': 'Payment successfully credited to the linked Aadhaar-seeded bank account.',
        'descTa': 'இணைக்கப்பட்ட ஆதார் வங்கி கணக்கில் தொகை வெற்றிகரமாக செலுத்தப்பட்டது.',
        'status': BookingStatus.paymentCompleted,
      },
    ];

    final currentIdx = active.currentStepIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Summary Card
          Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: crop.color.withOpacity(0.15),
                    radius: 24,
                    child: Icon(crop.iconData, color: crop.color, size: 26),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${isTamil ? 'டோக்கன்' : 'Token'}: ${active.tokenNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${AppTranslations.translate(crop.nameKey, isTamil)} • ${active.quantity} Qtl',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isTamil ? 'மதிப்பீடு' : 'Est. Payout',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                      Text(
                        '₹${(active.payoutAmount ?? (active.quantity * crop.mspPrice)).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5A24), fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            AppTranslations.translate('payment_timeline', isTamil),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 15),

          // Vertical timeline implementation
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, idx) {
              final step = steps[idx];
              final stepStatus = step['status'] as BookingStatus;
              
              final isCompleted = idx < currentIdx;
              final isCurrent = idx == currentIdx;
              final isPending = idx > currentIdx;

              Color lineCol = Colors.grey.shade300;
              if (idx < currentIdx) {
                lineCol = const Color(0xFF0F5A24);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side timeline circles and lines
                  Column(
                    children: [
                      // Circle indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? const Color(0xFF0F5A24)
                              : (isCurrent ? Colors.orange : Colors.white),
                          border: Border.all(
                            color: isCompleted
                                ? const Color(0xFF0F5A24)
                                : (isCurrent ? Colors.orange : Colors.grey.shade300),
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : (isCurrent
                                ? const Center(
                                    child: SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    ),
                                  )
                                : null),
                      ),
                      // Line to next step
                      if (idx < steps.length - 1)
                        Container(
                          width: 2,
                          height: 70,
                          color: lineCol,
                        ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  
                  // Step Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isPending
                                ? Colors.grey.shade500
                                : (isCurrent ? Colors.orange : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTamil ? step['descTa'] : step['descEn'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isPending ? Colors.grey.shade400 : Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        
                        // Extra detail widgets if weighs or invoice is available
                        if (isCompleted || isCurrent) ...[
                          if (stepStatus == BookingStatus.weighed && active.netWeight != null)
                            _buildWeightBreakdown(active, isTamil),
                          if (stepStatus == BookingStatus.qualityApproved && active.moistureContent != null)
                            _buildQualityBreakdown(active, crop, isTamil),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeightBreakdown(Booking active, bool isTamil) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildDetailRow(isTamil ? 'வண்டியின் மொத்த எடை:' : 'Gross Weight:', '${active.grossWeight} kg'),
          _buildDetailRow(isTamil ? 'வண்டியின் வெற்று எடை:' : 'Tare Weight:', '${active.tareWeight} kg'),
          const Divider(height: 12),
          _buildDetailRow(
            isTamil ? 'பயிரின் நிகர எடை:' : 'Net Crop Weight:',
            '${active.netWeight} kg (${active.quantity} Qtl)',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQualityBreakdown(Booking active, Crop crop, bool isTamil) {
    final moisturePass = active.moistureContent! <= crop.maxMoisture;
    final trashPass = active.trashContent! <= crop.maxTrash;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            isTamil ? 'ஈரப்பதம் அளவு:' : 'Moisture Content:',
            '${active.moistureContent}% (Max: ${crop.maxMoisture}%)',
            valueColor: moisturePass ? Colors.green.shade800 : Colors.red,
          ),
          _buildDetailRow(
            isTamil ? 'உமி/தூசு அளவு:' : 'Foreign Matter / Trash:',
            '${active.trashContent}% (Max: ${crop.maxTrash}%)',
            valueColor: trashPass ? Colors.green.shade800 : Colors.red,
          ),
          _buildDetailRow(
            isTamil ? 'கொள்முதல் தரம்:' : 'Quality Grade Rating:',
            isTamil ? 'தரம் - ஏ (சிறந்தது)' : 'Grade-A (Premium)',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // History Tab List
  Widget _buildHistoryList(bool isTamil) {
    // Filter bookings list to show only completed bookings
    final historyList = widget.appState.bookings.where((b) => b.status == BookingStatus.paymentCompleted).toList();

    if (historyList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            isTamil ? 'விற்பனை வரலாறு எதுவும் இல்லை.' : 'No completed sales transactions found.',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final b = historyList[index];
        final crop = Crop.getByType(b.cropType);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          backgroundColor: crop.color.withOpacity(0.15),
                          radius: 18,
                          child: Icon(crop.iconData, color: crop.color, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppTranslations.translate(crop.nameKey, isTamil),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Text(
                      '₹${b.payoutAmount?.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5A24), fontSize: 16),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildHistoryRow(isTamil ? 'டோக்கன் எண்:' : 'Token ID:', b.tokenNumber),
                _buildHistoryRow(isTamil ? 'நிகர எடை:' : 'Net Crop Weight:', '${b.netWeight ?? (b.quantity * 100)} kg'),
                _buildHistoryRow(isTamil ? 'கொள்முதல் மையம்:' : 'Center:', isTamil ? b.center.nameTamil : b.center.name),
                _buildHistoryRow(isTamil ? 'தேதி:' : 'Date:', '${b.dateTime.day}/${b.dateTime.month}/${b.dateTime.year}'),
                _buildHistoryRow(isTamil ? 'வங்கி கணக்கு DBT குறிப்பு:' : 'DBT Ref ID:', b.paymentReference ?? 'N/A'),
                const SizedBox(height: 10),
                
                // Print / Receipt Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Show mock receipt details dialog
                        _showReceiptDialog(context, b, crop, isTamil);
                      },
                      icon: const Icon(Icons.visibility, size: 16, color: Color(0xFF0F5A24)),
                      label: Text(
                        isTamil ? 'ரசீதை காண்க' : 'View Receipt',
                        style: const TextStyle(color: Color(0xFF0F5A24), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, Booking b, Crop crop, bool isTamil) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 45),
              const SizedBox(height: 8),
              Text(
                isTamil ? 'அரசு கொள்முதல் ரசீது' : 'Govt Procurement Receipt',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              _buildSlipRow(isTamil ? 'டோக்கன் எண்:' : 'Token ID:', b.tokenNumber),
              _buildSlipRow(isTamil ? 'விவசாயி கைபேசி:' : 'Farmer Phone:', '+91 ${widget.appState.mobileNumber}'),
              _buildSlipRow(isTamil ? 'பயிர் வகை:' : 'Crop:', AppTranslations.translate(crop.nameKey, isTamil)),
              _buildSlipRow(isTamil ? 'அளவு:' : 'Quantity:', '${b.quantity} Qtl (${b.netWeight} kg)'),
              _buildSlipRow(isTamil ? 'ஈரப்பதம்:' : 'Moisture:', '${b.moistureContent}%'),
              _buildSlipRow(isTamil ? 'உமி/தூசு:' : 'Foreign Matter:', '${b.trashContent}%'),
              _buildSlipRow(isTamil ? 'அரசு ஆதரவு விலை (MSP):' : 'MSP Rate:', '₹${crop.mspPrice}/Qtl'),
              _buildSlipRow(isTamil ? 'கொள்முதல் மையம்:' : 'Center:', isTamil ? b.center.nameTamil : b.center.name),
              _buildSlipRow(isTamil ? 'கொள்முதல் தேதி:' : 'Date:', '${b.dateTime.day}/${b.dateTime.month}/${b.dateTime.year}'),
              _buildSlipRow(isTamil ? 'DBT குறிப்பு எண்:' : 'DBT Trans Ref:', b.paymentReference ?? 'N/A'),
              const Divider(),
              _buildSlipRow(
                isTamil ? 'செலுத்தப்பட்ட தொகை:' : 'Amount Disbursed:',
                '₹${b.payoutAmount?.toStringAsFixed(2)}',
                isBold: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isTamil ? 'பதிவிறக்கம்' : 'Download PDF'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5A24)),
            child: Text(isTamil ? 'மூடு' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSlipRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF0F5A24) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
