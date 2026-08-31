import 'package:flutter/material.dart';

enum CropType {
  paddy,
  wheat,
  maize,
  cotton,
  sugarcane,
  pulses,
}

class Crop {
  final CropType type;
  final String nameKey;
  final double mspPrice; // per Quintal in INR
  final double maxMoisture; // maximum acceptable moisture percentage
  final double maxTrash; // maximum foreign matter/trash percentage
  final IconData iconData;
  final Color color;

  const Crop({
    required this.type,
    required this.nameKey,
    required this.mspPrice,
    required this.maxMoisture,
    required this.maxTrash,
    required this.iconData,
    required this.color,
  });

  static const List<Crop> availableCrops = [
    Crop(
      type: CropType.paddy,
      nameKey: 'crop_paddy',
      mspPrice: 2300.00,
      maxMoisture: 17.0,
      maxTrash: 2.0,
      iconData: Icons.grass,
      color: Colors.amber,
    ),
    Crop(
      type: CropType.wheat,
      nameKey: 'crop_wheat',
      mspPrice: 2425.00,
      maxMoisture: 14.0,
      maxTrash: 1.5,
      iconData: Icons.grain,
      color: Colors.orange,
    ),
    Crop(
      type: CropType.maize,
      nameKey: 'crop_maize',
      mspPrice: 2225.00,
      maxMoisture: 15.0,
      maxTrash: 2.0,
      iconData: Icons.compost,
      color: Colors.yellow,
    ),
    Crop(
      type: CropType.cotton,
      nameKey: 'crop_cotton',
      mspPrice: 7121.00,
      maxMoisture: 12.0,
      maxTrash: 4.0,
      iconData: Icons.eco,
      color: Colors.blueGrey,
    ),
    Crop(
      type: CropType.sugarcane,
      nameKey: 'crop_sugarcane',
      mspPrice: 340.00, // per quintal (commonly calculated in INR/quintal as FRP)
      maxMoisture: 10.0, // not generally moisture graded but standard trash limits apply
      maxTrash: 1.0,
      iconData: Icons.nature,
      color: Colors.green,
    ),
    Crop(
      type: CropType.pulses,
      nameKey: 'crop_pulses',
      mspPrice: 7400.00,
      maxMoisture: 12.0,
      maxTrash: 2.0,
      iconData: Icons.category,
      color: Colors.brown,
    ),
  ];

  static Crop getByType(CropType type) {
    return availableCrops.firstWhere((crop) => crop.type == type);
  }
}
