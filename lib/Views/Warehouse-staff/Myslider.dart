// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:untitled/Views/HomeManager.dart';
import 'package:untitled/Views/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'CommitSale.dart';
import 'package:carousel_slider/carousel_state.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        child: Center(child: Text('Rectangular Box 1')),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Lorem ipsum dolor sit amet.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
         color: Color.fromARGB(255, 3, 94, 147),
        ),
        // child: HeroSec("Today", "Aug 22"),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 3, 94, 147),
        ),
        // child: HeroSec("Yesterday", "Aug 21"),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
      child: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items: carouselItems,
                options: CarouselOptions(
                  autoPlayCurve: Curves.decelerate,
                  autoPlay: true,
                  height: 180,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  },
                ),
              ),
              Positioned(
                top: 12.0,
                right: 40.0,
                child: CarouselStatus(
                  itemCount: carouselItems.length,
                  currentSlide: _currentSlide,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class CarouselStatus extends StatelessWidget {
  final int itemCount;
  final int currentSlide;

  const CarouselStatus(
      {Key? key, required this.itemCount, required this.currentSlide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < itemCount; index++)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentSlide == index
                  ? const Color.fromARGB(255, 30, 69, 224)
                  : Colors.white,
            ),
          ),
      ],
    );
  }
}

class HeroSec extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeroSec(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
