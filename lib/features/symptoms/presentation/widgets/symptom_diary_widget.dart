import 'package:flutter/material.dart';
import 'custom_severity_slider.dart';

class SymptomDiaryWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, bool> selectedSymptoms;
  final Map<String, String> symptomSeverity;
  final Function(String, bool) onSymptomSelected;
  final Function(String, String) onSeverityChanged;
  final VoidCallback onSave;
  final bool showSaveButton;

  const SymptomDiaryWidget({
    super.key,
    required this.selectedDate,
    required this.selectedSymptoms,
    required this.symptomSeverity,
    required this.onSymptomSelected,
    required this.onSeverityChanged,
    required this.onSave,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Skin section
          _buildSkinSection(),
          const SizedBox(height: 30),
          // Hair section
          _buildHairSection(),
          if (showSaveButton) ...[
            const SizedBox(height: 40),
            // Save button
            _buildSaveButton(),
            const SizedBox(height: 30),
          ],
        ],
      ),
    );
  }

  Widget _buildSkinSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSymptomButton(
              'Dry',
              'dry',
              selectedSymptoms['dry'] ?? false,
            ),
            const SizedBox(width: 12),
            _buildSymptomButton(
              'Itchy',
              'itchy',
              selectedSymptoms['itchy'] ?? false,
            ),
          ],
        ),
        // Skin dryness slider (appears when dry is selected)
        if (selectedSymptoms['dry'] == true) ...[
          const SizedBox(height: 20),
          _buildSeveritySlider(
            'Skin dryness',
            'dry',
            symptomSeverity['dry'] ?? 'None',
          ),
        ],
        // Itchiness intensity slider (appears when itchy is selected)
        if (selectedSymptoms['itchy'] == true) ...[
          const SizedBox(height: 20),
          _buildSeveritySlider(
            'Itchiness intensity',
            'itchy',
            symptomSeverity['itchy'] ?? 'None',
          ),
        ],
      ],
    );
  }

  Widget _buildHairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hair',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSymptomButton(
              'Hair loss',
              'hair_loss',
              selectedSymptoms['hair_loss'] ?? false,
            ),
          ],
        ),
        // Hair loss intensity slider (appears when hair_loss is selected)
        if (selectedSymptoms['hair_loss'] == true) ...[
          const SizedBox(height: 20),
          _buildSeveritySlider(
            'Hair loss intensity',
            'hair_loss',
            symptomSeverity['hair_loss'] ?? 'None',
          ),
        ],
      ],
    );
  }

  Widget _buildSymptomButton(String text, String key, bool isSelected) {
    return GestureDetector(
      onTap: () => onSymptomSelected(key, !isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF3B82F6),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF1E3A8A),
          ),
        ),
      ),
    );
  }

  Widget _buildSeveritySlider(String title, String key, String currentSeverity) {
    return CustomSeveritySlider(
      label: title,
      onChanged: (value) {
        String severity;
        if (value == 0) {
          severity = 'None';
        } else if (value == 1) {
          severity = 'Low';
        } else if (value == 2) {
          severity = 'Medium';
        } else if (value == 3) {
          severity = 'High';
        } else {
          severity = 'Severe';
        }
        
        onSeverityChanged(key, severity);
      },
    );
  }


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
