import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/MainDrawer.dart';
import 'package:auor/custom_widgets/ad_item/ad_item.dart';
import 'package:auor/custom_widgets/ad_item/ad_item1.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/marka.dart';
import 'package:auor/models/model.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/ui/ad_details/ad_details_screen.dart';
import 'package:auor/ui/home/widgets/category_item.dart';
import 'package:auor/ui/home/widgets/slider_images.dart';
import 'package:auor/ui/search/search_bottom_sheet.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider? _navigationProvider;
  Future<List<CategoryModel?>>? _categoryList;
  Future<List<CategoryModel>>? _subList;
  bool _initialRun = true;
  late HomeProvider _homeProvider;
  AnimationController? _animationController;
  late AuthProvider _authProvider;

  Future<List<City>>? _cityList;
  City? _selectedCity;

  Future<List<Marka>>? _markaList;
  Marka? _selectedMarka;

  Future<List<Model>>? _modelList;
  Model? _selectedModel;
  static const int PAGE_SIZE = 10;
  CategoryModel? _selectedSub;
  String? _selectedCat;
  bool _isLoading = false;

  String? _xx = null;
  String? omar = "";

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
      _categoryList = _homeProvider.getCategoryList(
          categoryModel: CategoryModel(
              isSelected: true,
              catId: '0',
              catName: _homeProvider.currentLang == "ar" ? "الكل" : "ALL",
              catImage: 'assets/images/all.png'),
          enableSub: false);

      _subList = _homeProvider.getSubList(
          enableSub: false,
          catId: _homeProvider.age != '' ? _homeProvider.age : "6");

      _cityList = _homeProvider.getCityList(enableCountry: false);
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();
      _initialRun = false;
    }
  }

  Widget _buildBodyItem() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        FutureBuilder<String?>(
            future: Provider.of<HomeProvider>(context, listen: false).getOmar(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: SpinKitFadingCircle(color: Colors.black),
                  );
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.waiting:
                  return Center(
                    child: SpinKitFadingCircle(color: Colors.black),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Error(
                      //  errorMessage: snapshot.error.toString(),
                      errorMessage:
                          AppLocalizations.of(context)!.translate('error'),
                    );
                  } else {
                    omar = snapshot.data;

                    return Row(
                      children: <Widget>[
                        Text(
                          "",
                          style: TextStyle(height: 0),
                        )
                      ],
                    );
                  }
              }
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            }),
        SizedBox(
          height: _height * .01,
        ),
        Column(
          children: [
            SliderImages(),
            SizedBox(
              height: _height * .01,
            ),
            Container(
                padding: EdgeInsets.only(right: 7, left: 7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: hintColor.withOpacity(0.4),
                  ),
                  color: Color(0xffFAF8F7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: _height * 0.16,
                width: _width,
                margin:
                    EdgeInsets.only(right: _width * .02, left: _width * .02),
                child: FutureBuilder<List<CategoryModel?>>(
                    future: _categoryList,
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
                                      return InkWell(
                                        onTap: () {
                                          _homeProvider
                                              .updateChangesOnCategoriesList(
                                                  index);

                                          _homeProvider.setEnableSearch(false);

                                          _homeProvider.setSelectedCat(
                                              snapshot.data![index]);
                                          print(_homeProvider.selectedCat);

                                          _selectedSub = null;
                                          _selectedMarka = null;
                                          _selectedModel = null;
                                          _selectedCity = null;
                                          _homeProvider
                                              .setSelectedSub(_selectedSub);
                                          _homeProvider
                                              .setSelectedMarka(_selectedMarka);
                                          _homeProvider
                                              .setSelectedModel(_selectedModel);
                                          _homeProvider
                                              .setSelectedCity(_selectedCity);

                                          _homeProvider.setSelectedCat(
                                              snapshot.data![index]);
                                          _homeProvider.setAge(
                                              snapshot.data![index]!.catId);

                                          _xx =
                                              _homeProvider.selectedCat!.catId;
                                          _subList = _homeProvider.getSubList(
                                              enableSub: true,
                                              catId: _homeProvider.age != ''
                                                  ? _homeProvider.age
                                                  : "6");
                                        },
                                        child: Container(
                                          width: _width * 0.22,
                                          margin: EdgeInsets.only(left: 5),
                                          child: CategoryItem(
                                            category: snapshot.data![index],
                                          ),
                                        ),
                                      );
                                    });
                                  });
                            } else {
                              return NoData(
                                  message: _homeProvider.currentLang == "ar"
                                      ? 'لاتوجد نتائج'
                                      : 'No results');
                            }
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    })),
          ],
        ),
        SizedBox(
          height: _height * .01,
        ),
        Container(
          margin: EdgeInsets.only(right: _width * .04, left: _width * .03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _homeProvider.currentLang == "ar"
                    ? "أحدث الاعلانات"
                    : "Last Ads",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: CupertinoColors.black),
              ),
              Text(
                _homeProvider.currentLang == "ar" ? "المضافة" : "added",
                style: TextStyle(color: mainAppColor),
              ),
            ],
          ),
        ),
        SizedBox(
          height: _height * .01,
        ),
        Container(
            height: _height * .50,
            width: _width,
            child:
                Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return PagewiseListView(
                scrollDirection: Axis.vertical,
                reverse: false,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                pageSize: PAGE_SIZE,
                itemBuilder: (context, Ad entry, index) {
                  var count = PAGE_SIZE;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  _animationController!.forward();
                  return Container(
                      height: 145,
                      width: _width,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdDetailsScreen(
                                          ad: entry,
                                        )));
                          },
                          child: AdItem(
                            animationController: _animationController,
                            animation: animation,
                            ad: entry,
                          )));
                },
                loadingBuilder: (context) {
                  return CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(mainAppColor));
                },
                noItemsFoundBuilder: (context) {
                  return NoData(
                    message: "لا يوجد نتائج",
                  );
                },
                pageFuture: (pageIndex) {
                  return homeProvider.enableSearch
                      ? Provider.of<HomeProvider>(context, listen: true)
                          .getAdsSearchList(pageIndex! * PAGE_SIZE, PAGE_SIZE)
                      : Provider.of<HomeProvider>(context, listen: true)
                          .getAdsList(pageIndex! * PAGE_SIZE, PAGE_SIZE);
                },
              );
            }))
      ],
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);
    var scaffoldKey = GlobalKey<ScaffoldState>();

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: mainAppColor,
      titleSpacing: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Image.asset("assets/images/menu.png"),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      title: _authProvider.currentLang == 'ar'
          ? Text(
              "الرئيسية",
              style: TextStyle(fontSize: 17),
            )
          : Text("Home", style: TextStyle(fontSize: 17)),
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (builder) {
                    return Container(
                        width: _width,
                        height: _height * 0.55,
                        child: SearchBottomSheet());
                  });
            },
            child: Image.asset(
              'assets/images/search.png',
              color: Colors.white,
            )),
      ],
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: WillPopScope(
          onWillPop: () async {
            // This dialog will exit your app on saying yes
            return (await (showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text(_homeProvider.currentLang == "ar"
                        ? 'هل انت متاكد ؟'
                        : 'are you sure ?'),
                    content: new Text(_homeProvider.currentLang == "ar"
                        ? 'هل تريد بالفعل الخروج من التطبيق ؟'
                        : 'Do you really want to exit the application?'),
                    actions: <Widget>[
                      new FloatingActionButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text(
                            _homeProvider.currentLang == "ar" ? 'لا' : 'no'),
                      ),
                      new FloatingActionButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text(
                            _homeProvider.currentLang == "ar" ? 'نعم' : 'yes'),
                      ),
                    ],
                  ),
                ) as FutureOr<bool>?)) ??
                false;
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: PreferredSize(
                child: appBar, preferredSize: Size.fromHeight(60.0)),
            drawer: MainDrawer(),
            body: _buildBodyItem(),
          )),
    );
  }
}
