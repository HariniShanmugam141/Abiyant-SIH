import 'crop.dart';

class ProcurementCenter {
  final String id;
  final String name;
  final String nameTamil;
  final String location;
  final String locationTamil;
  final String congestionLevel; // 'low', 'medium', 'high'
  final int averageWaitTime; // in minutes

  const ProcurementCenter({
    required this.id,
    required this.name,
    required this.nameTamil,
    required this.location,
    required this.locationTamil,
    required this.congestionLevel,
    required this.averageWaitTime,
  });

  static const List<ProcurementCenter> availableCenters = [
    ProcurementCenter(
      id: 'c1',
      name: 'Thanjavur Co-operative Center',
      nameTamil: 'தஞ்சாவூர் கூட்டுறவு மையம்',
      location: 'Thanjavur Bypass, Tamil Nadu',
      locationTamil: 'தஞ்சாவூர் பைபாஸ், தமிழ்நாடு',
      congestionLevel: 'low',
      averageWaitTime: 15,
    ),
    ProcurementCenter(
      id: 'c2',
      name: 'Trichy APMC Market Yard',
      nameTamil: 'திருச்சி APMC சந்தை முற்றம்',
      location: 'Gandhi Market, Trichy, Tamil Nadu',
      locationTamil: 'காந்தி சந்தை, திருச்சி, தமிழ்நாடு',
      congestionLevel: 'medium',
      averageWaitTime: 45,
    ),
    ProcurementCenter(
      id: 'c3',
      name: 'Coimbatore District Procurement Office',
      nameTamil: 'கோயம்புத்தூர் மாவட்ட கொள்முதல் அலுவலகம்',
      location: 'Pollachi Road, Coimbatore, Tamil Nadu',
      locationTamil: 'பொள்ளாச்சி சாலை, கோயம்புத்தூர், தமிழ்நாடு',
      congestionLevel: 'high',
      averageWaitTime: 120,
    ),
    ProcurementCenter(
      id: 'c4',
      name: 'Madurai Agriculture Mandi',
      nameTamil: 'மதுரை விவசாய மண்டி',
      location: 'Mattuthavani, Madurai, Tamil Nadu',
      locationTamil: 'மாட்டுத்தாவணி, மதுரை, தமிழ்நாடு',
      congestionLevel: 'low',
      averageWaitTime: 10,
    ),
    ProcurementCenter(
      id: 'c5',
      name: 'Salem Direct Purchase Center (DPC)',
      nameTamil: 'சேலம் நேரடி கொள்முதல் நிலையம்',
      location: 'Attur Main Road, Salem, Tamil Nadu',
      locationTamil: 'ஆத்தூர் மெயின் ரோடு, சேலம், தமிழ்நாடு',
      congestionLevel: 'medium',
      averageWaitTime: 30,
    ),
  ];
}

enum BookingStatus {
  booked,
  checkedIn,
  weighed,
  qualityApproved,
  billing,
  paymentInitiated,
  paymentCompleted,
}

class Booking {
  final String tokenNumber;
  final CropType cropType;
  final double quantity; // in quintals
  final ProcurementCenter center;
  final DateTime dateTime;
  BookingStatus status;
  
  // Weights (filled in later stages of simulated flow)
  double? grossWeight;
  double? tareWeight;
  double? netWeight;
  
  // Quality Check results
  double? moistureContent;
  double? trashContent;
  
  // Payment results
  double? payoutAmount;
  String? paymentReference;
  
  // Live Queue Information
  int queuePosition; // vehicles ahead

  Booking({
    required this.tokenNumber,
    required this.cropType,
    required this.quantity,
    required this.center,
    required this.dateTime,
    this.status = BookingStatus.booked,
    this.grossWeight,
    this.tareWeight,
    this.netWeight,
    this.moistureContent,
    this.trashContent,
    this.payoutAmount,
    this.paymentReference,
    required this.queuePosition,
  });

  // Helper to progress to next stage
  void progressStatus() {
    switch (status) {
      case BookingStatus.booked:
        status = BookingStatus.checkedIn;
        break;
      case BookingStatus.checkedIn:
        status = BookingStatus.weighed;
        grossWeight = (quantity * 100) + 1500; // gross weight is net + tare (truck weight)
        tareWeight = 1500.0; // truck weight 1500 kg
        netWeight = grossWeight! - tareWeight!;
        break;
      case BookingStatus.weighed:
        status = BookingStatus.qualityApproved;
        final crop = Crop.getByType(cropType);
        moistureContent = crop.maxMoisture - 1.5; // passes test
        trashContent = crop.maxTrash - 0.5; // passes test
        break;
      case BookingStatus.qualityApproved:
        status = BookingStatus.billing;
        final crop = Crop.getByType(cropType);
        payoutAmount = quantity * crop.mspPrice;
        break;
      case BookingStatus.billing:
        status = BookingStatus.paymentInitiated;
        paymentReference = 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
        break;
      case BookingStatus.paymentInitiated:
        status = BookingStatus.paymentCompleted;
        break;
      case BookingStatus.paymentCompleted:
        // Already at end
        break;
    }
  }

  // Helper to get step index (0 to 6)
  int get currentStepIndex {
    return status.index;
  }
}

class AppNotification {
  final String id;
  final String message;
  final String messageTamil;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.message,
    required this.messageTamil,
    required this.timestamp,
    this.isRead = false,
  });
}
