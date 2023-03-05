// ignore_for_file: non_constant_identifier_names, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../models/slider.dart';
import '../../../utils/app_colors.dart';

Widget SliderWidget({List<SliderModel>? imageList, var sliderKey, context}) {
  return Container(
    height: MediaQuery.of(context).size.height * .25,
    width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: CarouselSlider.builder(
        key: sliderKey,
        unlimitedMode: true,
        slideTransform: const BackgroundToForegroundTransform(),
        enableAutoSlider: false,
        slideIndicator: CircularSlideIndicator(
          indicatorRadius: 5,
          itemSpacing: 12,
          currentIndicatorColor: mainAppColor,
          indicatorBackgroundColor: Colors.black,
          padding: EdgeInsets.only(bottom: 12),
        ),
        slideBuilder: (index) {
          return GestureDetector(

            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0)), //this right here
                      child: Container(
                        child: GestureZoomBox(
                          maxScale: 5.0,
                          doubleTapScale: 2.0,
                          duration: Duration(milliseconds: 200),
                          onPressed: () => Navigator.pop(context),
                          child: Image.network(
                            imageList![index].photo!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  });
            },

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageList![index].photo!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * .9,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('error');
                },
              ),
            ),
          );
        },
        itemCount: imageList!.length),
  );
}
