import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class BasicPhoneSimulatorScreen extends StatefulWidget {
  const BasicPhoneSimulatorScreen({super.key});

  @override
  State<BasicPhoneSimulatorScreen> createState() => _BasicPhoneSimulatorScreenState();
}

class _BasicPhoneSimulatorScreenState extends State<BasicPhoneSimulatorScreen> {
  int _currentState = 0; // 0: Calling, 1: Greet, 2: Farmer, 3: AI
  String _aiResponse = '';
  bool _isProcessing = false;
  
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  final AudioPlayer audioPlayer = AudioPlayer();
  
  String _spokenWords = '';
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }
  
  Future<void> _initAudio() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    
    _speechEnabled = await speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted && _isListening) {
            _submitSpeech();
          }
        }
      },
    );

    // Start ringing
    if (_currentState == 0) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Mixkit free phone ringing sound
      await audioPlayer.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/1359/1359-preview.mp3'));
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    speech.stop();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _onKeypadPress(String key) {
    if (_currentState == 0 && (key == '1' || key == 'CALL')) {
      _answerCall();
    } else if (_currentState == 1 && (key == 'CALL' || key == 'END')) {
      // Manual trigger to stop listening and submit
      if (_isListening) {
        _submitSpeech();
      } else {
        _startListening();
      }
    } else if (_currentState == 4) {
      // Fallback menu keypad handling
      if (key == '1') {
        _playFallbackAnswer("Your next procurement appointment is on 15 September at 10:30 AM.");
      } else if (key == '2') {
        _playFallbackAnswer("There are 18 farmers ahead of you. Estimated wait time is 52 minutes.");
      } else if (key == '3') {
        _playFallbackAnswer("Your grain has completed quality inspection and is waiting for approval.");
      } else if (key == '4') {
        _playFallbackAnswer("Your payment of 85,452 rupees has been successfully credited.");
      } else if (key == '5') {
        _playFallbackAnswer("Light rain is expected. Please protect your grain properly before travelling.");
      }
    }
  }

  void _triggerFallbackMenu() async {
    final menuText = "AI service is temporarily unavailable. Main Menu: Press 1 for Booking. Press 2 for Queue. Press 3 for Grain Status. Press 4 for Payment. Press 5 for Weather.";
    setState(() {
      _currentState = 4;
      _aiResponse = menuText;
      _isProcessing = false;
    });
    await flutterTts.speak(menuText);
  }

  void _playFallbackAnswer(String answer) async {
    await flutterTts.stop();
    // Tiny delay to ensure browser speech synthesis clears the queue before new speech
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _currentState = 5;
      _aiResponse = answer;
    });
    await flutterTts.speak(answer);
  }

  Future<void> _answerCall() async {
    await audioPlayer.stop();
    setState(() {
      _currentState = 1;
      _spokenWords = '';
    });
    
    await flutterTts.speak("Welcome to Abhiyant Smart Procurement Centre. You can speak your request after the beep.");
    
    flutterTts.setCompletionHandler(() {
      if (_currentState == 1) _startListening();
    });
  }

  void _submitSpeech() {
    if (!_isListening) return;
    speech.stop();
    setState(() {
      _isListening = false;
    });
    if (_spokenWords.isNotEmpty) {
      _startProcessingGroq(_spokenWords);
    } else {
      _startProcessingGroq("I want to book a slot for paddy.");
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      _startProcessingGroq("I want to book a slot for paddy.");
      return;
    }

    setState(() {
      _isListening = true;
    });

    await speech.listen(
      onResult: (result) {
        setState(() {
          _spokenWords = result.recognizedWords;
        });
        
        if (result.finalResult) {
          _submitSpeech();
        }
      },
      localeId: 'en_IN',
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
    );
  }

  void _startProcessingGroq(String userText) {
    setState(() {
      _spokenWords = userText;
      _currentState = 2; // Processing
    });
    _callGroqApi(userText);
  }

  Future<void> _callGroqApi(String userText) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer YOUR_GROQ_API_KEY_HERE',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192',
          'messages': [
            {
              'role': 'system',
              'content': 'You are the ABHIYANT Smart Procurement Assistant. A farmer is calling through a basic phone IVR. Keep your answer under 2 sentences, simple, and conversational. The farmer says: "$userText". If they ask to book a slot for paddy, tell them their Paddy crop is registered, quantity is 1200kg, nearest slot is 15 September 2026 at 10:30 AM at Trichy APMC. Ask them to press 1 to confirm.'
            },
            {
              'role': 'user',
              'content': userText
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          _aiResponse = reply;
          _currentState = 3;
        });
        await flutterTts.speak(reply);
      } else {
        _triggerFallbackMenu();
      }
    } catch (e) {
      _triggerFallbackMenu();
    } finally {
      if (mounted && _currentState == 2) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Basic Phone IVR Simulator', style: TextStyle(color: Color(0xFF145A32), fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF145A32)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              flutterTts.stop();
              speech.stop();
              setState(() {
                _currentState = 0;
                _aiResponse = '';
                _spokenWords = '';
              });
              _initAudio();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Press 1 or Green Call Button to answer the call', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            // Nokia Frame
            Container(
              width: 260,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A), // Dark phone body
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, -1)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Speaker grill
                  const SizedBox(height: 4),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  
                  // Screen
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildScreenContent(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Buttons
                  _buildKeypad(),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Legend
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.memory, size: 16, color: Color(0xFF145A32)),
                  SizedBox(width: 4),
                  Text('Powered by ', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  Text('Groq AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF145A32))),
                  Text(' | STT & TTS Enabled', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenContent() {
    switch (_currentState) {
      case 0: // Calling
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F5A24), Color(0xFF000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              _buildStatusBar(isDark: true),
              const Spacer(),
              const Icon(Icons.eco, color: Color(0xFF81C784), size: 36),
              const Text('ABHIYANT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('Smart Procurement Centre', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(height: 12),
              const Text('Incoming Call...', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.green, width: 2)),
                child: const Icon(Icons.phone_in_talk, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 8),
              const Text('1800 123 4567', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              _buildSoftKeys('Options', 'Cancel', isDark: true),
            ],
          ),
        );
      case 1: // AI Greets
        return _buildChatScreen(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                    child: const Text(
                      'Welcome to ABHIYANT Smart Procurement Centre.\n\nYou can speak your request after the beep.\n\n(Press Green or Red button when finished)',
                      style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isListening ? Icons.mic : Icons.volume_up, color: const Color(0xFF2E7D32), size: 16),
                  const SizedBox(width: 4),
                  Text(_isListening ? 'Listening to you...' : 'AI Speaking...', style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      case 2: // Farmer Speaks
        return _buildChatScreen(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFC8E6C9))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.person, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('You (Speaking)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(_spokenWords.isEmpty ? '...' : _spokenWords, style: const TextStyle(fontSize: 12, color: Color(0xFF1B5E20), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Sound wave fake
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(15, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 3,
                    height: (index % 2 == 0 ? 10 : 20) + (index % 3 == 0 ? 5 : 0).toDouble(),
                    color: const Color(0xFF388E3C),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(_isProcessing ? 'Processing with Groq AI...' : 'Done processing.', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.memory, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Text('Powered by ', style: TextStyle(fontSize: 9, color: Colors.black54)),
                  Text('Groq AI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      case 3: // AI Responds
      case 4: // Fallback Menu
      case 5: // Fallback Answer
        return _buildChatScreen(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                    child: Text(
                      _aiResponse.isEmpty ? 'Waiting for response...' : _aiResponse,
                      style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.volume_up, color: Color(0xFF2E7D32), size: 16),
                  SizedBox(width: 4),
                  Text('Speaking...', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChatScreen({required Widget child}) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          _buildStatusBar(isDark: false),
          // App bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('ABHIYANT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF145A32))),
                    Text('AI Voice Assistant', style: TextStyle(fontSize: 8, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: child,
            ),
          ),
          _buildSoftKeys('Back', 'End', isDark: true, bgColor: Colors.black),
        ],
      ),
    );
  }

  Widget _buildStatusBar({required bool isDark}) {
    final color = isDark ? Colors.white : Colors.black87;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 12, color: color),
              const SizedBox(width: 4),
              Icon(Icons.wifi, size: 12, color: color),
            ],
          ),
          Text('10:24', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          Icon(Icons.battery_full, size: 12, color: color),
        ],
      ),
    );
  }

  Widget _buildSoftKeys(String left, String right, {required bool isDark, Color? bgColor}) {
    final color = isDark ? Colors.white : Colors.black87;
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(fontSize: 10, color: color)),
          Text(right, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        // Navigation keys
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionKey(Colors.green, true, 'CALL'),
            const SizedBox(width: 16),
            Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            _buildActionKey(Colors.red, false, 'END'),
          ],
        ),
        const SizedBox(height: 16),
        // Numpad
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumKey('1', 'oo'),
            _buildNumKey('2', 'ABC'),
            _buildNumKey('3', 'DEF'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumKey('4', 'GHI'),
            _buildNumKey('5', 'JKL'),
            _buildNumKey('6', 'MNO'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumKey('7', 'PQRS'),
            _buildNumKey('8', 'TUV'),
            _buildNumKey('9', 'WXYZ'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumKey('*', '+'),
            _buildNumKey('0', '␣'),
            _buildNumKey('#', '🔒'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionKey(Color color, bool isLeft, String id) {
    return GestureDetector(
      onTap: () => _onKeypadPress(id),
      child: Column(
        children: [
          Container(width: 30, height: 10, decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 8),
          Container(
            width: 30,
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(isLeft ? Icons.phone : Icons.phone_disabled, color: color, size: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumKey(String num, String alpha) {
    return GestureDetector(
      onTap: () => _onKeypadPress(num),
      child: Container(
        width: 50,
        height: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(num, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(alpha, style: const TextStyle(color: Colors.grey, fontSize: 7)),
            ],
          ),
        ),
      ),
    );
  }
}
