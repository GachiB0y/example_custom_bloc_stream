import 'package:flutter/material.dart';

class SnowflakePainter extends CustomPainter {
  final List<Offset> snowflakePoints = [
    const Offset(-1, 2.5),
    const Offset(1, 2),
    const Offset(0, 1),
    const Offset(2, 2),
    const Offset(1, 0),
    const Offset(2, 1),
    const Offset(2.5, -1),
    const Offset(3, 1),
    const Offset(4, 0),
    const Offset(3, 2),
    const Offset(5, 1),
    const Offset(4, 2),
    const Offset(6, 2.5),
    const Offset(4, 3),
    const Offset(5, 4),
    const Offset(3, 3),
    const Offset(4, 5),
    const Offset(3, 4),
    const Offset(2.5, 6),
    const Offset(2, 4),
    const Offset(1, 5),
    const Offset(2, 3),
    const Offset(0, 4),
    const Offset(1, 3),
    const Offset(-1, 2.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Найти минимальные и максимальные значения координат
    final double minX =
        snowflakePoints.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
    final double maxX =
        snowflakePoints.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
    final double minY =
        snowflakePoints.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
    final double maxY =
        snowflakePoints.map((e) => e.dy).reduce((a, b) => a > b ? a : b);

    final double rangeX = maxX - minX;
    final double rangeY = maxY - minY;

    // Нормализовать координаты и преобразовать их под размер контейнера
    List<Offset> normalizedPoints = snowflakePoints.map((point) {
      double normalizedX = (point.dx - minX) / rangeX;
      double normalizedY = (point.dy - minY) / rangeY;
      return Offset(
        normalizedX * size.width,
        normalizedY * size.height,
      );
    }).toList();

    // Нарисовать снежинку
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..moveTo(normalizedPoints.first.dx, normalizedPoints.first.dy);
    for (var point in normalizedPoints) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SnowflakeWidget extends StatelessWidget {
  const SnowflakeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snowflake")),
      body: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CustomPaint(
            painter: SnowflakePainter(),
          ),
        ),
      ),
    );
  }
}
