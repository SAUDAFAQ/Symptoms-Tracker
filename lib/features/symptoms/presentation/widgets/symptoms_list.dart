import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/symptom.dart';
import '../cubit/symptom_cubit.dart';
import '../cubit/symptom_state.dart';

class SymptomsList extends StatelessWidget {
  const SymptomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymptomCubit, SymptomState>(
      builder: (context, state) {
        if (state is SymptomLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SymptomLoaded) {
          if (state.symptoms.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No symptoms recorded for this date',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: state.symptoms.length,
            itemBuilder: (context, index) {
              final symptom = state.symptoms[index];
              return SymptomCard(
                symptom: symptom,
                onDelete: () => _deleteSymptom(context, symptom.id),
              );
            },
          );
        } else if (state is SymptomError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<SymptomCubit>().loadSymptoms(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  void _deleteSymptom(BuildContext context, String symptomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Symptom'),
        content: const Text('Are you sure you want to delete this symptom?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SymptomCubit>().deleteSymptom(symptomId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final Symptom symptom;
  final VoidCallback onDelete;

  const SymptomCard({
    super.key,
    required this.symptom,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSeverityColor(symptom.severity),
          child: Text(
            symptom.severity.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          symptom.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Severity: ${_getSeverityText(symptom.severity)}'),
            Text('Date: ${_formatDate(symptom.date)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1:
        return 'Very Mild';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Severe';
      case 5:
        return 'Very Severe';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
