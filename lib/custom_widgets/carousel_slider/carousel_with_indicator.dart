import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:auor/models/slider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  final List<SliderModel>? imgList;

  const CarouselWithIndicator({this.imgList});

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      (widget.imgList!.length > 0)
          ? CarouselSlider.builder(
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                onPageChanged:
                    (int index, CarouselPageChangedReason changeReason) {
                  setState(() {
                    _current = index;
                  });
                },
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                aspectRatio: MediaQuery.of(context).size.aspectRatio * 4.5,
              ),
              itemCount: widget.imgList!.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                onTap: () {
                  launch(widget.imgList![itemIndex].url!);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.imgList![itemIndex].photo!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? error) {
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      Positioned(
        bottom: 0,
        left: (MediaQuery.of(context).size.width * .45) -
            ((widget.imgList!.length / 2) * 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Iterable.generate(widget.imgList!.length)
                .map((e) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == e ? mainAppColor : hintColor),
                    ))
                .toList()),
      ),
    ]);
  }
}
