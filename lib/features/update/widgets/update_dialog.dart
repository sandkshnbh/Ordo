import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordo/features/update/cubits/update_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final Widget child;

  const UpdateDialog({super.key, required this.child});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _hasShownSnack = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasShownSnack) {
      _hasShownSnack = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = context.read<UpdateCubit>().state;
        if (state.hasUpdate && !state.isDismissed) {
          _showUpdateSnack(state.updateInfo!);
        }
      });
    }
  }

  void _showUpdateSnack(Map<String, dynamic> updateInfo) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.new_releases_rounded,
              color: isDark ? cs.primary : cs.onPrimaryContainer,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Update v${updateInfo['latestVersion']}',
                style: TextStyle(
                  color: isDark ? cs.onSurface : cs.onPrimaryContainer,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? cs.surfaceContainerHigh : cs.primaryContainer,
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Download',
          textColor: cs.primary,
          onPressed: () {
            launchUrl(
              Uri.parse(updateInfo['downloadUrl']),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateCubit, UpdateState>(
      listener: (context, state) {
        if (state.hasUpdate && !state.isDismissed && !_hasShownSnack) {
          _hasShownSnack = true;
          _showUpdateSnack(state.updateInfo!);
        }
      },
      child: widget.child,
    );
  }
}
