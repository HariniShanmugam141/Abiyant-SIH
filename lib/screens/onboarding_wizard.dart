import 'package:flutter/material.dart';
import '../state/app_state.dart';

class OnboardingWizardScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onRegistrationSuccess;

  const OnboardingWizardScreen({
    super.key,
    required this.appState,
    required this.onRegistrationSuccess,
  });

  @override
  State<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends State<OnboardingWizardScreen> {
  int _currentStep = 1; // 1, 2, 3

  // Step 1 Controllers & States
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _guardianController = TextEditingController();
  final TextEditingController _farmerIdController = TextEditingController();
  String? _selectedGender;
  String? _selectedDob;
  String? _selectedCategory;
  final TextEditingController _altMobileController = TextEditingController();
  bool _otpSent = false;
  bool _otpVerified = false;

  // Step 2 Controllers & States
  final TextEditingController _addressController = TextEditingController();
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMandal;
  String? _selectedVillage;
  String? _selectedMarket;
  String? _selectedFarmerType;
  final TextEditingController _passbookController = TextEditingController();

  // Step 3 Controllers & States
  String? _selectedMeasurementType = 'Acres';
  final TextEditingController _totalLandController = TextEditingController();
  final TextEditingController _cottonLandController = TextEditingController();
  
  bool _tradCropsChecked = false;
  final TextEditingController _tradAcresController = TextEditingController();
  
  bool _hdpsChecked = false;
  final TextEditingController _hdpsAcresController = TextEditingController();
  
  bool _desiChecked = false;
  final TextEditingController _desiAcresController = TextEditingController();
  
  bool _spacingChecked = false;
  final TextEditingController _spacingAcresController = TextEditingController();

  bool _docUploaded = false;

  @override
  void initState() {
    super.initState();
    // Default pre-fill mobile if available
    if (widget.appState.mobileNumber.isNotEmpty) {
      _mobileController.text = widget.appState.mobileNumber;
      _otpSent = true;
      _otpVerified = true;
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _guardianController.dispose();
    _farmerIdController.dispose();
    _altMobileController.dispose();
    _addressController.dispose();
    _passbookController.dispose();
    _totalLandController.dispose();
    _cottonLandController.dispose();
    _tradAcresController.dispose();
    _hdpsAcresController.dispose();
    _desiAcresController.dispose();
    _spacingAcresController.dispose();
    super.dispose();
  }

  // Pre-fill Demo Data Helper to save time during hackathon presentations!
  void _prefillDemoData() {
    setState(() {
      _mobileController.text = '9876543210';
      _otpSent = true;
      _otpVerified = true;
      _nameController.text = 'Selvamurugan K';
      _guardianController.text = 'Kumaravel S';
      _farmerIdController.text = 'FID927481';
      _selectedGender = 'Male';
      _selectedDob = '15/06/1978';
      _selectedCategory = 'OBC';
      _altMobileController.text = '9876543211';
      
      _addressController.text = '24, MGR Street, South Kottai';
      _selectedState = 'Tamil Nadu';
      _selectedDistrict = 'Thanjavur';
      _selectedMandal = 'Thanjavur Block';
      _selectedVillage = 'Melattur';
      _selectedMarket = 'Thanjavur APMC';
      _selectedFarmerType = 'Small Farmer';
      _passbookController.text = 'PBK-992147312';
      
      _selectedMeasurementType = 'Acres';
      _totalLandController.text = '4.50';
      _cottonLandController.text = '2.20';
      _tradCropsChecked = true;
      _tradAcresController.text = '2.30';
      _hdpsChecked = true;
      _hdpsAcresController.text = '1.20';
      _desiChecked = false;
      _spacingChecked = true;
      _spacingAcresController.text = '1.00';
      _docUploaded = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo details pre-filled successfully!'),
        backgroundColor: Color(0xFF0F5A24),
      ),
    );
  }

  void _submitStep1() {
    if (!_otpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'தயவுசெய்து மொபைல் எண்ணை சரிபார்க்கவும்'
                : 'Please verify mobile number first',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty ||
        _guardianController.text.trim().isEmpty ||
        _farmerIdController.text.trim().isEmpty ||
        _selectedGender == null ||
        _selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'அனைத்து விவரங்களையும் நிரப்பவும்.'
                : 'Please fill in all personal details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _submitStep2() {
    if (_addressController.text.trim().isEmpty ||
        _selectedState == null ||
        _selectedDistrict == null ||
        _selectedVillage == null ||
        _selectedFarmerType == null ||
        _passbookController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'அனைத்து முகவரி மற்றும் இருப்பிட விவரங்களை நிரப்பவும்.'
                : 'Please fill in all location and address details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _currentStep = 3);
  }

  void _submitStep3() {
    if (_totalLandController.text.isEmpty || _cottonLandController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appState.isTamil
                ? 'தயவுசெய்து நில அளவு விபரங்களை உள்ளிடவும்.'
                : 'Please fill in land owned details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Submit all data to central app state
    widget.appState.submitRegistration(
      mobileVal: _mobileController.text,
      nameVal: _nameController.text,
      guardianVal: _guardianController.text,
      farmerIdVal: _farmerIdController.text,
      genderVal: _selectedGender ?? 'Male',
      dobVal: _selectedDob ?? '01/01/1980',
      categoryVal: _selectedCategory ?? 'General',
      altMobileVal: _altMobileController.text,
      addressVal: _addressController.text,
      stateVal: _selectedState ?? 'Tamil Nadu',
      districtVal: _selectedDistrict ?? 'Thanjavur',
      mandalVal: _selectedMandal ?? 'Mandal',
      villageVal: _selectedVillage ?? 'Village',
      marketVal: _selectedMarket ?? 'Market',
      farmerTypeVal: _selectedFarmerType ?? 'Marginal',
      passbookVal: _passbookController.text,
      totalLandVal: double.tryParse(_totalLandController.text) ?? 0.0,
      cottonLandVal: double.tryParse(_cottonLandController.text) ?? 0.0,
      tradCrops: _tradCropsChecked,
      tradAcres: double.tryParse(_tradAcresController.text) ?? 0.0,
      hdpsVal: _hdpsChecked,
      hdpsAcresVal: double.tryParse(_hdpsAcresController.text) ?? 0.0,
      desiVal: _desiChecked,
      desiAcresVal: double.tryParse(_desiAcresController.text) ?? 0.0,
      spacingVal: _spacingChecked,
      spacingAcresVal: double.tryParse(_spacingAcresController.text) ?? 0.0,
    );

    widget.onRegistrationSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          isTamil ? 'விவசாயி பதிவு' : 'Farmer Onboarding',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Pre-fill Demo Data button in Action bar
          TextButton.icon(
            onPressed: _prefillDemoData,
            icon: const Icon(Icons.flash_on, color: Colors.amber),
            label: Text(
              isTamil ? 'டெமோ தரவு' : 'Demo Fill',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Landscape Subheader Illustration
            _buildLandscapeHeader(isTamil),

            // Step Card Wrapper
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildCurrentStepView(isTamil),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Visual header showing farm landscape and step indicators
  Widget _buildLandscapeHeader(bool isTamil) {
    String stepDesc = '';
    if (_currentStep == 1) {
      stepDesc = isTamil ? 'நாளைக்கு நல்ல எதிர்காலத்திற்கு இணைந்து செயல்படுவோம்' : "Let's grow together for a better tomorrow";
    } else if (_currentStep == 2) {
      stepDesc = isTamil ? 'உங்களை பற்றி நன்றாக அறிய உதவுங்கள்' : 'Help us know you better';
    } else {
      stepDesc = isTamil ? 'விவரங்களை பூர்த்தி செய்யவும்' : "Let's complete your profile";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F5A24).withOpacity(0.08),
        border: Border(bottom: BorderSide(color: Colors.green.shade100)),
      ),
      child: Column(
        children: [
          const Icon(Icons.spa, color: Color(0xFF0F5A24), size: 28),
          const SizedBox(height: 8),
          Text(
            isTamil ? 'விவசாயி உள்நுழைவு பதிவு' : 'Farmer Onboarding',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stepDesc,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),

          // Custom horizontal progress dots matching Image progress bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressCircle(1),
              _buildProgressLine(1),
              _buildProgressCircle(2),
              _buildProgressLine(2),
              _buildProgressCircle(3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(int stepNum) {
    final bool isCompletedOrActive = _currentStep >= stepNum;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompletedOrActive ? const Color(0xFF0F5A24) : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          '$stepNum',
          style: TextStyle(
            color: isCompletedOrActive ? Colors.white : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine(int fromStep) {
    final bool isLineActive = _currentStep > fromStep;
    return Container(
      width: 40,
      height: 3,
      color: isLineActive ? const Color(0xFF0F5A24) : Colors.grey.shade300,
    );
  }

  // Router matching step states
  Widget _buildCurrentStepView(bool isTamil) {
    switch (_currentStep) {
      case 1:
        return _buildStep1View(isTamil);
      case 2:
        return _buildStep2View(isTamil);
      case 3:
        return _buildStep3View(isTamil);
      default:
        return _buildStep1View(isTamil);
    }
  }

  // --- Step 1: Mobile & Personal Details (Image 1 replica) ---
  Widget _buildStep1View(bool isTamil) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mobile Number Field
        _buildInputLabel(
          icon: Icons.phone_android,
          title: isTamil ? 'கைபேசி எண்' : 'Mobile Number',
          subtitle: isTamil ? 'உங்கள் 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்' : 'Enter your 10 digit mobile number',
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: isTamil ? 'மொபைல் எண் உள்ளிடவும்' : 'Enter Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                if (_mobileController.text.length < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isTamil ? 'முறையான கைபேசி எண்ணை உள்ளிடவும்' : 'Enter a valid mobile number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                setState(() {
                  _otpSent = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isTamil ? 'OTP அனுப்பப்பட்டது! (டெமோ OTP: 123456)' : 'OTP Sent! (Demo: 123456)'),
                    backgroundColor: const Color(0xFF0F5A24),
                  ),
                );
              },
              icon: const Icon(Icons.send, size: 16),
              label: Text(isTamil ? 'OTP அனுப்பு' : 'Send OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A24),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // OTP Verification Area
        if (_otpSent) ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  enabled: !_otpVerified,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: isTamil ? 'OTP குறியீட்டை உள்ளிடவும்' : 'Enter OTP',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _otpVerified
                    ? null
                    : () {
                        if (_otpController.text == '123456' || _otpController.text.length == 6) {
                          setState(() {
                            _otpVerified = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isTamil ? 'கைபேசி எண் வெற்றிகரமாக சரிபார்க்கப்பட்டது!' : 'Mobile verified successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isTamil ? 'தவறான OTP' : 'Invalid OTP. Try 123456.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _otpVerified ? Colors.grey : const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(_otpVerified ? (isTamil ? 'சரிபார்க்கப்பட்டது' : 'Verified') : (isTamil ? 'சரிபார்' : 'Verify')),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],

        const Divider(height: 30),
        
        // Personal details subheader
        _buildSectionHeader(
          icon: Icons.assignment_ind_outlined,
          title: isTamil ? 'தனிப்பட்ட விவரங்கள்' : 'Personal Details',
        ),

        // Full Name Field
        _buildInputFieldLabel(isTamil ? 'பெயர்' : 'Name', isTamil ? 'உங்கள் முழு பெயரை உள்ளிடவும்' : 'Enter your full name'),
        _buildTextFormField(_nameController, isTamil ? 'முழு பெயர்' : 'Full Name', Icons.badge_outlined),

        // Guardian Name Field
        _buildInputFieldLabel(isTamil ? 'பாதுகாவலர் / தந்தையின் பெயர்' : "Guardian / Father's Name", isTamil ? 'பாதுகாவலர் அல்லது தந்தை பெயரை உள்ளிடவும்' : "Enter guardian or father's name"),
        _buildTextFormField(_guardianController, isTamil ? 'தந்தையின் பெயர்' : "Father's Name", Icons.people_outline),

        // Unique Farmer ID Field
        _buildInputFieldLabel(isTamil ? 'விவசாயி தனித்துவ அடையாள எண்' : 'Unique Farmer ID', isTamil ? 'பதிவு எண் / விவசாயி ஐடியை உள்ளிடவும்' : 'Enter your farmer ID / Registration No.'),
        _buildTextFormField(_farmerIdController, isTamil ? 'விவசாயி ஐடி' : 'Farmer ID', Icons.assignment_outlined),

        // Gender Dropdown
        _buildInputFieldLabel(isTamil ? 'பாலினம்' : 'Gender', isTamil ? 'பாலினத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Gender'),
        _buildDropdownField(
          value: _selectedGender,
          hint: isTamil ? 'பாலினத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Gender',
          icon: Icons.wc,
          items: isTamil
              ? ['ஆண்', 'பெண்', 'இதர']
              : ['Male', 'Female', 'Other'],
          onChanged: (val) => setState(() => _selectedGender = val),
        ),

        // Date of Birth Dropdown
        _buildInputFieldLabel(isTamil ? 'பிறந்த தேதி' : 'Date of Birth', isTamil ? 'பிறந்த தேதியைத் தேர்ந்தெடுக்கவும்' : 'Select Date of Birth'),
        _buildDropdownField(
          value: _selectedDob,
          hint: isTamil ? 'தேதியைத் தேர்ந்தெடுக்கவும்' : 'Select Date of Birth',
          icon: Icons.calendar_today_outlined,
          items: ['15/06/1978', '20/11/1982', '05/04/1990', '12/12/1965'], // Demo dates
          onChanged: (val) => setState(() => _selectedDob = val),
        ),

        const Divider(height: 30),

        // Community Details
        _buildSectionHeader(
          icon: Icons.groups_outlined,
          title: isTamil ? 'சமூக விவரங்கள்' : 'Community Details',
        ),
        _buildInputFieldLabel(isTamil ? 'பிரிவு' : 'Category', isTamil ? 'பிரிவைத் தேர்ந்தெடுக்கவும்' : 'Select Category'),
        _buildDropdownField(
          value: _selectedCategory,
          hint: isTamil ? 'பிரிவைத் தேர்ந்தெடுக்கவும்' : 'Select Category',
          icon: Icons.category_outlined,
          items: ['General', 'OBC', 'SC', 'ST'],
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),

        const Divider(height: 30),

        // Contact details alt phone
        _buildSectionHeader(
          icon: Icons.contact_phone_outlined,
          title: isTamil ? 'தொடர்பு விவரங்கள்' : 'Contact Details',
        ),
        _buildInputFieldLabel(isTamil ? 'மாற்று கைபேசி எண்' : 'Alternate Mobile Number', isTamil ? 'மாற்று மொபைல் எண்ணை உள்ளிடவும்' : 'Enter alternate mobile number'),
        _buildTextFormField(_altMobileController, isTamil ? 'மாற்று எண்' : 'Alternate Number', Icons.phone_android_outlined, isPhone: true),

        const SizedBox(height: 25),

        // Complete step 1 button
        ElevatedButton.icon(
          onPressed: _submitStep1,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          label: Text(
            isTamil ? 'பதிவை தொடரவும்' : 'Complete Registration',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5A24),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // --- Step 2: Address & Location Details (Image 3 replica) ---
  Widget _buildStep2View(bool isTamil) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address details
        _buildSectionHeader(
          icon: Icons.home_outlined,
          title: isTamil ? 'இருப்பிட முகவரி' : 'Residential Address',
        ),
        _buildInputFieldLabel(isTamil ? 'முழு முகவரி' : 'Residential Address', isTamil ? 'கதவு எண், தெரு, பகுதி உள்ளிடவும்' : 'Enter your full address'),
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: isTamil ? 'கதவு எண், தெரு, பகுதி, ஊர்' : 'House No., Street, Area, Locality',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Icon(Icons.home, color: Color(0xFF0F5A24)),
            ),
          ),
        ),

        const Divider(height: 30),

        // Location Details
        _buildSectionHeader(
          icon: Icons.location_on_outlined,
          title: isTamil ? 'இருப்பிட விவரங்கள்' : 'Location Details',
        ),

        // State Dropdown
        _buildInputFieldLabel(isTamil ? 'மாநிலம்' : 'State', isTamil ? 'மாநிலத்தைத் தேர்ந்தெடுக்கவும்' : 'Select State'),
        _buildDropdownField(
          value: _selectedState,
          hint: isTamil ? 'மாநிலத்தைத் தேர்ந்தெடுக்கவும்' : 'Select State',
          icon: Icons.map_outlined,
          items: ['Tamil Nadu', 'Andhra Pradesh', 'Karnataka', 'Telangana'],
          onChanged: (val) => setState(() => _selectedState = val),
        ),

        // District Dropdown
        _buildInputFieldLabel(isTamil ? 'மாவட்டம்' : 'District', isTamil ? 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select District'),
        _buildDropdownField(
          value: _selectedDistrict,
          hint: isTamil ? 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select District',
          icon: Icons.location_city_outlined,
          items: ['Thanjavur', 'Trichy', 'Madurai', 'Salem', 'Coimbatore'],
          onChanged: (val) => setState(() => _selectedDistrict = val),
        ),

        // Mandal Dropdown
        _buildInputFieldLabel(isTamil ? 'வட்டம் / ஒன்றியம்' : 'Mandal / Block', isTamil ? 'வட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Mandal / Block'),
        _buildDropdownField(
          value: _selectedMandal,
          hint: isTamil ? 'வட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Mandal / Block',
          icon: Icons.lan_outlined,
          items: ['Thanjavur Block', 'Trichy East', 'Salem South', 'Madurai North'],
          onChanged: (val) => setState(() => _selectedMandal = val),
        ),

        // Village Dropdown
        _buildInputFieldLabel(isTamil ? 'கிராமம்' : 'Village', isTamil ? 'கிராமத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Village'),
        _buildDropdownField(
          value: _selectedVillage,
          hint: isTamil ? 'கிராமத்தைத் தேர்ந்தெடுக்கவும்' : 'Select Village',
          icon: Icons.forest_outlined,
          items: ['Melattur', 'Papanasam', 'Lalgudi', 'Attur'],
          onChanged: (val) => setState(() => _selectedVillage = val),
        ),

        // Market Town Dropdown
        _buildInputFieldLabel(isTamil ? 'சந்தை / நகரம்' : 'Market / Town', isTamil ? 'சந்தையைத் தேர்ந்தெடுக்கவும்' : 'Select Market / Town'),
        _buildDropdownField(
          value: _selectedMarket,
          hint: isTamil ? 'சந்தையைத் தேர்ந்தெடுக்கவும்' : 'Select Market / Town',
          icon: Icons.storefront_outlined,
          items: ['Thanjavur APMC', 'Trichy Mandi', 'Salem Direct Purchase Center'],
          onChanged: (val) => setState(() => _selectedMarket = val),
        ),

        // Farmer Type Dropdown
        _buildInputFieldLabel(isTamil ? 'விவசாயி வகை' : 'Farmer Type', isTamil ? 'விவசாயி வகையைத் தேர்ந்தெடுக்கவும்' : 'Select Farmer Type'),
        _buildDropdownField(
          value: _selectedFarmerType,
          hint: isTamil ? 'விவசாயி வகையைத் தேர்ந்தெடுக்கவும்' : 'Select Farmer Type',
          icon: Icons.person_outline,
          items: ['Marginal Farmer (< 1 Hectare)', 'Small Farmer (1-2 Hectares)', 'Semi-Medium (2-4 Hectares)', 'Large Farmer (> 4 Hectares)'],
          onChanged: (val) => setState(() => _selectedFarmerType = val),
        ),

        // Passbook / Katha Number field
        _buildInputFieldLabel(isTamil ? 'பட்டா / பட்டா புத்தகம் எண்' : 'Passbook / Katha Number', isTamil ? 'பட்டா எண்ணை உள்ளிடவும்' : 'Enter your passbook or khatha number'),
        _buildTextFormField(_passbookController, isTamil ? 'பட்டா எண்' : 'Passbook Number', Icons.menu_book_outlined),

        const SizedBox(height: 25),

        // Continue button
        ElevatedButton.icon(
          onPressed: _submitStep2,
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: Text(
            isTamil ? 'முகவரிப் பதிவை சேமி' : 'Continue Registration',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5A24),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // --- Step 3: Land Records & Crop Details (Image 2 replica) ---
  Widget _buildStep3View(bool isTamil) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Land records passbook number
        _buildSectionHeader(
          icon: Icons.landscape_outlined,
          title: isTamil ? 'நிலப் பதிவேடுகள் விபரம்' : 'Land Records Details',
        ),
        _buildInputFieldLabel(isTamil ? 'பட்டா எண்' : 'Passbook / Katha Number', isTamil ? 'நிலப் பட்டா புத்தக எண்ணை உள்ளிடவும்' : 'Enter your passbook or katha number'),
        _buildTextFormField(_passbookController, isTamil ? 'பட்டா எண்' : 'Enter Passbook / Katha Number', Icons.menu_book_outlined),

        const SizedBox(height: 10),
        
        // Add more land button
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isTamil ? 'கூடுதல் நிலப் பதிவு சேர்க்கப்பட்டது!' : 'Additional land record entry row added!'),
                    backgroundColor: const Color(0xFF0F5A24),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: Text(isTamil ? 'மேலும் சேர்க்க' : 'Add More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isTamil ? 'கூடுதல் நில விபரங்கள் இருந்தால் சேர்க்கவும்' : 'Add more land records if you have',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),

        const Divider(height: 30),

        // Land Measurements section
        _buildSectionHeader(
          icon: Icons.architecture_outlined,
          title: isTamil ? 'நில அளவீடு விவரம்' : 'Land Measurement',
        ),

        // Measurement Type dropdown
        _buildInputFieldLabel(isTamil ? 'அளவீட்டு அலகு' : 'Measurement Type', isTamil ? 'அளவீட்டு அலகைத் தேர்ந்தெடுக்கவும்' : 'Select Measurement Type'),
        _buildDropdownField(
          value: _selectedMeasurementType,
          hint: 'Select Measurement Type',
          icon: Icons.square_foot_outlined,
          items: ['Acres', 'Hectares', 'Cents'],
          onChanged: (val) => setState(() => _selectedMeasurementType = val),
        ),

        const SizedBox(height: 12),

        // Total Land Owned (horizontal layout as screenshot)
        _buildLandAreaRow(
          label: isTamil ? 'மொத்த நிலப்பரப்பு' : 'Total Land Owned',
          sub: isTamil ? 'ஏக்கரில் உள்ள நிலப்பரப்பு' : 'Enter total land in acres',
          controller: _totalLandController,
          hint: 'e.g., 2.50',
          icon: Icons.dashboard_outlined,
        ),

        const SizedBox(height: 12),

        // Cotton Land Area
        _buildLandAreaRow(
          label: isTamil ? 'பருத்தி சாகுபடி பரப்பு' : 'Cotton Land Area',
          sub: isTamil ? 'ஏக்கரில் பருத்தி நிலப்பரப்பு' : 'Enter cotton land in acres',
          controller: _cottonLandController,
          hint: 'e.g., 1.20',
          icon: Icons.eco_outlined,
        ),

        const Divider(height: 30),

        // Crop Details Checkboxes
        _buildSectionHeader(
          icon: Icons.grass_outlined,
          title: isTamil ? 'பயிர் விவரங்கள்' : 'Crop Details',
        ),
        Text(
          isTamil ? 'உங்கள் பயிர் சாகுபடி விவரங்களை வழங்கவும்:' : 'Provide details of your crop cultivation:',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 10),

        // Checkbox items with acres inputs on right
        _buildCropCheckboxRow(
          label: isTamil ? 'பாரம்பரிய பயிர்கள்' : 'Traditional Crops',
          checked: _tradCropsChecked,
          controller: _tradAcresController,
          onChanged: (val) => setState(() => _tradCropsChecked = val ?? false),
        ),
        _buildCropCheckboxRow(
          label: isTamil ? 'அதி அடர்த்தி நடவு முறை (HDPS)' : 'HDPS (High Density Planting System)',
          checked: _hdpsChecked,
          controller: _hdpsAcresController,
          onChanged: (val) => setState(() => _hdpsChecked = val ?? false),
        ),
        _buildCropCheckboxRow(
          label: isTamil ? 'தேசி பருத்தி' : 'Desi Cotton',
          checked: _desiChecked,
          controller: _desiAcresController,
          onChanged: (val) => setState(() => _desiChecked = val ?? false),
        ),
        _buildCropCheckboxRow(
          label: isTamil ? 'நெருக்க நடவு முறை' : 'Closer Spacing',
          checked: _spacingChecked,
          controller: _spacingAcresController,
          onChanged: (val) => setState(() => _spacingChecked = val ?? false),
        ),
        
        Text(
          isTamil
              ? '*தேர்ந்தெடுக்கப்பட்ட பயிர்களுக்கு ஏக்கர் விபரங்களை உள்ளிடவும்.'
              : '*Enter area in acres for the selected crop types',
          style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
        ),

        const Divider(height: 30),

        // Document Uploader
        _buildSectionHeader(
          icon: Icons.cloud_upload_outlined,
          title: isTamil ? 'ஆவணங்களைப் பதிவேற்றுதல்' : 'Upload Documents',
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              const Icon(Icons.description, size: 36, color: Color(0xFF0F5A24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTamil ? 'ஆதார் & சமீபத்திய புகைப்படம்' : 'Upload Aadhaar & recent photo',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      isTamil ? 'படம் மட்டுமே, அதிகபட்சம் 1 எம்பி' : 'Image only, Max 1 MB',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _docUploaded = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mock files uploaded successfully!'),
                      backgroundColor: Color(0xFF0F5A24),
                    ),
                  );
                },
                icon: Icon(_docUploaded ? Icons.check : Icons.file_upload, size: 16),
                label: Text(_docUploaded ? (isTamil ? 'ஏற்றப்பட்டது' : 'Uploaded') : (isTamil ? 'கோப்பு தேர்வு' : 'Choose Files')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F5A24),
                  side: const BorderSide(color: Color(0xFF0F5A24)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Submit Button
        ElevatedButton.icon(
          onPressed: _submitStep3,
          icon: const Icon(Icons.grass, color: Colors.white),
          label: Text(
            isTamil ? 'பதிவை சமர்ப்பிக்கவும்' : 'Submit Registration',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5A24),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // --- UI Component Helpers ---

  Widget _buildInputLabel({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F5A24).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0F5A24), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F5A24), size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F5A24)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldLabel(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          Text(desc, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String hint, IconData icon, {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(icon, color: const Color(0xFF0F5A24), size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: const Color(0xFF0F5A24), size: 20),
              const SizedBox(width: 10),
              Text(hint, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLandAreaRow({
    required String label,
    required String sub,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF0F5A24), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(sub, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCropCheckboxRow({
    required String label,
    required bool checked,
    required TextEditingController controller,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Checkbox(
                  value: checked,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF0F5A24),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: controller,
              enabled: checked,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Acres',
                hintStyle: const TextStyle(fontSize: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
