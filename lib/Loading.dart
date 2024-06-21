import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final bool isLoading;

  const LoadingScreen({Key? key, required this.isLoading}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);

    if (widget.isLoading) {
      Timer(Duration(seconds: 2), () {
        setState(() {
          // Add your logic to stop loading after 5 seconds
          // For example, you can use a callback to change the isLoading state
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Image.asset('assets/images/logo.png', width: 100),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }
}
