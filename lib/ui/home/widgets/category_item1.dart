import 'package:flutter/material.dart';
import 'package:auor/models/category.dart';
import 'package:auor/ui/home/cats_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/providers/home_provider.dart';

class CategoryItem1 extends StatelessWidget {
  final CategoryModel? category;
  final AnimationController? animationController;
  final Animation? animation;

  const CategoryItem1(
      {Key? key, this.category, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
                margin: EdgeInsets.only(top: constraints.maxHeight * 0.05),
                width: constraints.maxWidth * 0.8,
                height: constraints.maxHeight * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xffF3F3F3),
                  border: Border.all(
                    width: 1.0,
                    color: Color(0xffF3F3F3),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                        category!.catImage != null ? category!.catImage! : "ss",
                        fit: BoxFit.fill))),
          ),
          Container(
            alignment: Alignment.center,
            width: constraints.maxWidth,
            child: Text(
              category!.catName != null ? category!.catName! : "",
              style: TextStyle(color: Colors.black, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      );
    });
  }
}
