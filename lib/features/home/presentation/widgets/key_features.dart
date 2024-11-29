import 'package:flutter/material.dart';

class KeyFeatures extends StatelessWidget {
  const KeyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.camera_alt,
                size: 30.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "Instant document capture.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              const Icon(
                Icons.cloud,
                size: 30.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "Secure cloud storage.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 30.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "Convert image to pdf",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              const Icon(
                Icons.high_quality,
                size: 30.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "High resolution conversion.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
