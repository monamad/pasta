import 'package:flutter/material.dart';

enum SessionType { hourly, open }

class SessionTypeSelector extends StatelessWidget {
  final SessionType selectedType;
  final ValueChanged<SessionType> onTypeChanged;

  const SessionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _SessionTypeButton(
            icon: Icons.access_time,
            label: 'Hourly',
            isSelected: selectedType == SessionType.hourly,
            onTap: () => onTypeChanged(SessionType.hourly),
            theme: theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SessionTypeButton(
            icon: Icons.all_inclusive,
            label: 'Open',
            isSelected: selectedType == SessionType.open,
            onTap: () => onTypeChanged(SessionType.open),
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _SessionTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _SessionTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
