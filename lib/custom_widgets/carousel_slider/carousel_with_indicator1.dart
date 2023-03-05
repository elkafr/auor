import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:auor/models/slider.dart';
import 'package:auor/utils/app_colors.dart';

List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator1 extends StatefulWidget {
  final List<SliderModel>? imgList;

  const CarouselWithIndicator1({this.imgList});

  @override
  _CarouselWithIndicator1State createState() => _CarouselWithIndicator1State();
}

class _CarouselWithIndicator1State extends State<CarouselWithIndicator1> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      (widget.imgList!.length > 0)
          ? CarouselSlider.builder(
              options: CarouselOptions(
                height: 255,
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
                                widget.imgList![itemIndex].photo ?? "",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                  child: Image.network(
                    widget.imgList![itemIndex].photo ?? "",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? error) {
                      return Container();
                    },
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
