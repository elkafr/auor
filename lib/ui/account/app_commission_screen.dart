import 'dart:math' as math;

import 'package:auor/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auor/custom_widgets/buttons/custom_button.dart';
import 'package:auor/custom_widgets/safe_area/page_container.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/commission_app.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/providers/commission_app_provider.dart';
import 'package:auor/providers/home_provider.dart';
import 'package:auor/ui/account/pay_commission_screen.dart';
import 'package:auor/utils/app_colors.dart';
import 'package:auor/utils/error.dart';
import 'package:provider/provider.dart';

class AppCommissionScreen extends StatefulWidget {
  @override
  _AppCommissionScreenState createState() => _AppCommissionScreenState();
}

class _AppCommissionScreenState extends State<AppCommissionScreen> {
  double _height = 0, _width = 0;
  late HomeProvider _homeProvider;

  String? _adValue;
  bool _initialRun = true;
  late CommisssionAppProvider _commisssionAppProvider;
  Future<CommissionApp?>? _commissionApp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _commisssionAppProvider = Provider.of<CommisssionAppProvider>(context);
      _commissionApp = _commisssionAppProvider.getCommissionApp();
      _initialRun = false;
    }
  }

  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Container(
            width: _width * 0.55,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
        height: _height,
        width: _width,
        child: FutureBuilder<CommissionApp?>(
            future: _commissionApp,
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
                    return   Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 70,
                        ),


                        Padding(padding: EdgeInsets.all(25),
                          child:   Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(_homeProvider.currentLang=="ar"?"شروط حساب العمولة":"Conditions for commission calculation",style: TextStyle(
                                  color:mainAppColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )),
                              Padding(padding: EdgeInsets.all(6)),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Html(data: snapshot.data!.about)),
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: 25,),

                        Consumer<AuthProvider>(
                            builder: (context,authProvider,child){
                              return  Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                alignment:  authProvider.currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
                                child: Text(_homeProvider.currentLang=="ar"?"حساب العمولة":"Commition Calculate",style: TextStyle(
                                    color: mainAppColor,fontSize: 15,fontWeight: FontWeight.w700
                                ),),
                              );
                            }
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(

                          inputData: TextInputType.number,
                          hintTxt: _homeProvider.currentLang=="ar"?"سعر الاعلان":"Ads price",
                          suffix:Container(child: Text( ""),
                            padding: EdgeInsets.only(top: 15),
                          ),
                          onChangedFunc: (text){
                            _adValue =text;
                            var commissionValue;
                            print(_adValue);
                            if(_adValue==""){
                              commissionValue=0;
                            }else{
                              commissionValue = double.parse(_adValue!) * (double.parse(snapshot.data!.commition!) /100);
                            }

                            _commisssionAppProvider.setCommissionValue(commissionValue.toString());
                          },

                        ),


                        SizedBox(
                          height: 15,
                        ),

                        Container(
                          alignment: Alignment.center,

                          decoration: BoxDecoration(

                            border: Border.all(
                                color: hintColor.withOpacity(0.9),
                                width: 1,
                                style: BorderStyle.solid

                            ),
                            color: Colors.white,

                          ),
                          padding: EdgeInsets.all(15),
                          width: _width*.85,

                          child: Column(

                            children: <Widget>[
                              Consumer<AuthProvider>(
                                  builder: (context,authProvider,child){
                                    return   Container(
                                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                                      alignment:  authProvider.currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
                                      child: Text(AppLocalizations.of(context)!.translate('value_of_commission_due')!,style: TextStyle(
                                          color: mainAppColor,fontSize: 13,fontWeight: FontWeight.w700
                                      ),),
                                    );}),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 10
                                  ),
                                  child: Consumer<CommisssionAppProvider>
                                    (
                                      builder: (context,commisssionAppProvider,child){
                                        return Text('${commisssionAppProvider.commissionValue}  ');
                                      }
                                  )
                              ),





                            ],
                          ),
                        ),

                        SizedBox(height: 30,),

                        Container(
                            alignment: Alignment.center,
                            child: Text('${AppLocalizations.of(context)!.translate('app_commission')!} ${snapshot.data!.commition} %' ,style: TextStyle(
                                color: mainAppColor
                            ),)),

                        SizedBox(
                          height: 20,
                        ),


                        CustomButton(
                          btnLbl: _homeProvider.currentLang=="ar"?"تحويل بنكي":"Bank transfer",
                          btnColor: mainAppColor,
                          onPressedFunction: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PayCommissionScreen()));
                          },
                        )

                      ],
                    );
                  }
              }
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _homeProvider = Provider.of<HomeProvider>(context);
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
                  Text(
                      _homeProvider.currentLang == "ar"
                          ? "عمولة التطبيق"
                          : "App commition",
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
