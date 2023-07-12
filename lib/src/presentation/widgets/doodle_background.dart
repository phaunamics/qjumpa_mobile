import 'package:flutter/material.dart';

class DoodleBackground extends StatelessWidget {
  final double opacity;
  const DoodleBackground({
    super.key,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset(
        //   'assets/splashscreen.jpeg',
        //   width: 430,
        //   height: 930,
        //   scale: 1,
        // ),
        Transform.rotate(
          angle: 0.07,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/splashscreen.jpeg'),
                  fit: BoxFit.cover,
                  opacity: 0.4),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/splashscreen.jpeg'),
                fit: BoxFit.cover,
                opacity: 0.5),
          ),
        ),
      ],
    );
  }
}
