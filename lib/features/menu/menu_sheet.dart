import 'package:flutter/material.dart';
import 'package:expressive_sheet/expressive_sheet.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet(
      context: context,
      builder: (context) => const MenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Material(
      color: cs.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chats',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // TODO: New Chat
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              // Dummy chats
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.chat_bubble, color: cs.onPrimaryContainer),
                ),
                title: const Text('Ideas & Thoughts'),
                subtitle: const Text('Last updated 2 hours ago'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: cs.secondaryContainer,
                  child: Icon(
                    Icons.chat_bubble,
                    color: cs.onSecondaryContainer,
                  ),
                ),
                title: const Text('Shopping List'),
                subtitle: const Text('Last updated yesterday'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
