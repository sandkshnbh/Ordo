import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ordo/features/menu/widgets/developer_sheet.dart';
import 'package:material_shapes/material_shapes.dart';

/// "Crafted by {bun} Kamran Bekirov" footer; opens the [DeveloperSheet].
class DeveloperSignature extends StatelessWidget {
  const DeveloperSignature({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final TextStyle style = (tt.titleMedium ?? const TextStyle()).copyWith(
      fontFamily: 'Unbounded',
      color: cs.onSurfaceVariant,
    );

    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          DeveloperSheet.show(context);
        },
        child: Container(
          height: 48,
          padding: const .symmetric(horizontal: 40),
          alignment: .center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: .min,
              children: [
                Text(AppLocalizations.of(context).translate('craftedBy'), style: style),
                8.gap,
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: MaterialShapeBorder(shape: MaterialShapes.bun),
                  ),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SmoothImage(url: AppValues.makerImageUrl),
                  ),
                ),
                4.gap,
                Text(AppValues.makerName, style: style),
                4.gap,
                Text(
                  '· ${AppLocalizations.of(context).translate('madeInLibya')} 🇱🇾',
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
