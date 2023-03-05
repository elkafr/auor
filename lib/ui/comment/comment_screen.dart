import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:auor/custom_widgets/no_data/no_data.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/comments.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/comment_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/commons.dart';
import 'package:auor/utils/urls.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  double _height = 0, _width = 0;
  late AuthProvider _authProvider;
  late HomeProvider _homeProvider;
  ApiProvider _apiProvider = ApiProvider();
  TextEditingController _messageController = TextEditingController();
  LocationData? _locData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? reportValue;

  Widget _buildBodyItem() {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Comments>>(
              future: Provider.of<CommentProvider>(context, listen: false)
                  .getCommentsList(_homeProvider.currentAds),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return SpinKitFadingCircle(color: mainAppColor);
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.waiting:
                    return SpinKitFadingCircle(color: mainAppColor);
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return NoData(
                        message: AppLocalizations.of(context)!
                            .translate('no_comments'),
                      );
                    } else {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                    color: hintColor.withOpacity(0.7),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                width: _width,
                                height: _height * 0.15,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.all(5)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(snapshot.data![index].commentBy!,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.7))),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Container(
                                          width: 300,
                                          child: Text(
                                            snapshot
                                                .data![index].commentDetails!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: mainAppColor,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Text(snapshot.data![index].commentDate!,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.7))),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.report_problem,
                                          color: Colors.red,
                                        ),
                                        onTap: () async {
                                          showDialog(
                                              context:
                                                  _scaffoldKey.currentContext!,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child: Form(
                                                      child: Wrap(
                                                        children: <Widget>[
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15)),
                                                          Container(
                                                            child: Text(_homeProvider
                                                                        .currentLang ==
                                                                    "ar"
                                                                ? "ارسال بلاغ :-"
                                                                : "Send report :-"),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15)),
                                                          Container(
                                                            child:
                                                                CustomTextFormField(
                                                              hintTxt: _homeProvider
                                                                          .currentLang ==
                                                                      "ar"
                                                                  ? "سبب البلاغ"
                                                                  : "Report reason",
                                                              onChangedFunc:
                                                                  (text) async {
                                                                reportValue =
                                                                    text;
                                                              },
                                                            ),
                                                          ),
                                                          CustomButton(
                                                            btnColor:
                                                                mainAppColor,
                                                            btnLbl: _homeProvider
                                                                        .currentLang ==
                                                                    "ar"
                                                                ? "ارسال"
                                                                : "Send",
                                                            onPressedFunction:
                                                                () async {
                                                              if (reportValue !=
                                                                  null) {
                                                                final results =
                                                                    await _apiProvider.post(
                                                                        Urls.REPORT_AD_URL1 +
                                                                            "?api_lang=${_authProvider.currentLang}",
                                                                        body: {
                                                                      "report_user": _authProvider
                                                                          .currentUser!
                                                                          .userId,
                                                                      "report_gid": snapshot
                                                                          .data![
                                                                              index]
                                                                          .commentId,
                                                                      "report_value":
                                                                          reportValue,
                                                                    });

                                                                if (results[
                                                                        'response'] ==
                                                                    "1") {
                                                                  Commons.showToast(
                                                                      context,
                                                                      message:
                                                                          results[
                                                                              "message"]);
                                                                  Navigator.pop(
                                                                      context);
                                                                } else {
                                                                  Commons.showError(
                                                                      context,
                                                                      results[
                                                                          "message"]);
                                                                }
                                                              } else {
                                                                Commons.showError(
                                                                    context,
                                                                    "يجب ادخال سبب البلاغ");
                                                              }
                                                            },
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return NoData(
                          message: AppLocalizations.of(context)!
                              .translate('no_msgs'),
                        );
                      }
                    }
                }
                return SpinKitFadingCircle(color: mainAppColor);
              }),
        ),
        Divider(),
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: _width * 0.03),
          width: _width,
          child: CustomTextFormField(
            enableHorizontalMargin: false,
            controller: _messageController,
            hintTxt: _homeProvider.currentLang == "ar"
                ? "اكتب تعليقك هنا ..."
                : "Add your comment here ...",
            suffix: IconButton(
              icon: Icon(
                Icons.send,
                color: mainAppColor,
              ),
              onPressed: () async {
                final results =
                    await _apiProvider.post(Urls.ADD_COMMENT, body: {
                  "ads_id": _homeProvider.currentAds,
                  "comment_details": _messageController.text.toString(),
                  "user_id": _authProvider.currentUser!.userId,
                });

                if (results['response'] == "1") {
                  Commons.showToast(context, message: results["message"]);
                  Navigator.pop(context);
                } else {
                  Commons.showError(context, results["message"]);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context, x) {}

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);

    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Text(
          _homeProvider.currentLang == "ar" ? "اضافة تعليق" : "Add comment",
          style: Theme.of(context).textTheme.headline1),
      centerTitle: true,
      backgroundColor: mainAppColor,
      actions: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 35,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.all(5)),
      ],
    );

    return PageContainer(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar,
          body: _buildBodyItem(),
        ),
      ),
    );
  }
}
