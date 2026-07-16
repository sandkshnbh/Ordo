import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:ordo/features/chat/widgets/time_picker_sheet.dart';

class FloatingComposeButton extends StatefulWidget {
  const FloatingComposeButton({super.key});

  @override
  State<FloatingComposeButton> createState() => _FloatingComposeButtonState();
}

class _FloatingComposeButtonState extends State<FloatingComposeButton>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _isSending = false;
  String _mode = 'note';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _orbitController;
  late Animation<double> _orbitAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _orbitController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _orbitAnimation = CurvedAnimation(
      parent: _orbitController,
      curve: Curves.easeOutBack,
    );
    _orbitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isSending = false);
      }
    });
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == 'note' ? 'task' : 'note';
    });
  }

  void _send() async {
    if (_controller.text.trim().isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _orbitController.forward(from: 0);

    DateTime? reminderTime;

    if (_mode == 'task') {
      final notificationsEnabled = context.read<NotificationsCubit>().state;
      if (notificationsEnabled) {
        final timeOfDay = await TimePickerSheet.show(context);
        if (!mounted) return;
        if (timeOfDay != null) {
          final now = DateTime.now();
          reminderTime = DateTime(
            now.year,
            now.month,
            now.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
          if (reminderTime.isBefore(now)) {
            reminderTime = reminderTime.add(const Duration(days: 1));
          }
        }
      }
    }

    if (!mounted) return;
    context.read<ChatCubit>().sendMessage(
      _controller.text.trim(),
      _mode,
      reminderTime: reminderTime,
    );

    _controller.clear();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // No-op since we removed preference loading
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No-op since we removed preference loading
  }

  @override
  void dispose() {
    _orbitController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<SendButtonStyleCubit, bool>(
      builder: (context, separate) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTapUp: (_) {
                    setState(() => _pressed = false);
                  },
                  child: AnimatedScale(
                    scale: _pressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRect(
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _toggleMode,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  _mode == 'note'
                                      ? 'assets/SK/icon/note.svg'
                                      : 'assets/SK/icon/task.svg',
                                  width: 22,
                                  height: 22,
                                  colorFilter: ColorFilter.mode(
                                    colorScheme.onSurfaceVariant,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: _mode == 'note'
                                      ? AppLocalizations.of(context).translate('typeThoughtHint')
                                      : AppLocalizations.of(context).translate('addTaskHint'),
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 8,
                                  ),
                                ),
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                onSubmitted: (_) => _send(),
                              ),
                            ),
                            if (!separate) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _send,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    'assets/SK/icon/send.svg',
                                    width: 22,
                                    height: 22,
                                    colorFilter: ColorFilter.mode(
                                      colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (separate) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _send,
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _orbitAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _orbitAnimation.value * 2 * pi,
                              child: Material(
                                color: colorScheme.primary,
                                shape: MaterialShapeBorder(
                                  shape: MaterialShapes.cookie6Sided,
                                ),
                                child: const SizedBox(width: 64, height: 64),
                              ),
                            );
                          },
                        ),
                        SvgPicture.asset(
                          'assets/SK/icon/send.svg',
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
