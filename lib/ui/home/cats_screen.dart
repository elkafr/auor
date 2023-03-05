import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auor/custom_widgets/ad_item/ad_item1.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/marka.dart';
import 'package:auor/models/model.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/providers/navigation_provider.dart';
import 'package:auor/ui/ad_details/ad_details_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';

class CatsScreen extends StatefulWidget {
  final String? iddd;
  final int? iddd1;

  CatsScreen({this.iddd, this.iddd1});

  @override
  State<StatefulWidget> createState() {
    return new _CatsScreenState(iddd: this.iddd, iddd1: this.iddd1);
  }
}

class _CatsScreenState extends State<CatsScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider? _navigationProvider;
  Future<List<CategoryModel?>>? _categoryList;
  Future<List<CategoryModel>>? _subList;
  bool _initialRun = true;
  late HomeProvider _homeProvider;
  AnimationController? _animationController;
  AuthProvider? _authProvider;
  final String? iddd;
  final int? iddd1;

  _CatsScreenState({this.iddd, this.iddd1});

  Future<List<City>>? _cityList;
  City? _selectedCity;

  Future<List<Marka>>? _markaList;
  Marka? _selectedMarka;

  Future<List<Model>>? _modelList;
  Model? _selectedModel;

  CategoryModel? _selectedSub;
  String? _selectedCat;
  bool _isLoading = false;

  String? _xx = null;
  String omar = "";

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
      //_homeProvider.updateChangesOnCategoriesList(iddd1);
      _categoryList = _homeProvider.getCategoryList1(
          categoryModel: CategoryModel(isSelected: false), enableSub: false);

      _subList =
          _homeProvider.getSubList(enableSub: true, catId: _homeProvider.age);

      _cityList = _homeProvider.getCityList(enableCountry: false);
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();
      _initialRun = false;
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        /* FutureBuilder<String>(
            future: Provider.of<HomeProvider>(context,
                listen: false)
                .getOmar() ,
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
                      errorMessage: AppLocalizations.of(context).translate('error'),
                    );
                  } else {
                    omar=snapshot.data;

                    return  Row(
                      children: <Widget>[

                        Text("",style: TextStyle(height: 0),)
                      ],
                    );
                  }
              }
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            }), */

        /*   Container(
            height: _height * 0.14,

            color: Colors.white,
            padding: EdgeInsets.fromLTRB(5,5,5,0),
            child: FutureBuilder<List<CategoryModel>>(
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
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {

                                return Consumer<HomeProvider>(
                                    builder: (context, homeProvider, child) {
                                      return InkWell(
                                        onTap: (){


                                          homeProvider
                                              .updateChangesOnCategoriesList(index);

                                          homeProvider.setEnableSearch(false);

                                          _homeProvider.setSelectedCat(snapshot.data[index]);
                                          print(_homeProvider.selectedCat);

                                          _selectedSub=null;
                                          _selectedMarka=null;
                                          _selectedModel=null;
                                          _selectedCity=null;
                                          _homeProvider.setSelectedSub(_selectedSub);
                                          _homeProvider.setSelectedMarka(_selectedMarka);
                                          _homeProvider.setSelectedModel(_selectedModel);
                                          _homeProvider.setSelectedCity(_selectedCity);



                                          _homeProvider.setSelectedCat(snapshot.data[index]);
                                          _homeProvider.setAge(snapshot.data[index].catId);

                                          _xx=_homeProvider.selectedCat.catId;
                                          _subList = _homeProvider.getSubList(enableSub: true,catId:_homeProvider.age!=''?_homeProvider.age:"6");



                                        },
                                        child: Container(
                                          width: _width * 0.23,
                                          child: CategoryItem(
                                            category: snapshot.data[index],
                                          ),
                                        ),
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
                })), */

        Container(
          height: 15,
        ),
        Container(
            height: (_homeProvider.selectedCat != null &&
                    _homeProvider.selectedCat!.catId == "1")
                ? _height * 0.97
                : _height * 0.97,
            width: _width,
            child:
                Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return FutureBuilder<List<Ad>>(
                  future: homeProvider.enableSearch
                      ? Provider.of<HomeProvider>(context, listen: true)
                          .getAdsSearchList111()
                      : Provider.of<HomeProvider>(context, listen: true)
                          .getAdsList111(),
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
                            //errorMessage: "حدث خطأ ما ",
                          );
                        } else {
                          if (snapshot.data!.length > 0) {
                            return GridView.builder(
                                itemCount: snapshot.data!.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: (1 / 1),
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1.6,
                                ),
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
                                      height: 145,
                                      width: _width,
                                      child: InkWell(
                                          onTap: () {
                                            _homeProvider.setCurrentAds(
                                                snapshot.data![index].adsId);
                                            _homeProvider.setOmarKey(omar);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdDetailsScreen(
                                                          ad: snapshot
                                                              .data![index],
                                                        )));
                                          },
                                          child: AdItem1(
                                            animationController:
                                                _animationController,
                                            animation: animation,
                                            ad: snapshot.data![index],
                                          )));
                                });
                          } else {
                            return NoData(message: 'لاتوجد نتائج');
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  });
            }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
      leading: IconButton(
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
      title: Text(
        _homeProvider.catName,
        style: TextStyle(fontSize: 16),
      ),
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
                        height: _height * 0.5,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Container(
                                  height: constraints.maxHeight,
                                  width: constraints.maxWidth,
                                  child: ListView(children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          color: mainAppColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                        ),
                                        child: Text(
                                          _homeProvider.currentLang == "ar"
                                              ? "فرز ب"
                                              : "Filter by",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )),
                                    SizedBox(
                                      height: _height * .06,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: _width * .49,
                                            child: FutureBuilder<List<City>>(
                                              future: _cityList,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.hasData) {
                                                    var cityList = snapshot
                                                        .data!
                                                        .map((item) {
                                                      return new DropdownMenuItem<
                                                          City>(
                                                        child: new Text(
                                                            item.cityName!),
                                                        value: item,
                                                      );
                                                    }).toList();
                                                    cityList.insert(
                                                        0,
                                                        DropdownMenuItem<City>(
                                                          child: new Text(
                                                              _homeProvider
                                                                          .currentLang ==
                                                                      "ar"
                                                                  ? "كل المدن"
                                                                  : "All cities"),
                                                        ));
                                                    return DropDownListSelector(
                                                      dropDownList: cityList,
                                                      hint: _homeProvider
                                                                  .currentLang ==
                                                              'ar'
                                                          ? 'كافة المناطق'
                                                          : 'All Regions',
                                                      onChangeFunc: (newValue) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        setState(() {
                                                          _selectedCity =
                                                              newValue;
                                                          _homeProvider
                                                              .setEnableSearch(
                                                                  true);
                                                          _homeProvider
                                                              .setSelectedCity(
                                                                  newValue);
                                                        });
                                                      },
                                                      value: _selectedCity,
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "${snapshot.error}");
                                                  }
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      "${snapshot.error}");
                                                }

                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                            ),
                                          ),
                                          (_homeProvider.selectedCat != null &&
                                                  _homeProvider
                                                          .selectedCat!.catId !=
                                                      "0")
                                              ? Container(
                                                  width: _width * .49,
                                                  child: FutureBuilder<
                                                      List<CategoryModel>>(
                                                    future: _subList,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.hasData) {
                                                          var cityList =
                                                              snapshot.data!
                                                                  .map((item) {
                                                            return new DropdownMenuItem<
                                                                CategoryModel>(
                                                              child: new Text(
                                                                  item.catName!),
                                                              value: item,
                                                            );
                                                          }).toList();
                                                          //cityList.removeAt(0);
                                                          return DropDownListSelector(
                                                            dropDownList:
                                                                cityList,
                                                            hint: _homeProvider
                                                                        .currentLang ==
                                                                    'ar'
                                                                ? 'القسم الفرعي'
                                                                : 'Sub Category',
                                                            onChangeFunc:
                                                                (newValue) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              setState(() {
                                                                _selectedSub =
                                                                    newValue;
                                                                _homeProvider
                                                                    .setEnableSearch(
                                                                        true);
                                                                _homeProvider
                                                                    .setSelectedSub(
                                                                        newValue);
                                                              });
                                                            },
                                                            value: _selectedSub,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              "${snapshot.error}");
                                                        }
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            "${snapshot.error}");
                                                      }

                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  ),
                                                )
                                              : Text(
                                                  ' ',
                                                  style: TextStyle(height: 0),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _homeProvider.selectedCat!.catId !=
                                                  '1'
                                              ? Text(
                                                  "",
                                                  style: TextStyle(height: 0),
                                                )
                                              : Container(
                                                  width: _width * .49,
                                                  child: FutureBuilder<
                                                      List<Marka>>(
                                                    future: _markaList,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.hasData) {
                                                          var markaList =
                                                              snapshot.data!
                                                                  .map((item) {
                                                            return new DropdownMenuItem<
                                                                Marka>(
                                                              child: new Text(item
                                                                  .markaName!),
                                                              value: item,
                                                            );
                                                          }).toList();
                                                          return DropDownListSelector(
                                                            dropDownList:
                                                                markaList,
                                                            hint: _homeProvider
                                                                        .currentLang ==
                                                                    'ar'
                                                                ? 'المصنع'
                                                                : 'Marka',
                                                            onChangeFunc:
                                                                (newValue) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              setState(() {
                                                                _selectedMarka =
                                                                    newValue;
                                                                _homeProvider
                                                                    .setEnableSearch(
                                                                        true);
                                                                _homeProvider
                                                                    .setSelectedMarka(
                                                                        newValue);
                                                              });
                                                            },
                                                            value:
                                                                _selectedMarka,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              "${snapshot.error}");
                                                        }
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            "${snapshot.error}");
                                                      }

                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  ),
                                                ),

                                          _homeProvider.selectedCat!.catId !=
                                                  '1'
                                              ? Text(
                                                  "",
                                                  style: TextStyle(height: 0),
                                                )
                                              : Container(
                                                  width: _width * .49,
                                                  child: FutureBuilder<
                                                      List<Model>>(
                                                    future: _modelList,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.hasData) {
                                                          var cityList =
                                                              snapshot.data!
                                                                  .map((item) {
                                                            return new DropdownMenuItem<
                                                                Model>(
                                                              child: new Text(item
                                                                  .modelName!),
                                                              value: item,
                                                            );
                                                          }).toList();
                                                          return DropDownListSelector(
                                                            dropDownList:
                                                                cityList,
                                                            hint: _homeProvider
                                                                        .currentLang ==
                                                                    'ar'
                                                                ? 'الموديل'
                                                                : 'Model',
                                                            onChangeFunc:
                                                                (newValue) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              setState(() {
                                                                _selectedModel =
                                                                    newValue;
                                                                _homeProvider
                                                                    .setEnableSearch(
                                                                        true);
                                                                _homeProvider
                                                                    .setSelectedModel(
                                                                        newValue);
                                                              });
                                                            },
                                                            value:
                                                                _selectedModel,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              "${snapshot.error}");
                                                        }
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            "${snapshot.error}");
                                                      }

                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  ),
                                                ),

                                          // omar
                                        ],
                                      ),
                                    ),
                                    _homeProvider.selectedCat!.catId != '2'
                                        ? Text(
                                            "",
                                            style: TextStyle(height: 0),
                                          )
                                        : Container(
                                            width: _width,
                                            child: Container(
                                              width: _width,
                                              child: InkWell(
                                                onTap: () => FocusScope.of(
                                                        context)
                                                    .requestFocus(FocusNode()),
                                                child: CustomTextFormField(
                                                    inputData:
                                                        TextInputType.number,
                                                    hintTxt: _homeProvider
                                                                .currentLang ==
                                                            "ar"
                                                        ? "عدد الغرف"
                                                        : "number of rooms",
                                                    onChangedFunc:
                                                        (String text) {
                                                      _homeProvider
                                                          .setEnableSearch(
                                                              true);
                                                      _homeProvider
                                                          .setRooms(text);
                                                    }),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: _width * .49,
                                            child: InkWell(
                                              onTap: () => FocusScope.of(
                                                      context)
                                                  .requestFocus(FocusNode()),
                                              child: CustomTextFormField(
                                                  inputData:
                                                      TextInputType.number,
                                                  hintTxt: _homeProvider
                                                              .currentLang ==
                                                          "ar"
                                                      ? "السعر يبدء من"
                                                      : "Price from",
                                                  onChangedFunc: (String text) {
                                                    _homeProvider
                                                        .setEnableSearch(true);
                                                    _homeProvider
                                                        .setPriceFrom(text);
                                                  }),
                                            ),
                                          ),

                                          Container(
                                            width: _width * .49,
                                            child: InkWell(
                                              onTap: () => FocusScope.of(
                                                      context)
                                                  .requestFocus(FocusNode()),
                                              child: CustomTextFormField(
                                                  inputData:
                                                      TextInputType.number,
                                                  hintTxt: _homeProvider
                                                              .currentLang ==
                                                          "ar"
                                                      ? "السعر الى"
                                                      : "Price To",
                                                  onChangedFunc: (String text) {
                                                    _homeProvider
                                                        .setEnableSearch(true);
                                                    _homeProvider
                                                        .setPriceTo(text);
                                                  }),
                                            ),
                                          ),

                                          // omar
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ));
                        }));
                  });
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Text(_homeProvider.currentLang == "ar" ? "فلترة" : "Filter"),
                  Icon(
                    FontAwesomeIcons.filter,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      ],
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: Scaffold(
        appBar: appBar,
        body: _buildBodyItem(),
      ),
    );
  }
}
