import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:provider/provider.dart';

class MyFollowItem extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;
  final Ad? ad;

  const MyFollowItem(
      {Key? key, this.animationController, this.animation, this.ad})
      : super(key: key);

  @override
  _MyFollowItemState createState() => _MyFollowItemState();
}

class _MyFollowItemState extends State<MyFollowItem> {
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider? _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: widget.animation as Animation<double>,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 50 * (1.0 - widget.animation!.value), 0.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15),
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: constraints.maxWidth * 0.62,
                                    child: Text(
                                      widget.ad!.adsTitle!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _isLoading
                            ? Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              )
                            : Container()
                      ],
                    );
                  })));
        });
  }
}
