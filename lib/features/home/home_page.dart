import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ordo/features/chat/widgets/floating_compose_button.dart';
import 'package:ordo/features/chat/widgets/chat_message_list.dart';
import 'package:ordo/features/chat/pages/chats_list_page.dart';
import 'package:ordo/features/home/widgets/home_app_bar.dart';
import 'package:ordo/features/menu/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;

  static const SpringDescription _springDesc = SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_drawerController.isDismissed) {
      final spring = SpringSimulation(_springDesc, 0, 1, 0);
      _drawerController.animateWith(spring);
    } else {
      _drawerController.reverse();
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Main screen — English-style layout, Arabic text
          Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              backgroundColor: cs.surface,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: HomeAppBar(
                  onMenuTap: _openSettings,
                  onSearchTap: _toggleDrawer,
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: ChatMessageList()
                        .animate()
                        .fadeIn(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        )
                        .slideY(begin: 0.1, end: 0),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24,
                    child: FloatingComposeButton()
                        .animate()
                        .fadeIn(
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        )
                        .slideY(begin: 0.2, end: 0),
                  ),
                ],
              ),
            ),
          ),

          // Scrim — tap outside drawer to close
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _drawerController,
              builder: (context, child) {
                final v = _drawerController.value;
                return IgnorePointer(
                  ignoring: v <= 0,
                  child: GestureDetector(
                    onTap: _toggleDrawer,
                    child: Container(color: Colors.black.withValues(alpha: 0.3 * v)),
                  ),
                );
              },
            ),
          ),

          // Drawer panel — slides from right
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: _drawerController,
              builder: (context, child) {
                final v = _drawerController.value;
                return Transform.translate(
                  offset: Offset((1 - v) * 300, 0),
                  child: child,
                );
              },
              child: RepaintBoundary(
                child: FadeTransition(
                  opacity: _drawerController,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 288),
                    height: double.infinity,
                    color: cs.surfaceContainerHigh,
                    child: ChatsListPage(
                      onBack: _toggleDrawer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
