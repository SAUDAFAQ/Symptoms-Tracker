import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/symptom_cubit.dart';
import '../cubit/symptom_state.dart';
import '../widgets/symptom_diary_widget.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  DateTime _selectedDate = DateTime.now();
  Map<String, bool> _selectedSymptoms = {
    'dry': false,
    'itchy': false,
    'hair_loss': false,
  };
  Map<String, String> _symptomSeverity = {
    'dry': 'None',
    'itchy': 'None',
    'hair_loss': 'None',
  };

  @override
  void initState() {
    super.initState();
    // Set current date as selected by default
    _selectedDate = DateTime.now();
    // Load symptoms for today when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomCubit>().loadSymptomsByDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar area
            Container(
              height: 20,
              color: Colors.white,
            ),
            // Header with X and calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Today: ${_formatDate(_selectedDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openCalendar,
                    child: const Icon(Icons.calendar_today, color: Colors.black, size: 24),
                  ),
                ],
              ),
            ),
            // Date selector with horizontal scroll
            _buildDateSelector(),
            // Symptom diary title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Symptom diary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 203, 138, 39),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: BlocListener<SymptomCubit, SymptomState>(
                listener: (context, state) {
                  if (state is SymptomValidationError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else if (state is SymptomSaveSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    // Reset selections after successful save
                    setState(() {
                      _selectedSymptoms = {
                        'dry': false,
                        'itchy': false,
                        'hair_loss': false,
                      };
                      _symptomSeverity = {
                        'dry': 'None',
                        'itchy': 'None',
                        'hair_loss': 'None',
                      };
                    });
                  } else if (state is SymptomError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  child: SymptomDiaryWidget(
                    selectedDate: _selectedDate,
                    selectedSymptoms: _selectedSymptoms,
                    symptomSeverity: _symptomSeverity,
                    onSymptomSelected: _onSymptomSelected,
                    onSeverityChanged: _onSeverityChanged,
                    onSave: _onSave,
                    showSaveButton: false, // Don't show save button in widget
                  ),
                ),
              ),
            ),
            // Save button - always stick to bottom
            Container(
              padding: const EdgeInsets.all(20),
              child: _buildSaveButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    // Generate dates centered around selected date
    final dates = List.generate(7, (index) => _selectedDate.subtract(Duration(days: 3 - index)));
    
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dates.map((date) {
            final isSelected = date.day == _selectedDate.day && 
                             date.month == _selectedDate.month && 
                             date.year == _selectedDate.year;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                context.read<SymptomCubit>().loadSymptomsByDate(_selectedDate);
              },
              child: Container(
                width: 50,
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getDayName(date.weekday),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _openCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<SymptomCubit>().loadSymptomsByDate(_selectedDate);
    }
  }

  void _onSymptomSelected(String symptom, bool isSelected) {
    setState(() {
      _selectedSymptoms[symptom] = isSelected;
      if (isSelected) {
        // When selecting a symptom, set default severity to 'Low'
        _symptomSeverity[symptom] = 'Low';
      } else {
        // When deselecting, reset to 'None'
        _symptomSeverity[symptom] = 'None';
      }
    });
  }

  void _onSeverityChanged(String symptom, String severity) {
    setState(() {
      _symptomSeverity[symptom] = severity;
    });
  }

  void _onSave() {
    context.read<SymptomCubit>().saveSymptoms(
      selectedSymptoms: _selectedSymptoms,
      symptomSeverity: _symptomSeverity,
      date: _selectedDate,
    );
  }


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _onSave,
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
