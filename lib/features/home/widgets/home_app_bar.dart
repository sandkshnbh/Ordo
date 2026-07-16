import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_shapes/material_shapes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onMenuTap, this.onSearchTap});

  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: SvgPicture.asset(
        'assets/SK/ordo.svg',
        height: 64,
        colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
      ),
      actions: [
        Tooltip(
          message: 'Chats',
          child: IconButton(
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 24,
              color: cs.onSurfaceVariant,
            ),
            onPressed: onSearchTap,
          ),
        ),
        Tooltip(
          message: 'Menu',
          child: Material(
            color: cs.secondaryContainer,
            shape: MaterialShapeBorder(shape: MaterialShapes.pill),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onMenuTap,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(child: Icon(Icons.menu_rounded, size: 24)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
