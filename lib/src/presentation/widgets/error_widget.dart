import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String imageUrl;
  final String? text;
  final String? subText;
  const CustomErrorWidget({
    super.key,
    required this.imageUrl,
    this.text,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight / 4,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(imageUrl),
            ),
          ),
        ),
        Text(
          text ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        Text(
          subText ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
