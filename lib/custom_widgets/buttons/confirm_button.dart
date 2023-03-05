import 'package:flutter/material.dart';
import 'package:auor/utils/app_colors.dart';

class ConfirmButton extends StatelessWidget {
  final String? btnLbl;
  final Function? onPressedFunction;

  const ConfirmButton({Key? key, this.btnLbl, this.onPressedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        child: Builder(
            builder: (context) => InkWell(
                  onTap: () {
                    onPressedFunction!();
                  },
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                        width: double.infinity,
                        color: mainAppColor,
                        alignment: Alignment.center,
                        child: new Text(
                          btnLbl!,
                          style: Theme.of(context).textTheme.button,
                        )),
                  ),
                )));
  }
}
