import 'package:flutter/material.dart';
import 'package:ordo/models/task_model.dart';
import 'package:ordo/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ordo/widgets/spoiler_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ordo/screens/add_task_screen.dart';
import 'package:ordo/l10n/app_localizations.dart';
import 'package:ordo/providers/locale_provider.dart';
import 'dart:math';
import 'package:ordo/providers/strike_style_provider.dart';
import 'package:ordo/providers/card_customization_provider.dart';

class ScribbleStrikeThrough extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool scribble;
  final int scribbleLines;
  final Duration duration;
  final StrikeStyle strikeStyle;

  const ScribbleStrikeThrough({
    super.key,
    required this.text,
    this.style,
    this.scribble = false,
    this.scribbleLines = 3,
    this.duration = const Duration(milliseconds: 900),
    this.strikeStyle = StrikeStyle.scribble,
  });

  @override
  State<ScribbleStrikeThrough> createState() => _ScribbleStrikeThroughState();
}

class _ScribbleStrikeThroughState extends State<ScribbleStrikeThrough>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.strikeStyle == StrikeStyle.aqua ||
              widget.strikeStyle == StrikeStyle.flame
          ? const Duration(seconds: 2)
          : widget.duration,
    );
    if (widget.scribble) {
      if (widget.strikeStyle == StrikeStyle.aqua ||
          widget.strikeStyle == StrikeStyle.flame) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(covariant ScribbleStrikeThrough oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scribble) {
      if (widget.strikeStyle == StrikeStyle.aqua ||
          widget.strikeStyle == StrikeStyle.flame) {
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      } else {
        if (!_controller.isCompleted) {
          _controller.forward();
        }
      }
    } else {
      _controller.reset();
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadedStyle = widget.scribble
        ? (widget.style ?? const TextStyle()).copyWith(
            color: (widget.style?.color ?? Colors.white).withOpacity(0.45),
          )
        : widget.style;
    if (!widget.scribble) {
      return Text(widget.text, style: fadedStyle);
    }
    return Stack(
      children: [
        Text(widget.text, style: fadedStyle),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final time = (widget.strikeStyle == StrikeStyle.aqua ||
                      widget.strikeStyle == StrikeStyle.flame)
                  ? _controller.value * 2 * 3.14159
                  : _controller.value;
              return CustomPaint(
                painter: _StaggeredScribblePainter(
                  progress: widget.strikeStyle == StrikeStyle.aqua ||
                          widget.strikeStyle == StrikeStyle.flame
                      ? 1.0
                      : _controller.value,
                  scribbleLines: widget.scribbleLines,
                  color: (widget.style?.color ?? Colors.white).withOpacity(0.7),
                  duration: widget.duration,
                  strikeStyle: widget.strikeStyle,
                  time: time,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StaggeredScribblePainter extends CustomPainter {
  final double progress;
  final int scribbleLines;
  final Color color;
  final Duration duration;
  final StrikeStyle strikeStyle;
  final double time;
  _StaggeredScribblePainter({
    required this.progress,
    this.scribbleLines = 3,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 900),
    this.strikeStyle = StrikeStyle.scribble,
    this.time = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final rand = Random(size.width.toInt() + size.height.toInt());
    final lineDelay = 0.12;
    for (int i = 0; i < scribbleLines; i++) {
      final start = i * lineDelay;
      final end = start + (1 - lineDelay * (scribbleLines - 1));
      final lineProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);
      if (lineProgress <= 0) continue;
      final y = size.height * (0.5 + (i - (scribbleLines - 1) / 2) * 0.18);
      final points = <Offset>[];
      int segments = 16;
      for (int j = 0; j <= segments; j++) {
        final x = size.width * (j / segments) * lineProgress;
        double dy = y;
        switch (strikeStyle) {
          case StrikeStyle.straight:
            // خط مستقيم
            break;
          case StrikeStyle.zigzag:
            dy += ((j % 2 == 0) ? 6 : -6);
            break;
          case StrikeStyle.scribble:
            dy += rand.nextDouble() * 7 - 3.5 + sin(j * 1.5 + i) * 2.5;
            break;
          case StrikeStyle.dashed:
            if (j % 3 == 0) continue;
            break;
          case StrikeStyle.wave:
            dy += sin(j * 0.8 + i) * 7;
            break;
          case StrikeStyle.aqua:
            // مائي: موجات متحركة ديناميكية
            dy += sin(j * 1.2 + i + time * 1.2) * 8 +
                cos(j * 0.7 + i + time * 0.7) * 3;
            break;
          case StrikeStyle.flame:
            // ناري: ألسنة لهب متحركة ديناميكية
            dy += sin(j * 1.1 + i + time * 1.7) * 7 +
                pow(sin(j + time * 2.5), 3) * 12 +
                rand.nextDouble() * 4;
            break;
        }
        points.add(Offset(x, dy));
      }
      for (int j = 0; j < points.length - 1; j++) {
        if (strikeStyle == StrikeStyle.dashed && j % 2 == 0) continue;
        if (strikeStyle == StrikeStyle.aqua) {
          // رسم موجتين متداخلتين
          final paintAqua1 = Paint()
            ..color = Color.lerp(Colors.cyanAccent, Colors.blueAccent,
                    (j / points.length + 0.2 * sin(time + j)) % 1.0)!
                .withOpacity(0.7)
            ..strokeWidth = paint.strokeWidth + 1.2 * sin(j * 1.5 + time)
            ..style = paint.style
            ..strokeCap = paint.strokeCap;
          final paintAqua2 = Paint()
            ..color = Color.lerp(Colors.white, Colors.cyanAccent,
                    (j / points.length + 0.4 * cos(time + j)) % 1.0)!
                .withOpacity(0.35)
            ..strokeWidth = paint.strokeWidth * 0.7
            ..style = paint.style
            ..strokeCap = paint.strokeCap;
          canvas.drawLine(points[j], points[j + 1], paintAqua1);
          canvas.drawLine(
            points[j] + Offset(0, 2.5 * sin(time + j)),
            points[j + 1] + Offset(0, 2.5 * sin(time + j + 1)),
            paintAqua2,
          );
          // رسم فقاعات ماء صغيرة
          if (j % 6 == 0 && rand.nextDouble() > 0.7) {
            final bubblePaint = Paint()
              ..color = Colors.white.withOpacity(0.18 + 0.18 * sin(time + j))
              ..style = PaintingStyle.fill;
            canvas.drawCircle(points[j] + Offset(0, -4),
                1.7 + 1.2 * sin(time + j), bubblePaint);
          }
        } else if (strikeStyle == StrikeStyle.flame) {
          // رسم ألسنة لهب منفصلة مع توهج
          final t = (j / points.length + 0.3 * sin(time + j)) % 1.0;
          Color colorFlame;
          if (t < 0.3) {
            colorFlame = Color.lerp(Colors.red, Colors.orange, t / 0.3)!;
          } else if (t < 0.6) {
            colorFlame =
                Color.lerp(Colors.orange, Colors.yellow, (t - 0.3) / 0.3)!;
          } else {
            colorFlame =
                Color.lerp(Colors.yellow, Colors.white, (t - 0.6) / 0.4)!;
          }
          // رسم اللهب الرئيسي
          final flamePaint = Paint()
            ..color = colorFlame.withOpacity(0.93)
            ..strokeWidth = paint.strokeWidth + 1.2 * sin(j * 2.2 + time)
            ..style = paint.style
            ..strokeCap = paint.strokeCap;
          // رسم توهج حول اللهب
          final glowPaint = Paint()
            ..color = colorFlame.withOpacity(0.22)
            ..strokeWidth = flamePaint.strokeWidth * 2.7
            ..style = paint.style
            ..strokeCap = paint.strokeCap;
          // ألسنة لهب منفصلة
          final tongueOffset = Offset(
              0, -7 * pow(sin(time * 2 + j * 0.7), 2) * sin(j + time * 2.5));
          canvas.drawLine(points[j], points[j + 1], glowPaint);
          canvas.drawLine(points[j], points[j + 1] + tongueOffset, flamePaint);
        } else {
          canvas.drawLine(points[j], points[j + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StaggeredScribblePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scribbleLines != scribbleLines ||
        oldDelegate.color != color ||
        oldDelegate.strikeStyle != strikeStyle ||
        oldDelegate.time != time;
  }
}

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.redAccent.shade100;
      case Priority.important:
        return Colors.amberAccent.shade100;
      case Priority.normal:
      default:
        return const Color(0xFFB2FF59);
    }
  }

  void _onDeletePressed(
      BuildContext context, TaskProvider provider, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_delete),
          content: Text(AppLocalizations.of(context)!.delete_question),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                provider.deleteTask(taskId);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _onEditPressed(
      BuildContext context, Task task, TaskProvider provider) async {
    await showAddTaskSheet(context, provider, editingTask: task);
  }

  List<InlineSpan> _parseSpoilerText(String content, TextStyle? style) {
    final spans = <InlineSpan>[];
    final spoilerReg = RegExp(r'\[spoiler\](.*?)\[/spoiler\]', dotAll: true);
    int last = 0;
    for (final match in spoilerReg.allMatches(content)) {
      if (match.start > last) {
        spans.add(
            TextSpan(text: content.substring(last, match.start), style: style));
      }
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SpoilerText(text: match.group(1) ?? '', style: style),
      ));
      last = match.end;
    }
    if (last < content.length) {
      spans.add(TextSpan(text: content.substring(last), style: style));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, LocaleProvider>(
      builder: (context, taskProvider, localeProvider, child) {
        final latestTask = taskProvider.tasks.firstWhere(
          (t) => t.id == widget.task.id,
          orElse: () => widget.task,
        );
        return Consumer<CardCustomizationProvider>(
          builder: (context, cardCustom, child) {
            return Slidable(
              key: Key(latestTask.id),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.60,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox.expand(
                      child: _AnimatedActionButton(
                        color1: latestTask.isPinned
                            ? Colors.orange.shade900
                            : Colors.orange.shade700,
                        color2: Colors.orange.shade400,
                        icon: Icons.push_pin,
                        label: AppLocalizations.of(context)!.pin,
                        iconSize: 22,
                        fontSize: 13,
                        spacing: 2,
                        onTap: () {
                          taskProvider.togglePinTask(latestTask.id);
                        },
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox.expand(
                      child: _AnimatedActionButton(
                        color1: Colors.blue.shade700,
                        color2: Colors.blue.shade400,
                        icon: Icons.edit_rounded,
                        label: AppLocalizations.of(context)!.edit,
                        iconSize: 22,
                        fontSize: 13,
                        spacing: 2,
                        onTap: () =>
                            _onEditPressed(context, latestTask, taskProvider),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox.expand(
                      child: _AnimatedActionButton(
                        color1: Colors.red.shade600,
                        color2: Colors.red.shade400,
                        icon: Icons.delete_rounded,
                        label: AppLocalizations.of(context)!.delete,
                        iconSize: 22,
                        fontSize: 13,
                        spacing: 2,
                        onTap: () => _onDeletePressed(
                            context, taskProvider, latestTask.id),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                elevation: 2,
                color: cardCustom.useCustomColor
                    ? cardCustom.customColor.withOpacity(0.95)
                    : Colors.white.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                shadowColor: Colors.black
                    .withOpacity(cardCustom.showShadow ? 0.07 : 0.01),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: _buildCardContent(context, latestTask, taskProvider),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardContent(
      BuildContext context, Task latestTask, TaskProvider taskProvider) {
    final modernColors = [
      Color(0xFF317039), // Emerald Green
      Color(0xFFF1BE49), // Maximum Yellow
      Color(0xFFF8EDD9), // Antique White
      Color(0xFFCC4B24), // Dark Pastel Red
      Color(0xFFFFF1D4), // Papaya Whip
      Color(0xFFFFFBEB), // Cosmic Latte
    ];
    final cardColor = modernColors[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => taskProvider.toggleTaskCompleted(latestTask.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: latestTask.isCompleted
                      ? _getPriorityColor(latestTask.priority)
                      : Colors.transparent,
                  border: Border.all(
                    color: _getPriorityColor(latestTask.priority),
                    width: 2.2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: latestTask.isCompleted
                    ? Icon(Icons.check, size: 16, color: Colors.black87)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsetsDirectional.only(end: 7),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(latestTask.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (latestTask.isVoiceTask)
                        Container(
                          margin: const EdgeInsetsDirectional.only(end: 8),
                          child: Icon(
                            Icons.mic,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      Flexible(
                        child: Consumer<StrikeStyleProvider>(
                          builder: (context, strikeProvider, _) {
                            return ScribbleStrikeThrough(
                              text: latestTask.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              scribble: latestTask.isCompleted,
                              scribbleLines: 3,
                              duration: const Duration(milliseconds: 900),
                              strikeStyle: strikeProvider.style,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (latestTask.content.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                        ),
                        children: _parseSpoilerText(
                            latestTask.content,
                            TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 15,
                            )),
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 15, color: Colors.white.withOpacity(0.55)),
            const SizedBox(width: 5),
            Text(
              DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
                  .add_jm()
                  .format(latestTask.creationDate),
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 13,
              ),
            ),
            if (latestTask.isVoiceTask) ...[
              const Spacer(),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .audio_feature_in_progress),
                    ),
                  );
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.blueAccent,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final double iconSize;
  final double fontSize;
  final double spacing;

  const _AnimatedActionButton({
    required this.color1,
    required this.color2,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.borderRadius,
    this.iconSize = 28,
    this.fontSize = 16,
    this.spacing = 6,
    Key? key,
  }) : super(key: key);

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.ease,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: widget.color1,
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: widget.color1.withOpacity(0.22),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.13), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius,
          splashColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.04),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: Center(
            child: AnimatedScale(
              scale: _pressed ? 0.93 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white, size: widget.iconSize),
                  SizedBox(height: widget.spacing),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
