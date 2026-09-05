import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'basic_phone_otp_screen.dart';

class BasicPhoneRegistrationScreen extends StatefulWidget {
  final AppState appState;
  const BasicPhoneRegistrationScreen({super.key, required this.appState});

  @override
  State<BasicPhoneRegistrationScreen> createState() => _BasicPhoneRegistrationScreenState();
}

class _BasicPhoneRegistrationScreenState extends State<BasicPhoneRegistrationScreen> {
  final _phoneController = TextEditingController();

  void _onContinue() {
    if (_phoneController.text.length == 10) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BasicPhoneOtpScreen(appState: widget.appState, phoneNumber: _phoneController.text),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branding
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', height: 60),
                    const SizedBox(height: 8),
                    const Text('ABHIYANT', style: TextStyle(color: Color(0xFF145A32), fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1.2)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Illustration
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC8E6C9), width: 2),
                  ),
                  child: const Icon(Icons.phone_android, size: 40, color: Color(0xFF2E7D32)),
                ),
              ),
              const SizedBox(height: 32),

              const Text('Enter Your Mobile Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B3B36))),
              const SizedBox(height: 8),
              Text('Use your basic phone number to access ABHIYANT services.', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4)),
              
              const SizedBox(height: 32),

              // Input Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      ),
                      child: const Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: const TextStyle(fontSize: 18, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Enter 10 digits',
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF145A32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Important updates will be sent through SMS and automated phone calls.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
