import 'package:carousel_slider/carousel_slider.dart';
import 'package:document_scanner/features/home/presentation/widgets/key_features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  static String name = 'Home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250.0,
              autoPlay: true,
              enableInfiniteScroll: true,
              viewportFraction: 1,
            ),
            items: [
              "assets/images/banner_1.png",
              "assets/images/banner_2.jpg",
              "assets/images/banner_3.png",
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      i,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const KeyFeatures(),
          const SizedBox(
            height: 16.0,
          ),
          // const HowItWorks(),
        ],
      ),
    );
  }
}
