import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:url_launcher/url_launcher.dart';

/// Floating card with the developer's details, opened from the signature at
/// the bottom of the menu page.
class DeveloperSheet extends StatelessWidget {
  const DeveloperSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet<void>(
      context: context,
      builder: (context) => const DeveloperSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, BottomPadding.of(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            // Concentric with the 28-radius buttons behind 24 padding.
            borderRadius: BorderRadius.circular(52),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                Center(
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: MaterialShapeBorder(shape: MaterialShapes.bun),
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: SmoothImage(url: AppValues.makerImageUrl),
                    ),
                  ),
                ),
                16.gap,
                Text(
                  AppValues.makerName,
                  textAlign: TextAlign.center,
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                16.gap,
                Text(
                  AppLocalizations.of(context).translate('softwareDeveloperBuildingOrdo'),
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                24.gap,
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(textStyle: tt.titleMedium),
                    onPressed: () {
                      launchUrl(
                        Uri.parse(AppValues.makerGithubUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.code_rounded),
                    label: Text(AppLocalizations.of(context).translate('gitHubProfile')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
