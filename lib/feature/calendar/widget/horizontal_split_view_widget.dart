import 'package:bloc_stream/feature/counter/bloc/change_notifier/change_notifier_provider.dart';
import 'package:flutter/material.dart';

// class HorizontalSplitViewModel extends ChangeNotifier {
//   HorizontalSplitViewModel(this._ratio);

//   double _ratio;
//   double get ratio => _ratio;

//   void updateRatio(double delta, double maxHeight) {
//     _ratio += delta / maxHeight;
//     if (_ratio > 1) {
//       _ratio = 1;
//     } else if (_ratio < 0) {
//       _ratio = 0;
//     }
//     notifyListeners();
//   }

//   void finalizeRatio() {
//     if (_ratio > 0.5) {
//       _ratio = 1;
//     } else if (_ratio < 0.49) {
//       _ratio = 0.0;
//     }
//     notifyListeners();
//   }
// }

class HorizontalSplitViewModel extends ChangeNotifier {
  HorizontalSplitViewModel(this._ratio);

  double _ratio;
  double get ratio => _ratio;

  void updateRatio(double delta, double maxHeight) {
    _ratio += delta / maxHeight;
    if (_ratio > 1) {
      _ratio = 1;
    } else if (_ratio < 0) {
      _ratio = 0;
    }
    notifyListeners();
  }

  void setRatio(double ratio) {
    _ratio = ratio;
    notifyListeners();
  }
}

class HorizontalSplitView extends StatefulWidget {
  const HorizontalSplitView({
    required this.top,
    required this.bottom,
    this.ratio = 0.0,
    super.key,
  })  : assert(ratio >= 0, 'ratio must be >= 0'),
        assert(ratio <= 1, 'ratio must be <= 1');

  final Widget top;
  final Widget bottom;
  final double ratio;

  @override
  State<HorizontalSplitView> createState() => _HorizontalSplitViewState();
}

class _HorizontalSplitViewState extends State<HorizontalSplitView> {
  late final HorizontalSplitViewModel model;
  @override
  void initState() {
    super.initState();
    model = HorizontalSplitViewModel(widget.ratio);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HorizontalSplitViewModel>(
      model: model,
      child: _HorizontalSplitViewBody(
        top: widget.top,
        bottom: widget.bottom,
      ),
    );
  }
}

class _HorizontalSplitViewBody extends StatefulWidget {
  const _HorizontalSplitViewBody({
    required this.top,
    required this.bottom,
    super.key,
  });

  final Widget top;
  final Widget bottom;

  @override
  State<_HorizontalSplitViewBody> createState() =>
      _HorizontalSplitViewBodyState();
}

class _HorizontalSplitViewBodyState extends State<_HorizontalSplitViewBody>
    with SingleTickerProviderStateMixin {
  double? _maxHeight;
  final _dividerWidth = 54.0;
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        final model =
            ChangeNotifierProvider.of<HorizontalSplitViewModel>(context)!;
        model.setRatio(_animation.value);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finalizeRatio(HorizontalSplitViewModel model) {
    final targetRatio = model.ratio > 0.5 ? 1.0 : 0.0;
    _animation = Tween<double>(begin: model.ratio, end: targetRatio).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final model = ChangeNotifierProvider.of<HorizontalSplitViewModel>(context)!;

    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        _maxHeight ??= constraints.maxHeight - _dividerWidth;
        if (_maxHeight != constraints.maxHeight) {
          _maxHeight = constraints.maxHeight - _dividerWidth;
        }

        final h1 = model.ratio * _maxHeight!;
        final h2 = (1 - model.ratio) * _maxHeight!;

        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: h1,
                child: widget.top,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: SizedBox(
                  height: _dividerWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ColoredBox(
                          color: Colors.blue,
                          child: SizedBox(
                            width: 32,
                            height: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                onPanUpdate: (DragUpdateDetails details) {
                  model.updateRatio(details.delta.dy, _maxHeight!);
                },
                onPanEnd: (_) {
                  _finalizeRatio(model);
                },
              ),
              SizedBox(
                height: h2,
                child: widget.bottom,
              ),
            ],
          ),
        );
      },
    );
  }
}
