import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'basic_phone_simulator_screen.dart';

class BasicPhoneSuccessScreen extends StatelessWidget {
  final AppState appState;
  const BasicPhoneSuccessScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC8E6C9), width: 3),
                ),
                child: const Icon(Icons.check_circle, size: 60, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Your Basic Phone\nis Connected!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF145A32), height: 1.2),
              ),
              const SizedBox(height: 16),
              
              Text(
                'You can now access ABHIYANT services through an automated phone call.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 40),
              
              // Call Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                      child: const Icon(Icons.phone_in_talk, color: Color(0xFF1B5E20), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('ABHIYANT Smart Procurement Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B3B36))),
                          SizedBox(height: 4),
                          Text('Toll-free: 1800 123 4567', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the simulator instead of real tel: link for demo
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const BasicPhoneSimulatorScreen()),
                    );
                  },
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text('Call ABHIYANT Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF145A32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
