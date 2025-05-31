import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Эффект пылевых частиц')),
        body: const MessageList(),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final List<String> _messages =
      List.generate(10, (index) => 'Сообщение $index');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ParticleSlidableItem(
          key: ValueKey(_messages[index]),
          message: _messages[index],
          onDismissed: () {
            setState(() {
              _messages.removeAt(index);
            });
          },
        );
      },
    );
  }
}

class ParticleSlidableItem extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const ParticleSlidableItem({
    required Key key,
    required this.message,
    required this.onDismissed,
  }) : super(key: key);

  @override
  _ParticleSlidableItemState createState() => _ParticleSlidableItemState();
}

class _ParticleSlidableItemState extends State<ParticleSlidableItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isDismissed = false;
  double _widgetWidth = 400; // Начальное значение, будет обновлено

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
          milliseconds:
              (_widgetWidth / 150 * 1000).ceil()), // Динамическая длительность
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateWidth(double width) {
    if (width != _widgetWidth) {
      setState(() {
        _widgetWidth = width;
        _controller.duration =
            Duration(milliseconds: (width / 150 * 1000).ceil());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDismissed
        ? ParticleExplosion(
            controller: _controller,
            onWidthDetected: _updateWidth,
          )
        : Slidable(
            key: widget.key,
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  setState(() {
                    _isDismissed = true;
                  });
                  _controller.forward().then((_) {
                    widget.onDismissed();
                  });
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    setState(() {
                      _isDismissed = true;
                    });
                    _controller.forward().then((_) {
                      widget.onDismissed();
                    });
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Удалить',
                ),
              ],
            ),
            child: ListTile(
              title: Text(widget.message),
            ),
          );
  }
}

class ParticleExplosion extends StatelessWidget {
  final AnimationController controller;
  final Function(double) onWidthDetected;

  const ParticleExplosion({
    super.key,
    required this.controller,
    required this.onWidthDetected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onWidthDetected(constraints.maxWidth);
        });
        return CustomPaint(
          painter: ParticlePainter(
            animation: controller,
          ),
          child: Container(
            height: 60, // Соответствует высоте ListTile
          ),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final Random _random = Random();
  final List<Particle> _particles = [];

  ParticlePainter({required Animation<double> animation})
      : animation = animation,
        super(repaint: animation) {
    for (int i = 0; i < 5000; i++) {
      _particles.add(Particle(
        position: vector.Vector2(
          _random.nextDouble(), // Нормализованная позиция (0 до 1)
          (_random.nextDouble() - 0.5) * 60, // По высоте ListTile
        ),
        velocity: vector.Vector2(
          150 + _random.nextDouble() * 250, // Скорость от 150 до 400 px/s
          (_random.nextDouble() - 0.5) * 50, // Минимальное отклонение по Y
        ),
        color: Colors.brown.shade200.withOpacity(0.7), // Цвет пыли
        radius: 0.1 + _random.nextDouble(), // Мелкие частицы
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = animation.value;
    final Paint paint = Paint();

    for (var particle in _particles) {
      particle.update(progress, size);
      paint.color = particle.color;
      canvas.drawCircle(
        Offset(
          particle.position.x * size.width, // Денормализация позиции X
          particle.position.y + size.height / 2,
        ),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  vector.Vector2 position;
  vector.Vector2 velocity;
  Color color;
  double radius;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.radius,
  });

  void update(double progress, Size size) {
    // Прозрачность зависит от позиции X и прогресса анимации
    final double normalizedX = position.x; // Позиция X нормализована (0 до 1)
    final double opacity = (1 - progress) - normalizedX;
    color = color.withOpacity(opacity.clamp(0.0, 0.7));

    // Движение частиц вправо
    position.x += (velocity.x * progress * 0.016) /
        size.width; // Нормализованное движение
    position.y += velocity.y * progress * 0.016; // Движение по Y
  }
}
