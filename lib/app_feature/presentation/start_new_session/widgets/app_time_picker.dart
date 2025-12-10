
import 'package:flutter/material.dart';

class AppTimePicker extends StatelessWidget {
  const AppTimePicker({
    super.key,
    required TimeOfDay? selectedTime,
    required Future<void> Function() onTap,
  }) : _selectedTime = selectedTime,
       _onTap = onTap;

  final TimeOfDay? _selectedTime;
  final Future<void> Function() _onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              _selectedTime != null
                  ? _selectedTime.format(context)
                  : 'Select time',
              style: TextStyle(
                fontSize: 16,
                color: _selectedTime != null
                    ? Colors.black
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}