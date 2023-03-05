// ignore_for_file: unrelated_type_equality_checks

import 'package:auor/shared_preferences/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/favourite_provider.dart';
import 'package:auor/ui/favourite/favourite_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';

class AdItem extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;
  final bool insideFavScreen;
  final Ad? ad;

  const AdItem(
      {Key? key,
      this.insideFavScreen = false,
      this.ad,
      this.animationController,
      this.animation})
      : super(key: key);
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  double _height = 0, _width = 0;
  bool _initialRun = true;
  AuthProvider? _authProvider;
  FavouriteProvider? _favouriteProvider;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _favouriteProvider = Provider.of<FavouriteProvider>(context);

      if (widget.ad!.adsIsFavorite == 1 && _authProvider!.currentUser != null) {
        _favouriteProvider!.addItemToFavouriteAdsList(
            widget.ad!.adsId, widget.ad!.adsIsFavorite);
      }
      print('favourite' + widget.ad!.adsIsFavorite.toString());
      _initialRun = false;
    }
  }

  Widget _buildItem(String title, String imgPath) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          height: _height * 0.15,
          width: 20,
        ),
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Container(
              margin: EdgeInsets.only(
                  left: authProvider.currentLang == 'ar' ? 0 : 2,
                  right: authProvider.currentLang == 'ar' ? 2 : 0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: title.length > 1 ? 10 : 12,
                    color: Color(0xffC5C5C5)),
                overflow: TextOverflow.ellipsis,
              ));
        })
      ],
    );
  }

  @override
  Widget build(BuildContext? context) {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext? context, Widget? child) {
          return FadeTransition(
              opacity: widget.animation as Animation<double>,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 50 * (1.0 - widget.animation!.value), 0.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    _height = constraints.maxHeight;
                    _width = constraints.maxWidth;
                    return Container(
                      margin: EdgeInsets.only(
                          left: constraints.maxWidth * 0.02,
                          right: constraints.maxWidth * 0.02,
                          bottom: constraints.maxHeight * 0.1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    SizedBox(
                                      height: 10,
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
                                          _buildItem(widget.ad!.adsCityName!,
                                              'assets/images/city.png'),
                                          _buildItem(widget.ad!.adsFullDate!,
                                              'assets/images/time.png')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
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
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      constraints.maxWidth *
                                                          0.02,
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Cairo',
                                                      color: Colors.black),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: _authProvider!
                                                                    .currentLang ==
                                                                'ar'
                                                            ? " قسم : "
                                                            : " Category "),
                                                    new TextSpan(
                                                        text: widget
                                                            .ad!.adsCatName),
                                                  ],
                                                ),
                                              )),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      constraints.maxWidth *
                                                          0.02,
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Cairo',
                                                      color: Colors.black),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: widget
                                                            .ad!.adsPrice),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            _authProvider!.currentLang == 'ar'
                                                ? 1
                                                : 1),
                                        bottomRight: Radius.circular(
                                            _authProvider!.currentLang == 'ar'
                                                ? 1
                                                : 1),
                                        bottomLeft: Radius.circular(
                                          (_authProvider!.currentLang != 'ar'
                                              ? 1
                                              : 1),
                                        ),
                                        topLeft: Radius.circular(
                                            (_authProvider!.currentLang != 'ar'
                                                ? 1
                                                : 1)))),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            _authProvider!.currentLang == 'ar'
                                                ? 1
                                                : 1),
                                        bottomRight: Radius.circular(
                                            _authProvider!.currentLang == 'ar'
                                                ? 1
                                                : 1),
                                        bottomLeft: Radius.circular(
                                          (_authProvider!.currentLang != 'ar'
                                              ? 1
                                              : 1),
                                        ),
                                        topLeft: Radius.circular(
                                            (_authProvider!.currentLang != 'ar'
                                                ? 1
                                                : 1))),
                                    child: Image.network(
                                      widget.ad!.adsPhoto!,
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth * 0.3,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ],
                          ),
                          _authProvider!.currentLang == 'ar'
                              ? Positioned(
                                  left: 5,
                                  top: 3,
                                  child: Container(
                                      height: _height * 0.25,
                                      width: _width * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38,
                                      ),
                                      child: _authProvider!.currentUser == null
                                          ? GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context, '/login_screen'),
                                              child: Center(
                                                  child: Icon(
                                                Icons.favorite_border,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                            )
                                          : Consumer<FavouriteProvider>(builder:
                                              (context, favouriteProvider,
                                                  child) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (favouriteProvider
                                                      .favouriteAdsList
                                                      .containsKey(
                                                          widget.ad!.adsId)) {
                                                    favouriteProvider
                                                        .removeFromFavouriteAdsList(
                                                            widget.ad!.adsId);
                                                    await _apiProvider.get(Urls
                                                            .REMOVE_AD_from_FAV_URL +
                                                        "ads_id=${widget.ad!.adsId}&user_id=${_authProvider!.currentUser!.userId}");
                                                    if (widget
                                                        .insideFavScreen) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FavouriteScreen()));
                                                    }
                                                  } else {
                                                    print(
                                                        'user id ${_authProvider!.currentUser!.userId}');
                                                    print(
                                                        'ad id ${widget.ad!.adsId}');
                                                    favouriteProvider
                                                        .addToFavouriteAdsList(
                                                            widget.ad!.adsId,
                                                            1);
                                                    await _apiProvider.post(
                                                        Urls.ADD_AD_TO_FAV_URL,
                                                        body: {
                                                          "user_id":
                                                              _authProvider!
                                                                  .currentUser!
                                                                  .userId,
                                                          "ads_id":
                                                              widget.ad!.adsId
                                                        });
                                                  }
                                                },
                                                child: Center(
                                                  child: favouriteProvider
                                                          .favouriteAdsList
                                                          .containsKey(
                                                              widget.ad!.adsId)
                                                      ? SpinKitPumpingHeart(
                                                          color: accentColor,
                                                          size: 18,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              );
                                            })),
                                )
                              : Positioned(
                                  right: 5,
                                  top: 3,
                                  child: Container(
                                      height: _height * 0.25,
                                      width: _width * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38,
                                      ),
                                      child: _authProvider!.currentUser == null
                                          ? GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context, '/login_screen'),
                                              child: Center(
                                                  child: Icon(
                                                Icons.favorite_border,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                            )
                                          : Consumer<FavouriteProvider>(builder:
                                              (context, favouriteProvider,
                                                  child) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (favouriteProvider
                                                      .favouriteAdsList
                                                      .containsKey(
                                                          widget.ad!.adsId)) {
                                                    favouriteProvider
                                                        .removeFromFavouriteAdsList(
                                                            widget.ad!.adsId);
                                                    await _apiProvider.get(Urls
                                                            .REMOVE_AD_from_FAV_URL +
                                                        "ads_id=${widget.ad!.adsId}&user_id=${_authProvider!.currentUser!.userId}");
                                                    if (widget
                                                        .insideFavScreen) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FavouriteScreen()));
                                                    }
                                                  } else {
                                                    print(
                                                        'user id ${_authProvider!.currentUser!.userId}');
                                                    print(
                                                        'ad id ${widget.ad!.adsId}');
                                                    favouriteProvider
                                                        .addToFavouriteAdsList(
                                                            widget.ad!.adsId,
                                                            1);
                                                    await _apiProvider.post(
                                                        Urls.ADD_AD_TO_FAV_URL,
                                                        body: {
                                                          "user_id":
                                                              _authProvider!
                                                                  .currentUser!
                                                                  .userId,
                                                          "ads_id":
                                                              widget.ad!.adsId
                                                        });
                                                  }
                                                },
                                                child: Center(
                                                  child: favouriteProvider
                                                          .favouriteAdsList
                                                          .containsKey(
                                                              widget.ad!.adsId)
                                                      ? SpinKitPumpingHeart(
                                                          color: accentColor,
                                                          size: 18,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              );
                                            })),
                                )
                        ],
                      ),
                    );
                  })));
        });
  }
}
