import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  static const low = 0.6, high = 3.0;
  var brightness = low;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            final mq = MediaQuery.of(context);
            final height = mq.size.height - mq.padding.top - mq.padding.bottom,
                width = mq.size.width - mq.padding.left - mq.padding.right;
            print('Height $height');
            print('Width $width');

            final lampSize = min(height * 0.15, width * 0.15);
            print('LampSize $lampSize');

            final angle = _poleAngle(
                  width: width,
                  lampSize: lampSize,
                ),
                poleLength =
                    sqrt(pow(width * 0.537 - lampSize, 2) + pow(lampSize, 2));
            print('Pole length: $poleLength');

            return SafeArea(
              child: Stack(
                children: [
                  // Light
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: brightness,
                        center: _lightAlignment(
                          width: width,
                          height: height,
                          lampSize: lampSize,
                        ),
                        colors: const [Color(0xffFFC107), Colors.transparent],
                        stops: const [0.0, 0.9],
                      ),
                    ),
                  ),

                  // Back shadow
                  Align(
                    alignment: Alignment.topLeft,
                    child: ClipPath(
                      clipper: BackShadow(),
                      child: Container(
                        height: lampSize * 1.3,
                        width: lampSize * 1.3,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: lampSize * 0.008,
                            center: Alignment.topLeft,
                            colors: const [Colors.black87, Colors.transparent],
                            stops: const [0.0, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pole
                  Align(
                    alignment: const Alignment(0, -1),
                    child: Transform.rotate(
                      angle: angle,
                      alignment: Alignment.topRight,
                      child: Container(
                        height: poleLength,
                        width: lampSize * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(lampSize * 0.3)),
                          gradient: const LinearGradient(
                            colors: [Color(0xff000000), Color(0x50424242)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Lampshade
                  Align(
                    alignment: _lampAlignment(
                      width: width,
                      height: height,
                      lampSize: lampSize,
                    ),
                    child: ClipPath(
                      clipper: Lampshade(),
                      // You found the switch!
                      child: GestureDetector(
                        onTap: _toggleSwitch,
                        child: Container(
                          height: lampSize,
                          width: lampSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(lampSize * 0.3),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff778974),
                                Color(0x90778974),
                                Color(0x60607D8B)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment(0, 0),
                              stops: [0.4, 0.9, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _isLampOn() ? 'Happy Diwali 🪔' : '',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isLampOn() => brightness == high;

  void _toggleSwitch() => setState(() {
        brightness = brightness == low ? high : low;
      });

  Alignment _lightAlignment({
    required double width,
    required double height,
    required double lampSize,
  }) {
    final x = -((width - lampSize * 2) / width),
        y = -((height - lampSize * 2) / height);
    print('Light Alignment($x, $y)');
    return Alignment(x, y);
  }

  Alignment _lampAlignment({
    required double width,
    required double height,
    required double lampSize,
  }) {
    final x = -((width - lampSize) / width),
        y = -((height - lampSize) / height);
    print('Lamp Alignment($x, $y)');
    return Alignment(x, y);
  }

  double _poleAngle({
    required double width,
    required double lampSize,
  }) {
    final a = pi * 0.5 - atan(lampSize / (width - lampSize));
    print('Pole Angle $a');
    return a;
  }
}

class Lampshade extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(Lampshade oldClipper) => false;
}

class BackShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BackShadow oldClipper) => false;
}
