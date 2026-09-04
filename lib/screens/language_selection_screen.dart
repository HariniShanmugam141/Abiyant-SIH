import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'login_screen.dart';
import 'portal_menu_screen.dart';
import 'access_type_selection_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final AppState appState;
  
  const LanguageSelectionScreen({super.key, required this.appState});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguageCode = 'ta'; // Tamil selected by default
  bool _showOtherLanguages = false;

  final Map<String, Map<String, String>> _primaryLanguages = {
    'ta': {'native': 'தமிழ்', 'english': 'Tamil'},
    'en': {'native': 'English', 'english': 'English'},
  };

  final Map<String, Map<String, String>> _otherLanguages = {
    'te': {'native': 'తెలుగు', 'english': 'Telugu'},
    'kn': {'native': 'ಕನ್ನಡ', 'english': 'Kannada'},
    'hi': {'native': 'हिन्दी', 'english': 'Hindi'},
    'bn': {'native': 'বাংলা', 'english': 'Bengali'},
    'mr': {'native': 'मराठी', 'english': 'Marathi'},
    'gu': {'native': 'ગુજરાતી', 'english': 'Gujarati'},
    'pa': {'native': 'ਪੰਜਾਬੀ', 'english': 'Punjabi'},
    'ml': {'native': 'മലയാളം', 'english': 'Malayalam'},
    'or': {'native': 'ଓଡ଼ିଆ', 'english': 'Odia'},
    'as': {'native': 'অসমীয়া', 'english': 'Assamese'},
    'mai': {'native': 'मैथिली', 'english': 'Maithili'},
    'sa': {'native': 'संस्कृतम्', 'english': 'Sanskrit'},
    'doi': {'native': 'डोगरी', 'english': 'Dogri'},
    'kok': {'native': 'कोंकणी', 'english': 'Konkani'},
    'ks': {'native': 'कॉशुर', 'english': 'Kashmiri'},
    'ne': {'native': 'नेपाली', 'english': 'Nepali'},
    'sd': {'native': 'سنڌي', 'english': 'Sindhi'},
    'brx': {'native': 'बड़ो', 'english': 'Bodo'},
    'mni': {'native': 'মৈতৈলোন্', 'english': 'Manipuri'},
    'sat': {'native': 'ᱥᱟᱱᱛᱟᱲᱤ', 'english': 'Santhali'},
    'tcy': {'native': 'ತುಳು', 'english': 'Tulu'},
    'bho': {'native': 'भोजपुरी', 'english': 'Bhojpuri'},
    'hne': {'native': 'छत्तीसगढ़ी', 'english': 'Chhattisgarhi'},
    'nag': {'native': 'Nagamese', 'english': 'Nagamese'},
    'dzo': {'native': 'རྫོང་ཁ', 'english': 'Dizo'},
  };

  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguageCode = code;
    });
    
    // Set the language in the app state if it's Tamil (true) or English (false)
    widget.appState.setLanguage(code == 'ta');

    // Navigate to Login Screen with a slight delay so user sees selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              appState: widget.appState,
              onLoginSuccess: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AccessTypeSelectionScreen(appState: widget.appState),
                  ),
                );
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9), // Off-white agricultural theme background
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome to Abhiyant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF145A32),
                            ),
                          ),
                          Text(
                            'Smart Procurement Centre',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Select Your Language',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF145A32),
                    ),
                  ),
                ],
              ),
            ),

            // Language Options
            Expanded(
              child: _showOtherLanguages ? _buildOtherLanguagesList() : _buildInitialOptions(),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: const Text(
                'You can change the language anytime in settings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        _buildLanguageCard(
          code: 'ta',
          primary: _primaryLanguages['ta']!['native']!,
          secondary: _primaryLanguages['ta']!['english']!,
          isSelected: _selectedLanguageCode == 'ta',
        ),
        const SizedBox(height: 12),
        _buildLanguageCard(
          code: 'en',
          primary: _primaryLanguages['en']!['native']!,
          secondary: _primaryLanguages['en']!['english']!,
          isSelected: _selectedLanguageCode == 'en',
        ),
        const SizedBox(height: 12),
        _buildOtherLanguagesCard(),
      ],
    );
  }

  Widget _buildLanguageCard({
    required String code,
    required String primary,
    required String secondary,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _selectLanguage(code),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primary,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF145A32) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  secondary,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF2E7D32) : Colors.black54,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherLanguagesCard() {
    return InkWell(
      onTap: () {
        setState(() {
          _showOtherLanguages = true;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.more_horiz, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Other Indian Languages',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Future Enhancement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherLanguagesList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF145A32)),
                onPressed: () {
                  setState(() {
                    _showOtherLanguages = false;
                  });
                },
              ),
              const Text(
                'Other Indian Languages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF145A32),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: _otherLanguages.length,
            itemBuilder: (context, index) {
              String code = _otherLanguages.keys.elementAt(index);
              String native = _otherLanguages[code]!['native']!;
              String english = _otherLanguages[code]!['english']!;
              bool isSelected = _selectedLanguageCode == code;

              return InkWell(
                onTap: () => _selectLanguage(code),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        native,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF145A32) : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        english,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
