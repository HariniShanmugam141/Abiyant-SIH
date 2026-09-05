import 'package:flutter/material.dart';
import '../state/app_state.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final AppState appState;

  const PaymentDetailsScreen({super.key, required this.appState});

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
            const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3B36))),
            Text('Track your payment from approval to your bank account', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
      ),
      body: Center(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC8E6C9)),
                        ),
                        child: const Icon(Icons.spa, color: Color(0xFF388E3C), size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.eco, color: Color(0xFF2E7D32), size: 16),
                                SizedBox(width: 4),
                                Text('Paddy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Token: ABY-2026-8910', style: TextStyle(color: Colors.grey.shade800, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('Procurement Centre: Trichy APMC', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text('Date: 01 Sep 2026  |  Quantity: 12 Quintals', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          const SizedBox(height: 2),
                          const Text('₹85,452.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF1B5E20))),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 14),
                                SizedBox(width: 4),
                                Text('Payment Received', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                
                // Payment Progress
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.payments, color: Color(0xFF1B5E20), size: 24),
                          SizedBox(width: 8),
                          Text('Payment Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Real-time status of your payment', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 24),
                      
                      // Stepper
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHorizontalStep('Amount\nCalculated', '01 Sep 2026\n11:30 AM', true, false),
                            _buildHorizontalStep('Approved', '02 Sep 2026\n10:15 AM', true, false),
                            _buildHorizontalStep('Payment\nInitiated', '02 Sep 2026\n02:45 PM', true, false),
                            _buildHorizontalStep('Processing\n(DBT)', '02 Sep 2026\n04:20 PM', true, false),
                            _buildHorizontalStep('Payment\nReceived', '02 Sep 2026\n06:10 PM', true, true, isLast: true),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Success Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC8E6C9)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 36),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Payment successfully credited!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B5E20))),
                                  const SizedBox(height: 4),
                                  Text('The amount has been credited to your linked bank account via DBT.', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Icon(Icons.spa, color: Color(0xFF2E7D32), size: 24),
                                const SizedBox(height: 4),
                                Text('Your hard work', style: TextStyle(fontSize: 9, color: Colors.green.shade800)),
                                Text('feeds a better tomorrow!', style: TextStyle(fontSize: 9, color: Colors.green.shade800)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Information Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.receipt_long, color: Color(0xFF1B5E20)),
                          SizedBox(width: 8),
                          Text('Payment Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Using Wrap to handle overflow on small screens gracefully
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          // Left Column
                          SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoItem('Total Quantity (Accepted)', '12 Quintals (1,200 kg)'),
                                const SizedBox(height: 16),
                                _buildInfoItem('MSP Rate', '₹7,121 / Quintal'),
                                const SizedBox(height: 16),
                                const Text('Total Amount', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                const SizedBox(height: 4),
                                const Text('₹85,452.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF1B5E20))),
                              ],
                            ),
                          ),
                          // Middle Column
                          SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildIconInfoItem(Icons.account_balance, 'Payment Method', 'Direct Benefit Transfer (DBT)'),
                                const SizedBox(height: 16),
                                _buildIconInfoItem(Icons.credit_card, 'Bank Account', 'XXXX XXXX 4321\n(State Bank of India)'),
                                const SizedBox(height: 16),
                                _buildIconInfoItem(Icons.description_outlined, 'Transaction ID', 'SBI4287356281'),
                                const SizedBox(height: 16),
                                _buildIconInfoItem(Icons.calendar_today, 'Payment Date', '02 Sep 2026, 06:10 PM'),
                              ],
                            ),
                          ),
                          // Right Column
                          SizedBox(
                            width: 220,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F8E9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFC8E6C9)),
                                  ),
                                  child: Column(
                                    children: const [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 16),
                                          SizedBox(width: 6),
                                          Text('Credited to Bank', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 13)),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text('₹85,452.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1B5E20))),
                                      SizedBox(height: 4),
                                      Text('on 02 Sep 2026', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.download, color: Color(0xFF2E7D32), size: 18),
                                    label: const Text('Download Receipt', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFF2E7D32)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.share, color: Colors.black87, size: 18),
                                    label: const Text('Share Receipt', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.grey.shade300),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom row
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Need Help Card
                    Container(
                      width: 330,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.orange.shade800),
                              const SizedBox(width: 8),
                              Text('Need Help?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange.shade900)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'If you have not received the payment or find any issue, please raise a request.',
                            style: TextStyle(color: Colors.orange.shade900, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text('Raise an Issue', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                                const Icon(Icons.chevron_right, color: Colors.red),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    
                    // Important Info Card
                    Container(
                      width: 370,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.lightbulb, color: Color(0xFF1B5E20)),
                              SizedBox(width: 8),
                              Text('Important Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B3B36))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildBulletPoint('Payments are made directly to your bank account via DBT.'),
                          const SizedBox(height: 8),
                          _buildBulletPoint('Processing time may take 1-3 working days.'),
                          const SizedBox(height: 8),
                          _buildBulletPoint('Contact your procurement centre for any payment verification.'),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalStep(String title, String subtitle, bool isCompleted, bool isSpecial, {bool isLast = false}) {
    return SizedBox(
      width: 130, // fixed width per step to give it breathing room
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                ),
              ),
              Container(
                width: isSpecial ? 40 : 28,
                height: isSpecial ? 40 : 28,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF2E7D32) : Colors.white,
                  shape: BoxShape.circle,
                  border: isCompleted ? null : Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Center(
                  child: isSpecial 
                      ? const Icon(Icons.account_balance, color: Colors.white, size: 20)
                      : (isCompleted ? const Icon(Icons.check, color: Colors.white, size: 18) : null),
                ),
              ),
              Expanded(
                child: Container(
                  height: 3,
                  color: (isCompleted && !isLast) ? const Color(0xFF2E7D32) : Colors.transparent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1B3B36))),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildIconInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: Icon(Icons.circle, size: 6, color: Color(0xFF1B3B36)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.grey.shade800, fontSize: 13, height: 1.4)),
        ),
      ],
    );
  }
}
