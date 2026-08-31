import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';
import '../models/crop.dart';

class MspInfoScreen extends StatefulWidget {
  final AppState appState;

  const MspInfoScreen({super.key, required this.appState});

  @override
  State<MspInfoScreen> createState() => _MspInfoScreenState();
}

class _MspInfoScreenState extends State<MspInfoScreen> {
  // Pre-load checklist values
  final Map<int, bool> _checklistStates = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
  };

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;

    final List<String> checklistItemsEn = [
      'Clean crops to remove chaff, stones, and dust particles.',
      'Sun-dry the harvest to lower moisture content below the government limit.',
      'Ensure crop is packed in clean, dry, high-quality jute/gunny bags.',
      'Perform sample grading to ensure uniform size, color, and texture.',
      'Verify that you have all documents: Aadhaar card, bank passbook, land details.',
    ];

    final List<String> checklistItemsTa = [
      'பயிர்களில் உள்ள உமி, கல் மற்றும் தூசுகளை அகற்றி சுத்தப்படுத்தவும்.',
      'அரசின் ஈரப்பத வரம்பிற்குள் கொண்டு வர விளைச்சலை வெயிலில் நன்கு காய வைக்கவும்.',
      'விளைபொருட்களை சுத்தமான, உலர்ந்த, நல்ல தரமான சணல்/கோணிப்பைகளில் மூட்டை கட்டவும்.',
      'சீரான அளவு, நிறம் மற்றும் தரத்தை உறுதிப்படுத்த மாதிரி சரிபார்ப்பு செய்யவும்.',
      'ஆவணங்களைச் சரிபார்க்கவும்: ஆதார் அட்டை, வங்கி கணக்கு புத்தகம், நில விவரங்கள்.',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Text(AppTranslations.translate('msp_title', isTamil)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: MSP Price List Header
            Text(
              AppTranslations.translate('msp_rates_header', isTamil),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Crop MSP Details List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Crop.availableCrops.length,
              itemBuilder: (context, index) {
                final crop = Crop.availableCrops[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: crop.color.withOpacity(0.15),
                          radius: 24,
                          child: Icon(crop.iconData, color: crop.color, size: 26),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.translate(crop.nameKey, isTamil),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildQualityMetric(
                                    isTamil ? 'அதிகபட்ச ஈரப்பதம்' : 'Max Moisture',
                                    '${crop.maxMoisture}%',
                                  ),
                                  const SizedBox(width: 15),
                                  _buildQualityMetric(
                                    isTamil ? 'அதிகபட்ச தூசி' : 'Max Foreign Matter',
                                    '${crop.maxTrash}%',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isTamil ? 'குவிண்டால் MSP' : 'MSP per Quintal',
                              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                            ),
                            Text(
                              '₹${crop.mspPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F5A24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Section 2: Quality Inspection Checklist
            Text(
              AppTranslations.translate('quality_checklist', isTamil),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            
            // Guidelines description card
            Card(
              color: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.amber.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTamil ? 'ஏன் தரத்தை பராமரிக்க வேண்டும்?' : 'Why Quality Matters?',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppTranslations.translate('guideline_moisture', isTamil),
                                style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.4),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppTranslations.translate('guideline_foreign', isTamil),
                                style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Checklist Card List
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: List.generate(5, (index) {
                    final itemText = isTamil ? checklistItemsTa[index] : checklistItemsEn[index];
                    final isChecked = _checklistStates[index] ?? false;

                    return CheckboxListTile(
                      activeColor: const Color(0xFF0F5A24),
                      title: Text(
                        itemText,
                        style: TextStyle(
                          fontSize: 12,
                          color: isChecked ? Colors.grey : Colors.black87,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (val) {
                        setState(() {
                          _checklistStates[index] = val ?? false;
                        });
                      },
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}
