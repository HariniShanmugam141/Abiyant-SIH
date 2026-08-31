import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../models/booking.dart';
import '../utils/translations.dart';

class AppState extends ChangeNotifier {
  bool _isTamil = false;
  bool _isAuthenticated = false;
  String _mobileNumber = '';
  
  // List of bookings (includes completed history and current active bookings)
  final List<Booking> _bookings = [];
  
  // List of notifications
  final List<AppNotification> _notifications = [];

  AppState() {
    // Populate with some dummy historical bookings for demo
    _bookings.add(
      Booking(
        tokenNumber: 'ABY-2026-7241',
        cropType: CropType.wheat,
        quantity: 25.5,
        center: ProcurementCenter.availableCenters[0],
        dateTime: DateTime.now().subtract(const Duration(days: 15)),
        status: BookingStatus.paymentCompleted,
        grossWeight: 4050.0,
        tareWeight: 1500.0,
        netWeight: 2550.0, // 25.5 quintals
        moistureContent: 12.8,
        trashContent: 1.0,
        payoutAmount: 25.5 * 2425.0, // Quantity * Wheat MSP
        paymentReference: 'TXN8263152731',
        queuePosition: 0,
      ),
    );

    _bookings.add(
      Booking(
        tokenNumber: 'ABY-2026-8910',
        cropType: CropType.cotton,
        quantity: 12.0,
        center: ProcurementCenter.availableCenters[1],
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        status: BookingStatus.billing,
        grossWeight: 2700.0,
        tareWeight: 1500.0,
        netWeight: 1200.0, // 12.0 quintals
        moistureContent: 11.2,
        trashContent: 3.1,
        payoutAmount: 12.0 * 7121.0, // Quantity * Cotton MSP
        queuePosition: 0,
      ),
    );

    // Initial dummy notifications
    _notifications.add(
      AppNotification(
        id: 'n1',
        message: 'Your payment of ₹61,837.50 for Wheat booking ABY-2026-7241 has been credited to your bank account via DBT.',
        messageTamil: 'கோதுமை முன்பதிவு ABY-2026-7241க்கான உங்களின் ₹61,837.50 கட்டணம் DBT மூலம் உங்கள் வங்கிக் கணக்கில் செலுத்தப்பட்டது.',
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
      ),
    );

    _notifications.add(
      AppNotification(
        id: 'n2',
        message: 'Quality check approved for Cotton booking ABY-2026-8910. Moisture level: 11.2%. Invoice is being generated.',
        messageTamil: 'பருத்தி முன்பதிவு ABY-2026-8910க்கான தரச் சோதனை அங்கீகரிக்கப்பட்டது. ஈரப்பதம்: 11.2%. விலைப்பட்டியல் தயாரிக்கப்படுகிறது.',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
      ),
    );
  }

  // Getters
  bool get isTamil => _isTamil;
  bool get isAuthenticated => _isAuthenticated;
  String get mobileNumber => _mobileNumber;
  List<Booking> get bookings => _bookings;
  List<AppNotification> get notifications => _notifications;
  
  // Find active booking (the one that is not fully paid/completed yet)
  Booking? get activeBooking {
    try {
      return _bookings.firstWhere((b) => b.status != BookingStatus.paymentCompleted);
    } catch (_) {
      return null;
    }
  }

  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  // Actions
  void setLanguage(bool isTamilVal) {
    _isTamil = isTamilVal;
    notifyListeners();
  }

  void login(String mobile) {
    _mobileNumber = mobile;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _mobileNumber = '';
    notifyListeners();
  }

  // Create a new booking
  String createBooking(CropType cropType, double quantity, ProcurementCenter center, DateTime dateTime) {
    // Generate a random token number
    final int rand = 1000 + (DateTime.now().millisecond % 9000);
    final String token = 'ABY-2026-$rand';
    
    final newBooking = Booking(
      tokenNumber: token,
      cropType: cropType,
      quantity: quantity,
      center: center,
      dateTime: dateTime,
      status: BookingStatus.booked,
      queuePosition: 12, // Default starts at 12 vehicles ahead
    );

    _bookings.insert(0, newBooking); // Insert at beginning of list

    addNotification(
      'New slot booking confirmed for ${Crop.getByType(cropType).type.name.toUpperCase()} at ${center.name}. Token: $token.',
      '${center.nameTamil} இல் ${AppTranslations.translate(Crop.getByType(cropType).nameKey, true)}க்கான புதிய முன்பதிவு உறுதியானது. டோக்கன்: $token.',
    );

    notifyListeners();
    return token;
  }

  void markNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(String en, String ta) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: en,
        messageTamil: ta,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // Simulator actions
  void advanceQueue() {
    final active = activeBooking;
    if (active == null) return;

    if (active.queuePosition > 0) {
      active.queuePosition--;
      
      if (active.queuePosition == 0) {
        // Trigger arrival automatic check-in
        active.status = BookingStatus.checkedIn;
        addNotification(
          'Your vehicle with Token ${active.tokenNumber} has reached the gate. Auto checked-in at ${active.center.name}. Proceed to Weigh Bridge.',
          'டோக்கன் ${active.tokenNumber} கொண்ட உங்கள் வாகனம் கேட்டை அடைந்தது. ${active.center.nameTamil} இல் தானியங்கி செக்-இன் செய்யப்பட்டது. எடை மேடைக்குச் செல்லவும்.',
        );
      } else {
        addNotification(
          'Queue updated for Token ${active.tokenNumber}. You are now position #${active.queuePosition} in line.',
          'டோக்கன் ${active.tokenNumber}க்கான வரிசை புதுப்பிக்கப்பட்டது. நீங்கள் தற்போது ${active.queuePosition} வது இடத்தில் உள்ளீர்கள்.',
        );
      }
    } else if (active.status == BookingStatus.checkedIn) {
      // If at gate and queue is 0, next step is weighing
      active.progressStatus();
      addNotification(
        'Weighment completed for Token ${active.tokenNumber}. Gross: ${active.grossWeight} kg, Net: ${active.netWeight} kg.',
        'டோக்கன் ${active.tokenNumber}க்கான எடை சரிபார்க்கப்பட்டது. மொத்த எடை: ${active.grossWeight} கிலோ, நிகர எடை: ${active.netWeight} கிலோ.',
      );
    }
    
    notifyListeners();
  }

  void advancePaymentStep() {
    final active = activeBooking;
    if (active == null) return;

    if (active.queuePosition > 0 && active.status == BookingStatus.booked) {
      // Force skip queue for demo purposes
      active.queuePosition = 0;
      active.status = BookingStatus.checkedIn;
      addNotification(
        'Demo Mode: Queue skipped. Vehicle checked-in at gate for Token ${active.tokenNumber}.',
        'டெமோ முறை: வரிசை தவிர்க்கப்பட்டது. டோக்கன் ${active.tokenNumber}க்கு கேட்டில் செக்-இன் செய்யப்பட்டது.',
      );
      notifyListeners();
      return;
    }

    active.progressStatus();

    // Send notifications based on the new status
    switch (active.status) {
      case BookingStatus.checkedIn:
        addNotification(
          'Checked-in at gate for Token ${active.tokenNumber}. Please move to the weigh bridge.',
          'டோக்கன் ${active.tokenNumber}க்கு கேட்டில் செக்-இன் செய்யப்பட்டது. எடை மேடைக்குச் செல்லவும்.',
        );
        break;
      case BookingStatus.weighed:
        addNotification(
          'Weighment completed for Token ${active.tokenNumber}. Gross Weight: ${active.grossWeight} kg. Proceed to quality testing bay.',
          'டோக்கன் ${active.tokenNumber}க்கான எடை சரிபார்க்கப்பட்டது. மொத்த எடை: ${active.grossWeight} கிலோ. தர சோதனை பகுதிக்குச் செல்லவும்.',
        );
        break;
      case BookingStatus.qualityApproved:
        addNotification(
          'Quality check approved for Token ${active.tokenNumber}. Moisture: ${active.moistureContent}%, Trash: ${active.trashContent}%.',
          'டோக்கன் ${active.tokenNumber}க்கான தரச் சோதனை அங்கீகரிக்கப்பட்டது. ஈரப்பதம்: ${active.moistureContent}%, கழிவு: ${active.trashContent}%.',
        );
        break;
      case BookingStatus.billing:
        addNotification(
          'Billing generated for Token ${active.tokenNumber}. Purchase amount: ₹${active.payoutAmount?.toStringAsFixed(2)}. Approved for payment.',
          'டோக்கன் ${active.tokenNumber}க்கு பில் உருவாக்கப்பட்டது. கொள்முதல் தொகை: ₹${active.payoutAmount?.toStringAsFixed(2)}. கட்டண ஒப்புதல் வழங்கப்பட்டது.',
        );
        break;
      case BookingStatus.paymentInitiated:
        addNotification(
          'Payment of ₹${active.payoutAmount?.toStringAsFixed(2)} initiated for Token ${active.tokenNumber}. Ref ID: ${active.paymentReference}.',
          'டோக்கன் ${active.tokenNumber}க்கு ₹${active.payoutAmount?.toStringAsFixed(2)} கட்டணம் தொடங்கப்பட்டது. குறிப்பு எண்: ${active.paymentReference}.',
        );
        break;
      case BookingStatus.paymentCompleted:
        addNotification(
          'DBT Payment of ₹${active.payoutAmount?.toStringAsFixed(2)} credited successfully to your registered bank account for Token ${active.tokenNumber}.',
          'டோக்கன் ${active.tokenNumber}க்கு ₹${active.payoutAmount?.toStringAsFixed(2)} நேரடி பலன் பரிமாற்றம் (DBT) வெற்றிகரமாக உங்களது வங்கி கணக்கில் செலுத்தப்பட்டது.',
        );
        break;
      default:
        break;
    }

    notifyListeners();
  }

  void cancelActiveBooking() {
    final active = activeBooking;
    if (active == null) return;
    
    _bookings.remove(active);
    addNotification(
      'Booking with Token ${active.tokenNumber} has been cancelled.',
      'டோக்கன் ${active.tokenNumber} உடனான முன்பதிவு ரத்து செய்யப்பட்டது.',
    );
    notifyListeners();
  }
}
