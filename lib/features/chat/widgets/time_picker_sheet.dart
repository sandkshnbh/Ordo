import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';

class TimePickerSheet extends StatefulWidget {
  const TimePickerSheet({super.key});

  static Future<TimeOfDay?> show(BuildContext context) {
    return showExpressiveSheet<TimeOfDay>(
      context: context,
      builder: (context) => const TimePickerSheet(),
    );
  }

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, BottomPadding.of(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(52),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  8.gap,
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: cs.tertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alarm_rounded,
                      size: 32,
                      color: cs.onTertiaryContainer,
                    ),
                  ).animate().scale(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                  ),
                  16.gap,
                  Text(
                    AppLocalizations.of(context).translate('setReminderTitle'),
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
                  8.gap,
                  Text(
                    AppLocalizations.of(context).translate('setReminderMessage'),
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 150)),
                  24.gap,
                  _buildTimePicker(cs, tt),
                  24.gap,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('skip'),
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _selectedTime != null
                              ? () => Navigator.pop(context, _selectedTime)
                              : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: cs.tertiary,
                            foregroundColor: cs.onTertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('setReminderButton'),
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeColumn(
                cs: cs,
                tt: tt,
                values: List.generate(12, (i) => i + 1),
                selectedValue: _selectedTime?.hour,
                isHour: true,
              ),
              Text(
                ':',
                style: tt.displayLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w300,
                ),
              ),
              _buildTimeColumn(
                cs: cs,
                tt: tt,
                values: List.generate(60, (i) => i),
                selectedValue: _selectedTime?.minute,
                isHour: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['AM', 'PM'].map((period) {
              final isSelected =
                  _selectedTime != null &&
                  ((period == 'AM' && _selectedTime!.period == DayPeriod.am) ||
                      (period == 'PM' &&
                          _selectedTime!.period == DayPeriod.pm));
              return GestureDetector(
                onTap: () {
                  if (_selectedTime == null) return;
                  final hour = period == 'AM'
                      ? (_selectedTime!.hour % 12)
                      : (_selectedTime!.hour % 12) + 12;
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: hour,
                      minute: _selectedTime!.minute,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.tertiaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    period,
                    style: tt.titleLarge?.copyWith(
                      color: isSelected
                          ? cs.onTertiaryContainer
                          : cs.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  Widget _buildTimeColumn({
    required ColorScheme cs,
    required TextTheme tt,
    required List<int> values,
    required int? selectedValue,
    required bool isHour,
  }) {
    return SizedBox(
      height: 150,
      width: 60,
      child: ListWheelScrollView(
        itemExtent: 40,
        onSelectedItemChanged: (index) {
          setState(() {
            final hour = isHour ? values[index] : (_selectedTime?.hour ?? 12);
            final minute = isHour
                ? (_selectedTime?.minute ?? 0)
                : values[index];
            _selectedTime = TimeOfDay(hour: hour, minute: minute);
          });
        },
        controller: FixedExtentScrollController(
          initialItem: selectedValue != null
              ? values.indexOf(selectedValue)
              : 0,
        ),
        physics: const FixedExtentScrollPhysics(),
        children: List.generate(values.length, (index) {
          final value = values[index];
          final isSelected = selectedValue == value;
          return Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: tt.headlineMedium?.copyWith(
                color: isSelected ? cs.tertiary : cs.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }
}
