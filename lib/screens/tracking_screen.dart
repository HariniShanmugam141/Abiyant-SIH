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
            const Text('Procurement & Payout Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3B36))),
            Text('Track your grain from centre to payment', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.headset_mic, size: 16, color: Color(0xFF1B3B36)),
              label: const Text('Help', style: TextStyle(color: Color(0xFF1B3B36), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1B5E20),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFF1B5E20),
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.eco),
                      SizedBox(width: 8),
                      Text('Active Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart),
                      SizedBox(width: 8),
                      Text('Sales History', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          active == null ? _buildNoActiveView() : _buildActiveTimelineView(active),
          _buildSalesHistoryView(),
        ],
      ),
    );
  }

  Widget _buildNoActiveView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 15),
          const Text('No active procurement in progress.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildActiveTimelineView(Booking active) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.spa, color: Color(0xFF2E7D32), size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Token: ${active.tokenNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                          const SizedBox(height: 4),
                          Text('Cotton • 12 Quintals', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('Procurement Centre: Trichy APMC', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Expected Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Text('₹85,452.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1B5E20))),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Color(0xFF1B5E20)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Updated: 23 Aug 2026, 10:30 AM', style: TextStyle(color: Colors.grey.shade600, fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Procurement Timeline Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.eco, color: Color(0xFF1B5E20), size: 20),
                      SizedBox(width: 8),
                      Text('Procurement Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.sensors, size: 12, color: Color(0xFF1B5E20)),
                        SizedBox(width: 4),
                        Text('Live Updates', style: TextStyle(color: Color(0xFF1B5E20), fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Timeline Steps
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      status: 'Completed',
                      title: 'Slot Booked',
                      icon: Icons.calendar_today,
                      time: '01 Sep 2026, 09:15 AM',
                      desc: 'Slot reserved at Trichy APMC Market Yard.\nScheduled for 01 Sep 2026.',
                      isFirst: true,
                    ),
                    _buildTimelineStep(
                      status: 'Completed',
                      title: 'Arrived at Centre',
                      icon: Icons.location_on_outlined,
                      time: '01 Sep 2026, 09:50 AM',
                      desc: 'Vehicle checked in at direct purchase gate.\nGate pass generated.',
                    ),
                    _buildTimelineStep(
                      status: 'Completed',
                      title: 'Crop Weighed',
                      icon: Icons.scale,
                      time: '01 Sep 2026, 10:20 AM',
                      desc: 'Weightment recorded.',
                      innerCard: _buildWeightCard(),
                    ),
                    _buildTimelineStep(
                      status: 'Completed',
                      title: 'Quality Inspected',
                      icon: Icons.science_outlined,
                      time: '01 Sep 2026, 11:00 AM',
                      desc: 'Moisture: 11.2% | Foreign Matter: 3.1%\nQuality conforms to MSP standards.',
                      innerCard: _buildQualityCard(),
                    ),
                    _buildTimelineStep(
                      status: 'In Progress',
                      title: 'Invoice Generated',
                      icon: Icons.receipt_long,
                      time: '01 Sep 2026, 11:30 AM',
                      desc: 'Invoice generated. MSP Rate: ₹7121 / Quintal.\nPurchase amount: ₹85,452.00',
                    ),
                    _buildTimelineStep(
                      status: 'Pending',
                      title: 'DBT Payment Initiated',
                      icon: Icons.account_balance,
                      time: '',
                      desc: 'Payment approval received.\nInitiating electronic fund transfer.',
                    ),
                    _buildTimelineStep(
                      status: 'Pending',
                      title: 'Payment Disbursed (Direct Benefit Transfer)',
                      icon: Icons.currency_rupee,
                      time: '',
                      desc: 'Payment will be credited to your linked Aadhaar-seeded bank account.',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 140, child: _buildActionButton(Icons.download, 'Download Invoice', const Color(0xFF2E7D32))),
                    const SizedBox(width: 12),
                    SizedBox(width: 140, child: _buildActionButton(Icons.receipt, 'View Weight Slip', const Color(0xFF2E7D32))),
                    const SizedBox(width: 12),
                    SizedBox(width: 140, child: _buildActionButton(Icons.error_outline, 'Raise an Issue', Colors.red)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: Color(0xFF2E7D32), size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Your produce is in safe hands!', style: TextStyle(color: Color(0xFF1B3B36), fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Transparent process • Fair prices • Direct payment', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 13)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(Icons.eco, color: Color(0xFF2E7D32), size: 24),
                        SizedBox(height: 4),
                        Text('Farmers\' Prosperity', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 11, fontWeight: FontWeight.w600)),
                        Text('Our Priority', style: TextStyle(color: Color(0xFF1B3B36), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String status,
    required String title,
    required IconData icon,
    required String time,
    required String desc,
    Widget? innerCard,
    bool isFirst = false,
    bool isLast = false,
  }) {
    Color nodeColor;
    Color lineColor;
    Widget nodeChild;
    Color titleColor = const Color(0xFF1B3B36);
    
    if (status == 'Completed') {
      nodeColor = const Color(0xFF1B5E20);
      lineColor = const Color(0xFF1B5E20);
      nodeChild = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (status == 'In Progress') {
      nodeColor = Colors.white;
      lineColor = Colors.grey.shade300;
      nodeChild = Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.orange, width: 3)),
      );
      titleColor = Colors.orange.shade800;
    } else {
      nodeColor = Colors.white;
      lineColor = Colors.grey.shade300;
      nodeChild = Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 3)),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Line & Node
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                  ),
                  child: nodeChild,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 20, color: const Color(0xFF1B3B36)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor)),
                            const SizedBox(height: 4),
                            Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (time.isNotEmpty) Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          const SizedBox(height: 8),
                          _buildStatusBadge(status),
                        ],
                      ),
                    ],
                  ),
                  if (innerCard != null) ...[
                    const SizedBox(height: 12),
                    innerCard,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    if (status == 'Completed') {
      bg = const Color(0xFFE8F5E9);
      fg = const Color(0xFF1B5E20);
    } else if (status == 'In Progress') {
      bg = const Color(0xFFFFF3E0);
      fg = Colors.orange.shade800;
    } else {
      bg = Colors.grey.shade100;
      fg = Colors.grey.shade600;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeightCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(child: _buildInnerStat('Gross Weight', '2,700 kg')),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 8.0), child: _buildInnerStat('Tare Weight', '1,500 kg'))),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 8.0), child: _buildInnerStat('Net Crop Weight', '1,200 kg\n(12 Qtl)', true))),
        ],
      ),
    );
  }

  Widget _buildQualityCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildInnerStat('Moisture Content', '11.2%\n(Max: 12%)', false, const Color(0xFF1B5E20))),
          Container(width: 1, height: 30, color: const Color(0xFFC8E6C9)),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 8.0), child: _buildInnerStat('Foreign Matter / Trash', '3.1%\n(Max: 4%)', false, const Color(0xFF1B5E20)))),
          Container(width: 1, height: 30, color: const Color(0xFFC8E6C9)),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 8.0), child: _buildInnerStat('Quality Grade', 'Grade A\n(Premium)', true, const Color(0xFF1B5E20)))),
        ],
      ),
    );
  }

  Widget _buildInnerStat(String label, String value, [bool isBold = false, Color? valueColor]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: valueColor ?? Colors.black87)),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSalesHistoryView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bar_chart, color: Color(0xFF1B5E20)),
                      SizedBox(width: 8),
                      Text('Your Sales Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_today, size: 14, color: Colors.black87),
                        SizedBox(width: 6),
                        Text('All Time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Summary Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSummaryCard(Icons.shopping_bag, const Color(0xFF1B5E20), 'Total Procurements', '8', '(All Seasons)'),
                    const SizedBox(width: 12),
                    _buildSummaryCard(Icons.grass, const Color(0xFF388E3C), 'Total Quantity', '52.4', 'Quintals', true),
                    const SizedBox(width: 12),
                    _buildSummaryCard(Icons.payments, Colors.amber.shade700, 'Total Earnings', '₹3,72,850', ''),
                    const SizedBox(width: 12),
                    _buildSummaryCard(Icons.check_circle, const Color(0xFF1B5E20), 'Payments Received', '7 / 8', '(1 Pending)'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Sales History Header & Search
              Row(
                children: [
                  const Icon(Icons.history, color: Color(0xFF1B5E20)),
                  const SizedBox(width: 8),
                  const Text('Sales History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
                  const Spacer(),
                  Container(
                    width: 200,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Search by crop, token or centre...', style: TextStyle(fontSize: 10, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, size: 20, color: Color(0xFF1B5E20)),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Filters Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    _buildFilterChip('Paddy', false, Icons.spa),
                    _buildFilterChip('Maize', false, Icons.eco),
                    _buildFilterChip('Cotton', false, Icons.filter_vintage),
                    _buildFilterChip('Groundnut', false, Icons.circle),
                    _buildFilterChip('Sugarcane', false, Icons.grass),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: const [
                          Text('Year', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              
              // Sales List
              _buildHistoryCard('Paddy', 'ABY-2026-8910', '15 Sep 2026', 'Trichy APMC', '12 Qtls', '₹85,452.00', 'Paid', Colors.green),
              _buildHistoryCard('Cotton', 'ABY-2026-7241', '23 Aug 2026', 'Karur APMC', '18 Qtls', '₹1,26,540.00', 'Paid', Colors.green),
              _buildHistoryCard('Maize', 'ABY-2025-6632', '10 Jan 2026', 'Trichy APMC', '8 Qtls', '₹42,320.00', 'Paid', Colors.green),
              _buildHistoryCard('Groundnut', 'ABY-2025-5510', '18 Dec 2025', 'Thanjavur APMC', '6.5 Qtls', '₹38,675.00', 'Paid', Colors.green),
              _buildHistoryCard('Paddy', 'ABY-2025-4421', '25 Nov 2025', 'Thiruvarur APMC', '10 Qtls', '₹68,420.00', 'Pending', Colors.orange),
              _buildHistoryCard('Cotton', 'ABY-2025-3310', '12 Oct 2025', 'Salem APMC', '15 Qtls', '₹1,05,230.00', 'Paid', Colors.green),

              const SizedBox(height: 16),
              
              // View More Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.description, color: Color(0xFF1B5E20), size: 18),
                    SizedBox(width: 8),
                    Text('View More Records', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B5E20), size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, Color iconColor, String title, String mainValue, String subValue, [bool mainValueHasText = false]) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(mainValue, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: title.contains('Earnings') ? const Color(0xFF1B5E20) : Colors.black87)),
              if (mainValueHasText) ...[
                const SizedBox(width: 4),
                Text(subValue, style: const TextStyle(fontSize: 10, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              ]
            ],
          ),
          if (!mainValueHasText && subValue.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(subValue, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ]
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, [IconData? icon]) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F5A24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF0F5A24) : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String crop, String token, String date, String centre, String qtl, String amount, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Crop Image Placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.grass, color: Color(0xFF388E3C), size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(crop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B3B36))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(status == 'Paid' ? Icons.check_circle : Icons.schedule, size: 10, color: statusColor),
                          const SizedBox(width: 2),
                          Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Token: $token', style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                const SizedBox(height: 2),
                Text('Date: $date  |  Centre: $centre', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(qtl, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: status == 'Pending' ? Colors.grey.shade600 : const Color(0xFF1B5E20))),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
