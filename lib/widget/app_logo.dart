import 'package:flutter/material.dart';

class AppLogo extends StatefulWidget {
  final double? width;
  final double? height;
  const AppLogo({this.width, this.height, Key? key}) : super(key: key);

  @override
  _AppLogoState createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = Tween(begin: -0.03, end: 0.03).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/github.webp'),
            RotationTransition(
              turns: _animation,
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/flutter_top.webp',),
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
