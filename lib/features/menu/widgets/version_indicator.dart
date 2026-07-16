import 'package:ordo/common/common.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Dimmed "AppName version (build)" line for the bottom of the menu page, so
/// anyone can verify which build is installed. Renders nothing while the
/// platform info loads.
class VersionIndicator extends StatefulWidget {
  const VersionIndicator({super.key, this.showCircle = true});

  final bool showCircle;

  @override
  State<VersionIndicator> createState() => _VersionIndicatorState();
}

class _VersionIndicatorState extends State<VersionIndicator> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() {
          _info = info;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PackageInfo? info = _info;
    if (info == null) return const SizedBox.shrink();

    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Column(
      children: [
        if (widget.showCircle)
          Icon(Icons.circle_rounded, size: 24, color: cs.outline),
        if (widget.showCircle) 8.gap,
        Text(
          '${AppValues.title} ${info.version} (${info.buildNumber})',
          textAlign: .center,
          style: tt.labelSmall?.copyWith(
            color: cs.outline,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
