import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:ordo/common/localization/app_localizations.dart';

/// Menu page header: stat badges.
class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key, this.notesCount = '0', this.tasksCount = '0'});

  final String notesCount;
  final String tasksCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatBadge(
            value: notesCount,
            label: AppLocalizations.of(context).translate('notes'),
            shape: MaterialShapes.sunny,
            background: cs.tertiaryContainer,
            foreground: cs.onTertiaryContainer,
            angle: -0.14,
          ),
          _StatBadge(
            value: tasksCount,
            label: AppLocalizations.of(context).translate('tasks'),
            shape: MaterialShapes.cookie9Sided,
            background: cs.primaryContainer,
            foreground: cs.onPrimaryContainer,
            angle: 0.14,
          ),
        ],
      ),
    );
  }
}

/// Tilted shape badge showing one stat: number on top, label under it.
class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  final RoundedPolygon shape;
  final Color background;
  final Color foreground;
  final double angle;

  const _StatBadge({
    required this.value,
    required this.label,
    required this.shape,
    required this.background,
    required this.foreground,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 108,
        height: 108,
        decoration: ShapeDecoration(
          color: background,
          shape: MaterialShapeBorder(shape: shape),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              value,
              style: tt.titleLarge?.copyWith(
                fontFamily: 'Unbounded',
                fontWeight: .w700,
                letterSpacing: -0.5,
                color: foreground,
              ),
            ),
            Text(label, style: tt.labelSmall?.copyWith(color: foreground)),
          ],
        ),
      ),
    );
  }
}
