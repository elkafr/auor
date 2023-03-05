import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/hex_color.dart';

class BadgeTabBar extends StatelessWidget {
  final int notificationCount;
  final String? name;
  final IconData? image;
  final bool? isSelected;

  const BadgeTabBar({
    Key? key,
    this.isSelected,
    this.name,
    this.image,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 55,
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            image,
            size: name=="333"?50:23,
            color: isSelected! ? orangeColor : mainAppColor,
          ),
          notificationCount == 0
              ? Container()
              : Positioned.directional(
                  textDirection: TextDirection.ltr,
                  end: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: HexColor("#FF6969")),
                  ),
                )
        ],
      ),
    );
  }
}
