import 'package:flutter/material.dart';

class SlidingAnimation extends StatefulWidget {
  final Widget child;
  final bool active;
  SlidingAnimation({Key? key, required this.child, required this.active})
      : super(key: key);

  @override
  State<SlidingAnimation> createState() => _SlidingAnimationState();
}

class _SlidingAnimationState extends State<SlidingAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  Animation<Offset>? _slideAnimation;

  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.active ? _controller!.forward() : _controller!.reverse();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(
        minHeight: widget.active ? 60 : 0,
        maxHeight: widget.active ? 120 : 0,
      ),
      curve: Curves.easeIn,
      child: FadeTransition(
          opacity: _opacityAnimation!,
          child:
              SlideTransition(position: _slideAnimation!, child: widget.child)),
    );
  }
}
