import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final Color? primaryColor;
  final Color? backgroundColor;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    this.onTimeSelected,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker>
    with SingleTickerProviderStateMixin {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;
  bool _isSelectingHour = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    final initialTime = widget.initialTime ?? TimeOfDay.now();
    _selectedHour = initialTime.hourOfPeriod == 0
        ? 12
        : initialTime.hourOfPeriod;
    _selectedMinute = initialTime.minute;
    _isAM = initialTime.period == DayPeriod.am;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePeriod() {
    setState(() {
      _isAM = !_isAM;
      _notifyTimeChange();
    });
  }

  void _toggleSelection() {
    setState(() {
      _isSelectingHour = !_isSelectingHour;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _notifyTimeChange() {
    if (widget.onTimeSelected != null) {
      int hour24 = _selectedHour == 12 ? 0 : _selectedHour;
      if (!_isAM) hour24 += 12;
      widget.onTimeSelected!(TimeOfDay(hour: hour24, minute: _selectedMinute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time Display Header
          _buildTimeDisplay(theme, primaryColor),
          const SizedBox(height: 32),
          // Clock Face
          ScaleTransition(
            scale: _scaleAnimation,
            child: _buildClockFace(theme, primaryColor),
          ),
          const SizedBox(height: 24),
          // AM/PM Toggle
          _buildPeriodToggle(theme, primaryColor),
          const SizedBox(height: 16),
          // Action Buttons
          _buildActionButtons(theme, primaryColor),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(ThemeData theme, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeUnit(
          value: _selectedHour.toString().padLeft(2, '0'),
          isSelected: _isSelectingHour,
          primaryColor: primaryColor,
          onTap: () {
            if (!_isSelectingHour) _toggleSelection();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            ':',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        _buildTimeUnit(
          value: _selectedMinute.toString().padLeft(2, '0'),
          isSelected: !_isSelectingHour,
          primaryColor: primaryColor,
          onTap: () {
            if (_isSelectingHour) _toggleSelection();
          },
        ),
      ],
    );
  }

  Widget _buildTimeUnit({
    required String value,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: isSelected ? primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildClockFace(ThemeData theme, Color primaryColor) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // Clock Circle
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
            ),
          ),
          // Clock Numbers
          ..._buildClockNumbers(theme, primaryColor),
        ],
      ),
    );
  }

  List<Widget> _buildClockNumbers(ThemeData theme, Color primaryColor) {
    final List<Widget> numbers = [];
    final int maxValue = _isSelectingHour ? 12 : 60;
    final int step = _isSelectingHour ? 1 : 5;

    for (int i = 0; i < maxValue; i += step) {
      final int displayValue = _isSelectingHour ? (i == 0 ? 12 : i) : i;
      final double angle = (i * 360 / maxValue - 90) * math.pi / 180;
      final double radius = 110;
      final double x = 140 + radius * math.cos(angle);
      final double y = 140 + radius * math.sin(angle);

      final bool isSelected = _isSelectingHour
          ? displayValue == _selectedHour
          : i == _selectedMinute;

      numbers.add(
        Positioned(
          left: x - 20,
          top: y - 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_isSelectingHour) {
                  _selectedHour = displayValue;
                } else {
                  _selectedMinute = i;
                }
                _notifyTimeChange();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryColor : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  displayValue.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return numbers;
  }

  Widget _buildPeriodToggle(ThemeData theme, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPeriodButton('AM', _isAM, primaryColor, theme),
          _buildPeriodButton('PM', !_isAM, primaryColor, theme),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    String label,
    bool isSelected,
    Color primaryColor,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        if ((label == 'AM' && !_isAM) || (label == 'PM' && _isAM)) {
          _togglePeriod();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _notifyTimeChange();
            if (!mounted) return;
            DateTime now = DateTime.now();

            DateTime selectedDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              _selectedHour == 12
                  ? (_isAM ? 0 : 12)
                  : (_isAM ? _selectedHour : _selectedHour + 12),
              _selectedMinute,
            );
            if (selectedDateTime.isBefore(now)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a future time.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            Navigator.of(context).pop(
              TimeOfDay(
                hour: _isAM
                    ? (_selectedHour == 12 ? 0 : _selectedHour)
                    : (_selectedHour == 12 ? 12 : _selectedHour + 12),
                minute: _selectedMinute,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// Helper function to show the time picker
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
  Color? primaryColor,
  Color? backgroundColor,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: CustomTimePicker(
        initialTime: initialTime,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
    ),
  );
}
