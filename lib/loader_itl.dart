import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Создаем AnimationController с длительностью 600 миллисекунд
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3300),
      vsync: this,
    );

    // Анимация от 0 до 4π радиан (2 полных оборота по часовой стрелке)
    _animation = Tween<double>(begin: -2 * pi, end: 0).animate(_controller);

    // Запускаем анимацию с повторением каждую секунду
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _controller.reset();
          _controller.forward();
        });
      }
    });

    // Начинаем анимацию
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _animation,
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: MazePainter(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TypingTextWidget(text: "Loading..."),
          ],
        ),
      ),
    );
  }
}

class TypingTextWidget extends StatefulWidget {
  final String text;

  const TypingTextWidget({super.key, required this.text});

  @override
  State<TypingTextWidget> createState() => _TypingTextWidgetState();
}

class _TypingTextWidgetState extends State<TypingTextWidget>
    with SingleTickerProviderStateMixin {
  late String displayedText = '';
  late int currentIndex = 0;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        if (currentIndex < widget.text.length) {
          displayedText += widget.text[currentIndex];
          currentIndex++;
        } else {
          _timer?.cancel();
          _timer = null;
          displayedText = '';
          currentIndex = 0;
          _startTypingAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class MazePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Черный внешний квадрат
    paint.color = Colors.black;
    double borderWidth = size.width / 6;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Белый фон внутри
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(borderWidth, borderWidth, size.width - 2 * borderWidth,
          size.height - 2 * borderWidth),
      paint,
    );

    // Оранжевый центр (без разрыва)
    paint.color = Colors.orange;
    double centerSize = size.width / 3;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: centerSize,
        height: centerSize,
      ),
      paint,
    );

    //  Добавляем разрыв в лабиринте (диагональная белая линия)
    paint.color = Colors.white;
    paint.strokeWidth = borderWidth;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      const Offset(0, 0),
      Offset(2 * borderWidth, 2 * borderWidth),
      paint,
    );

    //  Добавляем разрыв в лабиринте (диагональная белая линия)
    paint.color = Colors.white;
    paint.strokeWidth = borderWidth;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width - 2 * borderWidth, size.height - 2 * borderWidth),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
