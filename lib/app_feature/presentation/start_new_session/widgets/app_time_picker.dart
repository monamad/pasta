import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey),
            SizedBox(width: 12.w),
            Text(
              _selectedTime != null
                  ? _selectedTime.format(context)
                  : 'Select time',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
