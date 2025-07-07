import 'dart:math';
import 'package:flutter/material.dart';

class SpoilerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration revealDuration;

  const SpoilerText({
    super.key,
    required this.text,
    this.style,
    this.revealDuration = const Duration(milliseconds: 200),
  });

  @override
  State<SpoilerText> createState() => _SpoilerTextState();
}

class _SpoilerTextState extends State<SpoilerText>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    setState(() {
      _revealed = !_revealed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleReveal,
      child: AnimatedSwitcher(
        duration: widget.revealDuration,
        child: _revealed
            ? Text(widget.text, style: widget.style)
            : LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Text(
                        widget.text,
                        style:
                            widget.style?.copyWith(color: Colors.transparent),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _NoisePainter(
                                  progress: _controller.value,
                                  density: (width * height * 0.13)
                                      .clamp(200, 1200)
                                      .toInt(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // طبقة شفافة رمادية خفيفة فوق النويز
                      Positioned.fill(
                        child: Container(
                          color: Colors.grey.withOpacity(0.18),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double progress;
  final int density;
  final List<Color> baseColors = [
    Colors.white,
    Colors.grey,
    Colors.grey.shade300,
    Colors.grey.shade600,
    const Color(0xFFB3C6FF), // أزرق فاتح
    const Color(0xFFD1B3FF), // بنفسجي فاتح
  ];
  final List<double> sizes = [0.5, 0.7, 1.0, 1.3, 1.7];

  _NoisePainter({required this.progress, this.density = 800});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random((progress * 100000).floor());
    for (int i = 0; i < density; i++) {
      final dx = rand.nextDouble() * size.width;
      final dy = rand.nextDouble() * size.height;
      final color = baseColors[rand.nextInt(baseColors.length)]
          .withOpacity(0.18 + rand.nextDouble() * 0.55);
      final dotSize = sizes[rand.nextInt(sizes.length)];
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      // شكل بيضاوي عشوائي
      final isOval = rand.nextBool();
      if (isOval) {
        canvas.drawOval(
            Rect.fromCenter(
                center: Offset(dx, dy), width: dotSize * 1.5, height: dotSize),
            paint);
      } else {
        canvas.drawCircle(Offset(dx, dy), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.density != density;
  }
}
