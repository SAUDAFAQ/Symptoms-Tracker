import 'package:flutter/material.dart';

class CustomSeveritySlider extends StatefulWidget {
  final String label;
  final Function(double) onChanged;

  const CustomSeveritySlider({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  State<CustomSeveritySlider> createState() => _CustomSeveritySliderState();
}

class _CustomSeveritySliderState extends State<CustomSeveritySlider> {
  double _value = 0;

  Color get backgroundColor {
    if (_value <= 0.5) return Colors.grey.shade300;
    if (_value <= 1.5) return Colors.green.shade100;
    if (_value <= 2.5) return Colors.yellow.shade100;
    if (_value <= 3.5) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  Color get indicatorColor {
    if (_value <= 0.5) return Colors.green;
    if (_value <= 1.5) return Colors.green;
    if (_value <= 2.5) return Colors.orange;
    if (_value <= 3.5) return Colors.deepOrange;
    return Colors.red;
  }

  String get severityText {
    if (_value <= 0.5) return "None";
    if (_value <= 1.5) return "Low";
    if (_value <= 2.5) return "Medium";
    if (_value <= 3.5) return "High";
    return "Severe";
  }

  IconData get severityIcon {
    if (_value <= 0.5) return Icons.sentiment_very_satisfied;
    if (_value <= 1.5) return Icons.sentiment_satisfied;
    if (_value <= 2.5) return Icons.sentiment_neutral;
    if (_value <= 3.5) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sliderWidth = screenWidth * 0.8;
    final facePosition = (_value / 4) * sliderWidth;
    
    // Constrain face position to stay within slider bounds
    final constrainedFacePosition = facePosition.clamp(20.0, sliderWidth - 20.0);
    
    // Determine text position based on emoji position
    final isEmojiOnLeftSide = constrainedFacePosition < (sliderWidth / 2);
    final textPosition = isEmojiOnLeftSide 
        ? constrainedFacePosition + 28 // Right side of emoji
        : constrainedFacePosition - 88; // Left side of emoji with more spacing (accounting for text width + distance)
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: sliderWidth,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(24), // Consistent rounded corners
          ),
          clipBehavior: Clip.antiAlias, // Ensure proper clipping for curves
          child: Stack(
            clipBehavior: Clip.none, // Allow elements to extend if needed
            children: [
              // Background progress with proper curve matching emoji position
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                width: constrainedFacePosition.clamp(24.0, sliderWidth), // Ensure minimum width for curve
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24), // Same radius as container
                ),
              ),
              // Severity text with smart positioning
              Positioned(
                left: textPosition.clamp(8.0, sliderWidth - 60.0), // Constrain text within bounds
                top: 12,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: Text(
                    severityText,
                    style: TextStyle(
                      color: indicatorColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Moving face icon - positioned on top
              Positioned(
                left: constrainedFacePosition - 20, // Center the face on the slider position
                top: 4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: Container(
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Icon(severityIcon, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              // Invisible slider for touch interaction
              Positioned.fill(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                    trackHeight: 0,
                    overlayShape: SliderComponentShape.noOverlay,
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: _value,
                    min: 0,
                    max: 4,
                    divisions: null, // Remove divisions for smooth continuous sliding
                    label: severityText,
                    onChanged: (v) {
                      setState(() => _value = v);
                      widget.onChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
