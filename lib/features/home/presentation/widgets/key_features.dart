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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Instant document capture.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Secure cloud storage.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Convert image to pfd",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.offline_share,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Convert document offline.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.high_quality,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "High resolution conversion.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 30.0,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Unlimited document scan.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
