import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motor/motor.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:ordo/data/database.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = state.messages;

        if (messages.isEmpty) {
          return const _EmptyState();
        }

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(
            bottom: 120,
            top: 16,
            left: 16,
            right: 16,
          ),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return _ChatBubble(message: msg);
          },
        );
      },
    );
  }
}

class _ChatBubble extends StatefulWidget {
  final Message message;

  const _ChatBubble({required this.message});

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _pressed = false;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _startCountdown();
  }

  @override
  void didUpdateWidget(_ChatBubble old) {
    super.didUpdateWidget(old);
    if (old.message.reminderTime != widget.message.reminderTime ||
        old.message.isCompleted != widget.message.isCompleted) {
      _timer?.cancel();
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  double? get _progress {
    final rt = widget.message.reminderTime;
    if (rt == null) return null;
    final total = rt.difference(widget.message.createdAt);
    if (total.isNegative || total == Duration.zero) return null;
    final remaining = rt.difference(DateTime.now());
    return (remaining.inMicroseconds / total.inMicroseconds).clamp(0.0, 1.0);
  }

  void _startCountdown() {
    final rt = widget.message.reminderTime;
    if (rt != null && !widget.message.isCompleted) {
      if (!rt.isBefore(DateTime.now())) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) setState(() {});
        });
  }
}

  }

  Future<bool> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    return StyledSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: l10n.translate('deleteThoughtTitle'),
      message: l10n.translate('deleteThoughtMessage'),
      confirmLabel: l10n.translate('delete'),
      destructive: true,
    );
  }

  Future<void> _showEditSheet() async {
    final controller = TextEditingController(text: widget.message.content);
    final result = await showExpressiveSheet<String>(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;
        return Padding(
          padding: const EdgeInsets.all(16),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: ShapeDecoration(
                          color: cs.secondaryContainer,
                          shape: MaterialShapeBorder(
                            shape: MaterialShapes.cookie7Sided,
                          ),
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 32,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                    16.gap,
                    Text(
                      AppLocalizations.of(context).translate('editThought'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.unbounded(
                        textStyle: tt.titleLarge,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    24.gap,
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    16.gap,
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          textStyle: tt.titleMedium,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pop(controller.text.trim()),
                        child: Text(AppLocalizations.of(context).translate('save')),
                      ),
                    ),
                    8.gap,
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        style: FilledButton.styleFrom(
                          textStyle: tt.titleMedium,
                        ),
                        onPressed: () => Navigator.of(context).pop(null),
                        child: Text(AppLocalizations.of(context).translate('cancel')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (result != null && result.isNotEmpty && mounted) {
      context.read<ChatCubit>().editMessage(widget.message, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final bool isCompleted = widget.message.isCompleted;
    final bool isTask = widget.message.type == 'task';

    final double? progress = _progress;
    final double elapsed = progress != null ? (1.0 - progress) : 0.0;
    final double fillFraction = isCompleted ? 1.0 : elapsed;
    final bool showFill = isCompleted || (progress != null && elapsed > 0);
    final Color fill = cs.primary;
    final Color onFill = cs.onPrimary;

    final card = _cardWidget(
      cs,
      tt,
      progress,
      fillFraction,
      showFill,
      fill,
      onFill,
      isCompleted,
      isTask,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: BlocBuilder<SwipeToDeleteCubit, bool>(
        builder: (context, swipeEnabled) {
          if (swipeEnabled) {
            return Dismissible(
              key: ValueKey(widget.message.id),
              direction: DismissDirection.horizontal,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              confirmDismiss: (_) => _confirmDelete(),
              onDismissed: (_) {
                context.read<ChatCubit>().deleteMessage(widget.message);
              },
              child: card,
            );
          }

          return CueModalTransition(
            barrierColor: Colors.transparent,
            motion: CueMotion.smooth(),
            reverseMotion: CueMotion.snappy(),
            hideTriggerOnTransition: true,
            backdrop: Actor(
              acts: [Act.backdropBlur(to: 8)],
              child: const ColoredBox(color: Colors.transparent),
            ),
            triggerBuilder: (context, open) {
              return GestureDetector(onLongPress: open, child: card);
            },
            builder: (context, rect) {
              final showInTopHalf =
                  rect.center.dy < MediaQuery.sizeOf(context).height / 2;
              const emojis = [
                '💜',
                '😂',
                '😮',
                '😢',
                '✊🏽',
                '🤢',
                '🤯',
                '👋🏽',
              ];
              final currentReactions = _currentReactions;
              return SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: ClipRect(
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      mainAxisAlignment: showInTopHalf
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: showInTopHalf ? 40 : 0),
                        SizedBox(
                          width: 240,
                          child: Actor(
                            acts: [
                              Act.fadeIn(delay: 100.ms),
                              Act.zoomIn(),
                              Act.slide(
                                from: Offset(0, showInTopHalf ? 2 : -2),
                              ),
                            ],
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: cs.surfaceContainerHigh.withValues(
                                alpha: 0.95,
                              ),
                              shape: RoundedSuperellipseBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: cs.outlineVariant.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildMenuOptions(cs, tt),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: showInTopHalf ? 0 : 4),
                        Actor(
                          acts: [
                            Act.translateFromGlobal(
                              offset: rect.topLeft - const Offset(0, 24 + 4),
                            ),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Actor(
                                acts: [Act.fadeIn(), Act.slideY(from: 2)],
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  color: cs.surfaceContainerHigh.withValues(
                                    alpha: 0.8,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: 16,
                                    left: 16,
                                    bottom: 4,
                                  ),
                                  elevation: 0,
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    side: BorderSide(
                                      color: cs.outlineVariant.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Actor(
                                    acts: [
                                      Act.sizedClip(
                                        from: NSize.square(24),
                                        to: const NSize(h: 68),
                                        delay: 150.ms,
                                      ),
                                      Act.fadeIn(),
                                      Act.slideY(from: 2),
                                    ],
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      children: [
                                        for (var i = 0; i < emojis.length; i++)
                                          Center(
                                            child: Actor(
                                              delay: 200.ms,
                                              motion: CueMotion.wobbly(),
                                              reverseMotion: CueMotion.snappy(),
                                              acts: [
                                                Act.scale(from: 0.5),
                                                Act.rotate(
                                                  from: -50,
                                                  delay: 10.ms * i,
                                                ),
                                              ],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    context
                                                        .read<ChatCubit>()
                                                        .addReaction(
                                                          widget.message,
                                                          emojis[i],
                                                        );
                                                  },
                                                  child: Text(
                                                    emojis[i],
                                                    style: TextStyle(
                                                      fontSize:
                                                          currentReactions
                                                              .contains(
                                                                emojis[i],
                                                              )
                                                          ? 34
                                                          : 28,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                ),
                                child: Actor(
                                  acts: [Act.scale(to: 1.03)],
                                  child: card,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: showInTopHalf ? 0 : 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _cardWidget(
    ColorScheme cs,
    TextTheme tt,
    double? progress,
    double fillFraction,
    bool showFill,
    Color fill,
    Color onFill,
    bool isCompleted,
    bool isTask,
  ) {
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: _pressed ? 1.0 : 0.0,
      builder: (context, t, child) {
        final scale = 1 - 0.02 * t;
        return Transform.scale(scale: scale, child: child);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(isCompleted ? 24 : 16),
        ),
        child: Stack(
          children: [
            if (showFill)
              Positioned.fill(
                child: ClipRect(
                  clipper: _FillClipper(fraction: fillFraction),
                  child: ColoredBox(color: fill),
                ),
              ),
            _buildContent(
              cs,
              tt,
              fg: cs.onSurface,
              labelFg: cs.onSurfaceVariant,
              showFill: false,
            ),
            if (showFill)
              Positioned.fill(
                child: ClipRect(
                  clipper: _FillClipper(fraction: fillFraction),
                  child: _buildContent(
                    cs,
                    tt,
                    fg: onFill,
                    labelFg: onFill,
                    showFill: true,
                  ),
                ),
              ),
            if (progress != null && !isCompleted)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: WavyLinearProgressIndicator(
                  value: progress,
                  color: cs.primary,
                  trackColor: cs.primary.withValues(alpha: 0.25),
                  stopIndicatorColor: cs.primary,
                ),
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTap: isTask
                      ? () {
                          context.read<ChatCubit>().toggleTask(widget.message);
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> get _currentReactions {
    final raw = widget.message.reactions;
    if (raw == null || raw.isEmpty) return [];
    return List<String>.from(
      (jsonDecode(raw) as List).map((e) => e.toString()),
    );
  }

  List<Widget> _buildMenuOptions(ColorScheme cs, TextTheme tt) {
    final cubit = context.read<ChatCubit>();
    final isTask = widget.message.type == 'task';
    final isCompleted = widget.message.isCompleted;

    final l10n = AppLocalizations.of(context);
    return [
      if (isTask)
        _MenuTile(
          icon: isCompleted
              ? Icons.undo_rounded
              : Icons.check_circle_outline_rounded,
          title: isCompleted ? l10n.translate('markIncomplete') : l10n.translate('markComplete'),
          onTap: () {
            cubit.toggleTask(widget.message);
            Navigator.of(context).pop();
          },
        ),
      _MenuTile(
        icon: Icons.edit_rounded,
        title: l10n.translate('edit'),
        onTap: () {
          Navigator.of(context).pop();
          _showEditSheet();
        },
      ),
      if (isTask)
        _MenuTile(
          icon: Icons.access_time_rounded,
          title: l10n.translate('setReminder'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      _MenuTile(
        icon: Icons.content_copy_rounded,
        title: l10n.translate('copyText'),
        onTap: () {
          Clipboard.setData(ClipboardData(text: widget.message.content));
          Navigator.of(context).pop();
        },
      ),
      const _MenuDivider(),
      _MenuTile(
        icon: Icons.delete_outline_rounded,
        title: l10n.translate('delete'),
        isDestructive: true,
        onTap: () {
          Navigator.of(context).pop();
          cubit.deleteMessage(widget.message);
        },
      ),
    ];
  }

  // ——— EpisodeCard-inspired dual-render content ———
  Widget _buildContent(
    ColorScheme cs,
    TextTheme tt, {
    required Color fg,
    required Color labelFg,
    required bool showFill,
  }) {
    final bool isCompleted = widget.message.isCompleted;
    final bool isTask = widget.message.type == 'task';
    final Widget? countdown = _buildCountdown(cs, tt, labelFg);
    final bool compact = context.watch<CompactModeCubit>().state;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!compact) ...[
            // Left icon — 48×48 like EpisodeCard's cover art
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: isTask
                    ? (isCompleted ? cs.onPrimary : cs.surfaceContainerHighest)
                    : cs.primaryContainer,
                shape: MaterialShapeBorder(
                  shape: isTask
                      ? (isCompleted
                          ? MaterialShapes.clover4Leaf
                          : MaterialShapes.cookie7Sided)
                      : MaterialShapes.clover4Leaf,
                ),
              ),
              child: isTask
                  ? (isCompleted
                      ? Icon(Icons.check_rounded, size: 22, color: cs.primary)
                      : Icon(Icons.check_circle_outline_rounded,
                          size: 22, color: cs.onSurfaceVariant))
                  : Icon(Icons.note_rounded,
                      size: 22, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
          ],
          // Text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isTask ? AppLocalizations.of(context).translate('labelTask') : AppLocalizations.of(context).translate('labelNote'),
                  style: tt.labelSmall?.copyWith(
                    color: labelFg,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                if (isCompleted && isTask)
                  Stack(
                    children: [
                      _MarqueeText(
                        text: widget.message.content,
                        style: tt.titleMedium?.copyWith(
                          color: fg.withValues(alpha: 0.35),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _waveController,
                            builder: (context, child) => CustomPaint(
                              painter: _WavyLinePainter(
                                color: fg,
                                strokeWidth: 2,
                                amplitude: 3,
                                wavelength: 16,
                                phase: _waveController.value * 2 * math.pi,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  _MarqueeText(
                    text: widget.message.content,
                    style: tt.titleMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (countdown != null && !isCompleted) countdown,
                if (_currentReactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _currentReactions
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(e,
                                    style: const TextStyle(fontSize: 16)),
                              ))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Trailing — like EpisodeCard (time or check)
          if (isCompleted)
            Container(
              width: 30,
              height: 30,
              decoration: ShapeDecoration(
                color: fg,
                shape: MaterialShapeBorder(
                    shape: MaterialShapes.cookie7Sided),
              ),
              child:
                  Icon(Icons.check_rounded, size: 18, color: cs.primary),
            )
          else if (countdown != null)
            countdown,
        ],
      ),
    );
  }

  Widget? _buildCountdown(ColorScheme cs, TextTheme tt, Color fg) {
    final reminderTime = widget.message.reminderTime;
    if (reminderTime == null || widget.message.isCompleted) return null;

    final remaining = reminderTime.difference(DateTime.now());
    if (remaining.isNegative) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            remaining.remainingLabel,
            style: tt.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const _MarqueeText({required this.text, this.style});

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final TextPainter tp = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final double overflow = tp.width - maxWidth;

        if (overflow <= 0) {
          return Text(widget.text,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: widget.style);
        }

        if (!_controller.isAnimating) {
          _controller
            ..value = 0
            ..repeat(period: const Duration(seconds: 10));
        }

        final double offset = overflow * _controller.value;

        return SizedBox(
          height: tp.height,
          child: ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(-offset, 0),
                child: Text(widget.text,
                    maxLines: 1, softWrap: false, style: widget.style),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FillClipper extends CustomClipper<Rect> {
  const _FillClipper({required this.fraction});
  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_FillClipper oldClipper) => oldClipper.fraction != fraction;
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDestructive ? cs.error : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? cs.error : cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 0.5, indent: 16, endIndent: 16, height: 1);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/SK/cat.svg',
                width: 200,
                height: 200,
                colorFilter: ColorFilter.mode(
                  cs.primary.withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('emptySpaceTitle'),
              style: tt.headlineSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).translate('emptySpaceMessage'),
              textAlign: TextAlign.center,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _WavyLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double amplitude;
  final double wavelength;
  final double phase;

  const _WavyLinePainter({
    required this.color,
    this.strokeWidth = 2,
    this.amplitude = 3,
    this.wavelength = 12,
    this.phase = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double centerY = size.height / 2;
    final double w = size.width;

    for (double x = 0; x <= w; x += 0.5) {
      final double y = centerY + amplitude * math.sin((2 * math.pi * x) / wavelength + phase);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavyLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.amplitude != amplitude ||
      oldDelegate.wavelength != wavelength ||
      oldDelegate.phase != phase;
}
