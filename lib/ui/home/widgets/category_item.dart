import 'package:flutter/material.dart';
import 'package:auor/models/category.dart';
import 'package:auor/utils/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel? category;
  final AnimationController? animationController;
  final Animation? animation;

  const CategoryItem(
      {Key? key, this.category, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(


            margin: EdgeInsets.only(top: constraints.maxHeight * 0.06),
            height: constraints.maxHeight* 0.7,
            width: constraints.maxHeight,

            decoration: BoxDecoration(
              color: mainAppColor,
              border: Border.all(
                width: 1.0,
                color: category!.isSelected ? accentColor : Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: category!.catId != '0'
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Image.network(
                      category!.catImage!,
                      fit: BoxFit.fill,

                    ))
                : Image.asset(category!.catImage!),
          ),

          Center(
            child: Container(



              alignment: Alignment.center,
              width :constraints.maxWidth,
              margin: EdgeInsets.only(right:constraints.maxWidth * .035 ),

              child: Text(
                category!.catName!,
                style: TextStyle(
                    color: mainAppColor,
                    fontSize: category!.catName!.length > 12 ? 12 : 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      );
    });
  }
}
