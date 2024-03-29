import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';

class Blacklist1Screen extends StatefulWidget {
  @override
  _Blacklist1ScreenState createState() => _Blacklist1ScreenState();
}

class _Blacklist1ScreenState extends State<Blacklist1Screen>
    with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider? _navigationProvider;
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  HomeProvider _homeProvider = HomeProvider();
  String _userName = '';
  bool _initialRun = true;
  Future<List<Ad>>? _blacklistList;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);

      _blacklistList = _homeProvider.getBlacklist1("ssssssssssssssss");

      _initialRun = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 28),
                  child: Text("البحث برقم الاعلان / عنوان الاعلان"),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: _width * .85,
                        child: CustomTextFormField(
                          suffixIconImagePath: "assets/images/search.png",
                          suffixIconIsImage: false,
                          onChangedFunc: (text) {
                            _userName = text;
                          },
                        )),
                    Container(
                        color: mainAppColor,
                        width: _width * .1,
                        child: IconButton(
                            icon: Icon(Icons.search),
                            color: Colors.white,
                            onPressed: () async {
                              _homeProvider.setSearchKeyBlacklist(_userName);
                              setState(() {
                                _blacklistList = _homeProvider.getBlacklist1(
                                    _homeProvider.searchKeyBlacklist);
                                _homeProvider
                                    .setSearchKeyBlacklist("dqweqweqwq");
                              });
                              print(_homeProvider.searchKeyBlacklist);
                            })),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(20),
            height: _height - 100,
            width: _width,
            child: ListView(
              children: <Widget>[
                Text(
                  "نتائج البحث",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                    height: _height,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: FutureBuilder<List<Ad>>(
                        future: _blacklistList,
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
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage: "حدث خطأ ما ",
                                );
                              } else {
                                if (snapshot.data!.length > 0) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Consumer<HomeProvider>(builder:
                                            (context, homeProvider, child) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                width: _width,
                                                color: accentColor,
                                                child: Text("رقم الاعلان :- " +
                                                    snapshot
                                                        .data![index].adsId!),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                width: _width,
                                                color: accentColor,
                                                child: Text("العنوان :- " +
                                                    snapshot.data![index]
                                                        .adsTitle!),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                width: _width,
                                                color: accentColor,
                                                child: Text("السعر :- " +
                                                    snapshot.data![index]
                                                        .adsPrice!),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                width: _width,
                                                color: accentColor,
                                                child: Text("القسم :- " +
                                                    snapshot.data![index]
                                                        .adsCatName!),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                width: _width,
                                                color: accentColor,
                                                child: Text("المدينة :- " +
                                                    snapshot.data![index]
                                                        .adsCityName!),
                                              )
                                            ],
                                          );
                                        });
                                      });
                                } else {
                                  return NoData(message: 'لاتوجد نتائج');
                                }
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        })),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              decoration: BoxDecoration(
                color: mainAppColor,
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
                  Text("السلع والاعلانات الممنوعة",
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
