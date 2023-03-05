import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/ad_item/ad_item.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/section_ads_provider.dart';
import 'package:auor/ui/ad_details/ad_details_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';

class SectionAdsScreen extends StatefulWidget {
  final String? catId;
  final String? adCatName;

  const SectionAdsScreen({Key? key, this.catId, this.adCatName})
      : super(key: key);

  @override
  _SectionAdsScreenState createState() => _SectionAdsScreenState();
}

class _SectionAdsScreenState extends State<SectionAdsScreen>
    with TickerProviderStateMixin {
  double _height = 0, _width = 0;

  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Container(
          height: _height - 80,
          width: _width,
          child: FutureBuilder<List<Ad>>(
              future: Provider.of<SectionAdsProvider>(context, listen: false)
                  .getAdsList(widget.catId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.waiting:
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Error(
                        errorMessage: snapshot.error.toString(),
                        // errorMessage: "حدث خطأ ما ",
                      );
                    } else {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              var count = snapshot.data!.length;
                              var animation =
                                  Tween(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              );
                              _animationController!.forward();
                              return Container(
                                  height: 120,
                                  width: _width,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdDetailsScreen(
                                                      ad: snapshot.data![index],
                                                    )));
                                      },
                                      child: AdItem(
                                        animationController:
                                            _animationController,
                                        animation: animation,
                                        ad: snapshot.data![index],
                                      )));
                            });
                      } else {
                        return NoData(
                            message: AppLocalizations.of(context)!
                                .translate('no_results'));
                      }
                    }
                }
                return Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                );
              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              decoration: BoxDecoration(
                color: mainAppColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.currentLang == 'ar'
                            ? Image.asset(
                                'assets/images/back.png',

                              )
                            : Transform.rotate(
                                angle: 180 * math.pi / 180,
                                child: Image.asset(
                                  'assets/images/back.png',

                                ));
                      },
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(widget.adCatName!,
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
