// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

class ImageCarouselSlider extends StatefulWidget {
  const ImageCarouselSlider({super.key});

  @override
  State<ImageCarouselSlider> createState() => _ImageCarouselSliderState();
}

class _ImageCarouselSliderState extends State<ImageCarouselSlider> {

  final List<String> imgList  = [
    'images/blue.jpg',
    'images/gline.jpg',
    'images/gold.jpg',
    'images/golive.jpg',
    'images/green.jpg',
    'images/gshade.jpg',
    'images/marun.jpg',
    'images/mshade.jpg',
    'images/yblack.jpg',
    'images/yellow.jpg',
  ];

  final CarouselSliderController _carouselController = CarouselSliderController();


  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        // height: 400,
        // enlargeCenterPage: true,
        // autoPlay: true,
        // aspectRatio: 16/9,
        // autoPlayCurve: Curves.fastOutSlowIn,
        // enableInfiniteScroll: true,
        // autoPlayAnimationDuration: Duration(milliseconds: 800),
        // viewportFraction: 0.8,
        height: MediaQuery.of(context).size.height, // Full screen height
        viewportFraction: 1.0, // Full screen width
        enlargeCenterPage: false, // Center page should not be enlarged
        autoPlay: true,
        aspectRatio: 16/9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        // onPageChanged: _onCarouselChange,
      ),
      items: imgList.map((item) => Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        width: MediaQuery.of(context).size.width, // Full width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          image: DecorationImage(
            image: AssetImage(item),
            fit: BoxFit.cover,
          ),
        ),
      )).toList(),
      // items: videoList.map((videoPath) {
      //   final controller = _controllers[videoPath];
      //   if (controller != null && controller.value.isInitialized) {
      //     return Container(
      //       width: MediaQuery.of(context).size.width,
      //       child: AspectRatio(
      //         aspectRatio: controller.value.aspectRatio,
      //         child: VideoPlayer(controller),
      //       ),
      //     );
      //   } else {
      //     // Handle the case where the controller is not initialized yet
      //     return Container(
      //       width: MediaQuery.of(context).size.width,
      //       child: Center(child: CircularProgressIndicator()),
      //     );
      //   }
      // }).toList(),
    );
  }
}

