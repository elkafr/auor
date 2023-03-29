import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/ui/edit_ad/edit_ad_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';

class MyAdItem extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;
  final Ad? ad;

  const MyAdItem({Key? key, this.animationController, this.animation, this.ad})
      : super(key: key);

  @override
  _MyAdItemState createState() => _MyAdItemState();
}

class _MyAdItemState extends State<MyAdItem> {
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  late AuthProvider _authProvider;
  late HomeProvider _homeProvider;

  Widget _buildItem(String? title, String imgPath) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          width: 20,
        ),
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Container(
              margin: EdgeInsets.only(
                  left: authProvider.currentLang == 'ar' ? 0 : 2,
                  right: authProvider.currentLang == 'ar' ? 2 : 0),
              child: Text(
                title!,
                style: TextStyle(
                    fontSize: title.length > 1 ? 12 : 12,
                    color: Color(0xffC5C5C5)),
                overflow: TextOverflow.ellipsis,
              ));
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
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
                          margin: EdgeInsets.only(
                              left: constraints.maxWidth * 0.02,
                              right: constraints.maxWidth * 0.02,
                              bottom: constraints.maxHeight * 0.1),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0))),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  _authProvider.currentLang ==
                                                          'ar'
                                                      ? 10
                                                      : 0),
                                              bottomRight: Radius.circular(
                                                  _authProvider.currentLang ==
                                                          'ar'
                                                      ? 10
                                                      : 0),
                                              bottomLeft: Radius.circular(
                                                (_authProvider.currentLang !=
                                                        'ar'
                                                    ? 10
                                                    : 0),
                                              ),
                                              topLeft: Radius.circular(
                                                  (_authProvider.currentLang !=
                                                          'ar'
                                                      ? 10
                                                      : 0))),
                                          child: Image.network(
                                            widget.ad!.adsPhoto!,
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.3,
                                            fit: BoxFit.cover,
                                          ))),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                constraints.maxHeight * 0.04,
                                            horizontal:
                                                constraints.maxWidth * 0.02),
                                        width: constraints.maxWidth * 0.62,
                                        child: Text(
                                          widget.ad!.adsTitle!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              height: 1.4),
                                          maxLines: 3,
                                        ),
                                      ),
                                      Container(
                                        width: constraints.maxWidth * 0.58,
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                constraints.maxWidth * 0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            _buildItem(widget.ad!.adsUserName,
                                                'assets/images/user.png'),
                                            _buildItem(widget.ad!.adsCityName,
                                                'assets/images/city.png'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        width: constraints.maxWidth * 0.58,
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                constraints.maxWidth * 0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            _buildItem(widget.ad!.adsFullDate,
                                                'assets/images/time.png'),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                constraints.maxWidth * 0.01,
                                            vertical: 0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      constraints.maxWidth *
                                                          0.02),
                                              width:
                                                  constraints.maxWidth * 0.22,
                                              child: CustomButton(
                                                height: 35,
                                                defaultMargin: false,
                                                btnLbl: AppLocalizations.of(
                                                        context)!
                                                    .translate('edit'),
                                                btnColor: mainAppColor,
                                                onPressedFunction: () {
                                                  _homeProvider
                                                      .setSelectedEditAd(
                                                          widget.ad);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditAdScreen(
                                                                ad: widget.ad,
                                                              )));
                                                },
                                              ),
                                            ),
                                            Container(
                                                width:
                                                    constraints.maxWidth * 0.22,
                                                child: CustomButton(
                                                  onPressedFunction: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    final results =
                                                        await _apiProvider.post(
                                                            Urls.DELETE_AD_URL +
                                                                "?id=${widget.ad!.adsId}&user_id=${_authProvider.currentUser!.userId}&api_lang=${_authProvider.currentLang}");

                                                    setState(() =>
                                                        _isLoading = false);
                                                    if (results['response'] ==
                                                        "1") {
                                                      Commons.showToast(context,
                                                          message: results[
                                                              "message"]);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/my_ads_screen');
                                                    } else {
                                                      Commons.showError(context,
                                                          results["message"]);
                                                    }
                                                  },
                                                  height: 35,
                                                  defaultMargin: false,
                                                  btnColor: orangeColor,
                                                  btnStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  btnLbl: AppLocalizations.of(
                                                          context)!
                                                      .translate('delete'),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
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
