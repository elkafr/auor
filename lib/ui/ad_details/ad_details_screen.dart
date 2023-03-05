import 'dart:async';

import 'package:auor/custom_widgets/ad_item/ad_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auor/custom_widgets/ad_item/ad_item1.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/ad.dart';
import 'package:auor/models/ad_details.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/ad_details_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/favourite_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/ui/account/pay_commission_screen.dart';
import 'package:auor/ui/ad_details/widgets/slider_images.dart';
import 'package:auor/ui/auth/login_screen.dart';
import 'package:auor/ui/chat/chat_screen.dart';
import 'package:auor/ui/comment/comment_screen.dart';
import 'package:auor/ui/section_ads/section_ads_screen.dart';
import 'package:auor/ui/seller/seller_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/error.dart';
import 'package:auor/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/slider.dart';

class AdDetailsScreen extends StatefulWidget {
  final Ad? ad;

  const AdDetailsScreen({Key? key, this.ad}) : super(key: key);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen>
    with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  ApiProvider _apiProvider = ApiProvider();
  late AuthProvider _authProvider;

  late BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  late HomeProvider _homeProvider;
  String? reportValue;
  AnimationController? _animationController;
  String? messageValue1;
  String? omar = "";
  List<SliderModel> sliderList = [];
  Future<List<SliderModel>> _getsliderImages() async {
    Map<String, dynamic> results = await (_apiProvider
        .get(Urls.SLIDER_URL1 + "ads_id=" + widget.ad!.adsId!));

    if (results['response'] == '1') {
      Iterable iterable = results['slider'];
      sliderList =
          iterable.map((model) => SliderModel.fromJson(model)).toList();
      print(sliderList);
    } else {
      print('error');
    }
    return sliderList as FutureOr<List<SliderModel>>;
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
    setCustomMapPin();
  }

  @override
  void didChangeDependencies() {
    _getsliderImages();
    super.didChangeDependencies();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/pin.png',
    );
  }

  Widget _buildRow(
      {required String imgPath, required String title, required String value}) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          height: 15,
          width: 15,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Color(0xff5FB019), fontSize: 14),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  child: Text(
                      AppLocalizations.of(context)!.translate('send_report')!),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  child: CustomTextFormField(
                    hintTxt: AppLocalizations.of(context)!
                        .translate('report_reason'),
                    onChangedFunc: (text) async {
                      reportValue = text;
                    },
                  ),
                ),
                CustomButton(
                  btnColor: mainAppColor,
                  btnLbl: AppLocalizations.of(context)!.translate('send'),
                  onPressedFunction: () async {
                    if (reportValue != null) {
                      final results = await _apiProvider.post(
                          Urls.REPORT_AD_URL +
                              "?api_lang=${_authProvider.currentLang}",
                          body: {
                            "report_user": _authProvider.currentUser!.userId,
                            "report_gid": widget.ad!.adsId,
                            "report_value": reportValue,
                          });

                      if (results['response'] == "1") {
                        Commons.showToast(context, message: results["message"]);
                        Navigator.pop(context);
                      } else {
                        Commons.showError(context, results["message"]);
                      }
                    } else {
                      Commons.showError(
                          context,
                          AppLocalizations.of(context)!
                              .translate('enter_reason'));
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          );
        });
  }

  final GlobalKey<dynamic> _sliderKey = GlobalKey();

  Widget _buildBodyItem() {
    return FutureBuilder<AdDetails>(
        future: Provider.of<AdDetailsProvider>(context, listen: false)
            .getAdDetails(widget.ad!.adsId),
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
                  errorMessage:
                      AppLocalizations.of(context)!.translate('error'),
                );
              } else {
                List? comments = snapshot.data!.adsComments;
                // List related= snapshot.data.adSRelated;
                var initalLocation = snapshot.data!.adsLocation!.split(',');
                LatLng pinPosition = LatLng(double.parse(initalLocation[0]),
                    double.parse(initalLocation[1]));

                // these are the minimum required values to set
                // the camera position
                CameraPosition initialLocation =
                    CameraPosition(zoom: 15, bearing: 30, target: pinPosition);

                return ListView(
                  children: <Widget>[
                    (_homeProvider.omarKey == "1")
                        ? GestureDetector(
                            child: CustomButton(
                              btnLbl: _homeProvider.currentLang == "ar"
                                  ? "الابلاغ عن هذا المحتوي"
                                  : "Hide content from this advertiser",
                              btnColor: mainAppColor,
                              onPressedFunction: () async {
                                final results = await _apiProvider.post(
                                    "http://auor-app.com/api/report999" +
                                        "?api_lang=${_authProvider.currentLang}",
                                    body: {
                                      // "report_user": _authProvider.currentUser.userId,
                                      "report_gid": widget.ad!.adsId,
                                      //"report_value": reportValue,
                                    });

                                if (results['response'] == "1") {
                                  Commons.showToast(context,
                                      message: results["message"]);
                                  Navigator.pop(context);
                                } else {
                                  Commons.showError(
                                      context, results["message"]);
                                }
                              },
                            ),
                          )
                        : Text(
                            " ",
                            style: TextStyle(height: 0),
                          ),
                    Container(
                        height: _height * .24,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(_width * .03),
                        child: SliderWidget(
                            imageList: sliderList,
                            context: context,
                            sliderKey: _sliderKey)),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: _authProvider.currentLang == 'ar'
                            ? _width * 0.04
                            : _width * 0.04,
                        left: _authProvider.currentLang != 'ar'
                            ? _width * 0.04
                            : _width * 0.04,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.ad!.adsTitle!,
                            style: TextStyle(fontSize: 16, color: mainAppColor),
                            maxLines: 3,
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.access_time,
                              size: 15,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            widget.ad!.adsDate!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: _width * .04, left: _width * .06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.priority_high,
                                color: mainAppColor,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SectionAdsScreen(
                                                  catId: snapshot.data!.adsCat,
                                                  adCatName: snapshot
                                                      .data!.adsCatName)));
                                },
                                child: Container(
                                  child: Text(
                                    snapshot.data!.adsCatName!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_pin_circle,
                                color: mainAppColor,
                              ),
                              Text(
                                widget.ad!.adsCityName!,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.moneyBillAlt,
                                color: mainAppColor,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                widget.ad!.adsPrice!,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.remove_red_eye,
                                color: mainAppColor,
                              ),
                              Text(
                                widget.ad!.adsVisits!,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                          right: _width * .04, left: _width * .04),
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      color: Colors.grey[100],
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('ad_description')!,
                              style: TextStyle(
                                  color: orangeColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data!.adsDetails!,
                            style: TextStyle(height: 1.4, fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('advertiser_data')!,
                        style: TextStyle(
                            color: orangeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: _width * 0.025),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.adsUserPhoto!),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _homeProvider
                                  .setCurrentSeller(snapshot.data!.adsUser);
                              _homeProvider.setCurrentSellerName(
                                  snapshot.data!.adsUserName);
                              _homeProvider.setCurrentSellerPhone(
                                  snapshot.data!.adsUserPhone);
                              _homeProvider.setCurrentSellerPhoto(
                                  snapshot.data!.adsUserPhoto);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerScreen(
                                            userId: snapshot.data!.adsUser,
                                          )));
                            },
                            child: Text(
                              snapshot.data!.adsUserName!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              launch("tel://${snapshot.data!.adsPhone}");
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: _width * 0.025),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.phone_android,
                                        color: mainAppColor, size: 30),
                                    Text(
                                      widget.ad!.adsPhone!,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Padding(padding: EdgeInsets.all(5)),
                                    GestureDetector(
                                      onTap: () {
                                        if (_authProvider.currentUser != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        senderId: snapshot.data!
                                                            .userDetails![0].id,
                                                        senderImg: snapshot
                                                            .data!
                                                            .userDetails![0]
                                                            .userImage,
                                                        senderName: snapshot
                                                            .data!
                                                            .userDetails![0]
                                                            .name,
                                                        senderPhone: snapshot
                                                            .data!
                                                            .userDetails![0]
                                                            .phone,
                                                        adsId: snapshot
                                                            .data!.adsId,
                                                      )));
                                        } else {
                                          Navigator.pushNamed(
                                              context, '/login_screen');
                                        }
                                      },
                                      child: Container(
                                          height: 30,
                                          padding: EdgeInsets.only(
                                              right: 5, left: 5),
                                          decoration: BoxDecoration(
                                            color: mainAppColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                                bottomLeft: Radius.circular(2),
                                                bottomRight:
                                                    Radius.circular(2)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.chat_bubble,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate('chat')!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                right:
                                    _authProvider.currentLang != 'ar' ? 5 : 0,
                                left: _authProvider.currentLang == 'ar' ? 5 : 0,
                              ),
                              height: _height * 0.06,
                              width: _width * 0.12,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.grey[300]!,
                                  )),
                              child: _authProvider.currentUser == null
                                  ? GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/login_screen'),
                                      child: Center(
                                          child: Icon(
                                        Icons.favorite_border,
                                        size: 38,
                                        color: Colors.white,
                                      )),
                                    )
                                  : Consumer<FavouriteProvider>(builder:
                                      (context, favouriteProvider, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (favouriteProvider.favouriteAdsList
                                              .containsKey(
                                                  snapshot.data!.adsId)) {
                                            favouriteProvider
                                                .removeFromFavouriteAdsList(
                                                    snapshot.data!.adsId);
                                            await _apiProvider.get(Urls
                                                    .REMOVE_AD_from_FAV_URL +
                                                "ads_id=${snapshot.data!.adsId}&user_id=${_authProvider.currentUser!.userId}");
                                          } else {
                                            favouriteProvider
                                                .addToFavouriteAdsList(
                                                    snapshot.data!.adsId, 1);
                                            await _apiProvider.post(
                                                Urls.ADD_AD_TO_FAV_URL,
                                                body: {
                                                  "user_id": _authProvider
                                                      .currentUser!.userId,
                                                  "ads_id": snapshot.data!.adsId
                                                });
                                          }
                                        },
                                        child: Center(
                                          child: favouriteProvider
                                                  .favouriteAdsList
                                                  .containsKey(
                                                      snapshot.data!.adsId)
                                              ? SpinKitPumpingHeart(
                                                  color: accentColor,
                                                  size: 25,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      );
                                    })),
                          SizedBox(
                            width: _width * .02,
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            alignment: Alignment.center,
                            height: _height * 0.06,
                            width: _width * 0.12,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              color: Colors.grey[200],
                            ),
                            child: GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: mainAppColor,
                                    size: 25,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Share.share(
                                  "https://qatar-gates.com//site/show/" +
                                      widget.ad!.adsId!,
                                  subject: widget.ad!.adsDetails,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: _width * .02,
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            alignment: Alignment.center,
                            height: _height * 0.06,
                            width: _width * 0.12,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              color: Colors.grey[200],
                            ),
                            child: GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.report_problem,
                                    color: mainAppColor,
                                    size: 25,
                                  ),
                                ],
                              ),
                              onTap: () {
                                _settingModalBottomSheet(context);
                              },
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('follow')!,
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ),
                            onTap: () async {
                              if (_authProvider.currentUser != null) {
                                final results = await _apiProvider.post(
                                    "http://auor-app.com/api/follow",
                                    body: {
                                      "user_id":
                                          _authProvider.currentUser!.userId,
                                      "ads_id": widget.ad!.adsId,
                                    });

                                if (results['response'] == "1") {
                                  Commons.showToast(context,
                                      message: results["message"]);
                                  Navigator.pop(context);
                                } else {
                                  Commons.showError(
                                      context, results["message"]);
                                }
                              } else {
                                Commons.showToast(context,
                                    message: AppLocalizations.of(context)!
                                        .translate('must_login')!);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          launch(
                              "https://wa.me/${"974" + snapshot.data!.adsWhatsapp!}");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: mainAppColor,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('chat_whatsapp')!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              // Image.asset('assets/images/prev.png'),
                              Padding(padding: EdgeInsets.all(3)),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('comments')!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Padding(padding: EdgeInsets.all(15)),
                              GestureDetector(
                                child: Text(
                                  snapshot.data!.adsComments!.length.toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[400]),
                                ),
                                onTap: () {
                                  if (_authProvider.currentUser == null) {
                                    Commons.showToast(context,
                                        message: AppLocalizations.of(context)!
                                            .translate('must_login')!);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  } else {
                                    _homeProvider
                                        .setCurrentAds(widget.ad!.adsId);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommentScreen()));
                                  }
                                },
                              ),
                              Padding(padding: EdgeInsets.all(3)),
                              GestureDetector(
                                child: Text(
                                  _homeProvider.currentLang == "ar"
                                      ? "تعليق"
                                      : "Comment",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[400]),
                                ),
                                onTap: () {
                                  if (_authProvider.currentUser == null) {
                                    Commons.showToast(context,
                                        message: AppLocalizations.of(context)!
                                            .translate('must_login')!);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  } else {
                                    _homeProvider
                                        .setCurrentAds(widget.ad!.adsId);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommentScreen()));
                                  }
                                },
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(7),
                                color: mainAppColor,
                                child: GestureDetector(
                                    onTap: () async {
                                      if (_authProvider.currentUser != null) {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15)),
                                                      Container(
                                                        child: Text(
                                                          _homeProvider
                                                                      .currentLang ==
                                                                  "ar"
                                                              ? "اكتب تعليقك هنا ..."
                                                              : "Add your comment here ...",
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15)),
                                                      Container(
                                                        child:
                                                            CustomTextFormField(
                                                          maxLines: 4,
                                                          hintTxt: _homeProvider
                                                                      .currentLang ==
                                                                  "ar"
                                                              ? "محتوى التعليق"
                                                              : "Comment details",
                                                          onChangedFunc:
                                                              (text) async {
                                                            messageValue1 =
                                                                text;
                                                          },
                                                        ),
                                                      ),
                                                      CustomButton(
                                                        btnColor: mainAppColor,
                                                        btnLbl: "ارسال",
                                                        onPressedFunction:
                                                            () async {
                                                          if (messageValue1 !=
                                                              null) {
                                                            final results =
                                                                await _apiProvider
                                                                    .post(
                                                                        Urls.ADD_COMMENT,
                                                                        body: {
                                                                  "ads_id":
                                                                      widget.ad!
                                                                          .adsId,
                                                                  "comment_details":
                                                                      messageValue1
                                                                          .toString(),
                                                                  "user_id":
                                                                      _authProvider
                                                                          .currentUser!
                                                                          .userId,
                                                                });

                                                            if (results[
                                                                    'response'] ==
                                                                "1") {
                                                              Commons.showToast(
                                                                  context,
                                                                  message: results[
                                                                      "message"]);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {});
                                                            } else {
                                                              Commons.showError(
                                                                  context,
                                                                  results[
                                                                      "message"]);
                                                            }
                                                          } else {
                                                            Commons.showError(
                                                                context,
                                                                "يجب ادخال التعليق");
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10)),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('add_comment')!,
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    snapshot.data!.adsLocation != "666666,666666"
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            height:
                                snapshot.data!.adsLocation != "666666,666666"
                                    ? 150
                                    : 0,
                            decoration: BoxDecoration(
                              color: Color(0xffF3F3F3),
                              border: Border.all(
                                width: 1.0,
                                color: Color(0xffF3F3F3),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: GoogleMap(
                                    myLocationEnabled: true,
                                    compassEnabled: true,
                                    markers: _markers,
                                    initialCameraPosition: initialLocation,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      controller.setMapStyle(Commons.mapStyles);

                                      _controller.complete(controller);

                                      setState(() {
                                        _markers.add(Marker(
                                            markerId:
                                                MarkerId(snapshot.data!.adsId!),
                                            position: pinPosition,
                                            icon: pinLocationIcon));
                                      });
                                    })),
                          )
                        : Text(""),
                    SizedBox(
                      height: 5,
                    ),

                    /* Container(
                      margin: EdgeInsets.only(right: _width*.02,left: _width*.02),
                      padding: EdgeInsets.all(7),

                      child: Row(
                        children: <Widget>[


                          Container(
                            height: 50,
                            width: _width*.40,
                            margin: EdgeInsets.all(_width*.02),
                            child: FutureBuilder<List<Ad>>(
                                future:  Provider.of<HomeProvider>(context,
                                    listen: false)
                                    .getAdsListNext(widget.ad.adsId,widget.ad.adsCat),
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
                                        return null;
                                      } else {
                                        if (snapshot.data.length > 0) {
                                          return     ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                var count = snapshot.data.length;
                                                var animation = Tween(begin: 0.0, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: _animationController,
                                                    curve: Interval((1 / count) * index, 1.0,
                                                        curve: Curves.fastOutSlowIn),
                                                  ),
                                                );
                                                _animationController.forward();
                                                return Container(

                                                    width: _width*.40,

                                                    child: InkWell(
                                                        onTap: (){

                                                          _homeProvider.setCurrentAds(snapshot.data[index].adsId);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => AdDetailsScreen(
                                                                    ad: snapshot.data[index],


                                                                  )));
                                                        },
                                                        child:  Container(

                                                          padding: EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                            border: Border.all(
                                                              color: mainAppColor,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(Icons.keyboard_arrow_right,color: mainAppColor,),
                                                              Text(_homeProvider.currentLang=="ar"?"الاعلان التالي":"Next Ad",style: TextStyle(color: mainAppColor,fontSize: 16,fontWeight: FontWeight.bold),)
                                                            ],
                                                          ),
                                                        )));
                                              }
                                          );
                                        } else {
                                          return Text("");
                                        }
                                      }
                                  }
                                  return Center(
                                    child: SpinKitFadingCircle(color: mainAppColor),
                                  );
                                }),
                          ),






                          Container(
                            height: 50,
                            width: _width*.40,
                            margin: EdgeInsets.all(_width*.02),
                            child: FutureBuilder<List<Ad>>(
                                future:  Provider.of<HomeProvider>(context,
                                    listen: false)
                                    .getAdsListPrev(widget.ad.adsId,widget.ad.adsCat),
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
                                        if (snapshot.data.length > 0) {
                                          return     ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                var count = snapshot.data.length;
                                                var animation = Tween(begin: 0.0, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: _animationController,
                                                    curve: Interval((1 / count) * index, 1.0,
                                                        curve: Curves.fastOutSlowIn),
                                                  ),
                                                );
                                                _animationController.forward();
                                                return Container(

                                                    width: _width*.40,

                                                    child: InkWell(
                                                        onTap: (){

                                                          _homeProvider.setCurrentAds(snapshot.data[index].adsId);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => AdDetailsScreen(
                                                                    ad: snapshot.data[index],


                                                                  )));
                                                        },
                                                        child:  Container(

                                                          padding: EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                            border: Border.all(
                                                              color: mainAppColor,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(Icons.keyboard_arrow_right,color: mainAppColor,),
                                                              Text(_homeProvider.currentLang=="ar"?"الاعلان السابق":"Previous Ad",style: TextStyle(color: mainAppColor,fontSize: 16,fontWeight: FontWeight.bold),)
                                                            ],
                                                          ),
                                                        )));
                                              }
                                          );
                                        } else {
                                          return NoData(message: AppLocalizations.of(context).translate('no_results'));
                                        }
                                      }
                                  }
                                  return Center(
                                    child: SpinKitFadingCircle(color: mainAppColor),
                                  );
                                }),
                          ),




                        ],
                      ),
                    ), */
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: mainAppColor,
                      padding: EdgeInsets.all(8),
                      alignment: _authProvider.currentLang == 'ar'
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Row(
                        children: <Widget>[
                          // Image.asset('assets/images/prev.png'),
                          Padding(padding: EdgeInsets.all(3)),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('similar_ads')!,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: _height * .26,
                      width: _width,
                      child: FutureBuilder<List<Ad>>(
                          future:
                              Provider.of<HomeProvider>(context, listen: false)
                                  .getAdsListRelated(widget.ad!.adsId),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Center(
                                  child:
                                      SpinKitFadingCircle(color: mainAppColor),
                                );
                              case ConnectionState.active:
                                return Text('');
                              case ConnectionState.waiting:
                                return Center(
                                  child:
                                      SpinKitFadingCircle(color: mainAppColor),
                                );
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return Error(
                                    errorMessage: snapshot.error.toString(),
                                    // errorMessage: "حدث خطأ ما ",
                                  );
                                } else {
                                  if (snapshot.data!.length > 0) {
                                    var initalLocation =
                                        widget.ad!.adsLocation!.split(',');
                                    LatLng pinPosition = LatLng(
                                        double.parse(initalLocation[0]),
                                        double.parse(initalLocation[1]));

                                    // these are the minimum required values to set
                                    // the camera position
                                    CameraPosition initialLocation =
                                        CameraPosition(
                                            zoom: 15,
                                            bearing: 30,
                                            target: pinPosition);
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var count = snapshot.data!.length;
                                          var animation =
                                              Tween(begin: 0.0, end: 1.0)
                                                  .animate(
                                            CurvedAnimation(
                                              parent: _animationController!,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          );
                                          _animationController!.forward();
                                          return Container(
                                              width: _width * .50,
                                              child: InkWell(
                                                  onTap: () {
                                                    _homeProvider.setCurrentAds(
                                                        snapshot.data![index]
                                                            .adsId);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdDetailsScreen(
                                                                  ad: snapshot
                                                                          .data![
                                                                      index],
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
                    ),
                  ],
                );
              }
          }
          return Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      leading: IconButton(
        icon: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.currentLang == 'ar'
                ? Icon(Icons.arrow_back)
                : Icon(Icons.arrow_back);
          },
        ),
        onPressed: () {
          print('bacccck');
          Navigator.pop(context); // dialog returns true
        },
      ),
      centerTitle: true,
      title: _authProvider.currentLang == 'ar'
          ? Text(
              widget.ad!.adsTitle!,
              style: TextStyle(fontSize: 16),
            )
          : Text(widget.ad!.adsTitle!, style: TextStyle(fontSize: 16)),
    );

    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          body: Stack(
            children: <Widget>[
              FutureBuilder<String?>(
                  future: Provider.of<HomeProvider>(context, listen: false)
                      .getAli(
                          widget.ad!.adsId,
                          _authProvider.currentUser != null
                              ? _authProvider.currentUser!.userId
                              : "0"),
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
                            errorMessage: AppLocalizations.of(context)!
                                .translate('error'),
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
              _buildBodyItem(),
            ],
          )),
    );
  }
}
