import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auor/locale/app_localizations.dart';
import 'package:auor/models/category.dart';
import 'package:auor/models/city.dart';
import 'package:auor/models/country.dart';
import 'package:auor/utils/commons.dart';
import 'package:validators/validators.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String _password = '';

  String? validateUserName(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('user_name_validation');
    }
    return null;
  }

  String? validateCommitionV1(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v1');
    }
    return null;
  }

  String? validateCommitionV2(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v2');
    }
    return null;
  }

  String? validateCommitionV3(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v3');
    }
    return null;
  }

  String? validateCommitionV4(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v4');
    }
    return null;
  }

  String? validateCommitionV5(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v5');
    }
    return null;
  }

  String? validateCommitionV6(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v6');
    }
    return null;
  }

  String? validateCommitionV7(String? userName) {
    if (userName!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('commition_v7');
    }
    return null;
  }

  String? validateUserEmail(String? userEmail) {
    if (userEmail!.trim().length == 0 || (!isEmail(userEmail))) {
      return "برجاء ادخال الايميل";
    }

    return null;
  }

  String? validateActivationCode(String? activationCode) {
    if (activationCode!.trim().length == 0) {
      return AppLocalizations.of(context)!
          .translate('activation_code_validation');
    }
    return null;
  }

  String? validateAdTitle(String? title) {
    if (title!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('ad_title');
    }
    return null;
  }

  String? validateMsg(String? msgTitle) {
    if (msgTitle!.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('msg_validation');
    }
    return null;
  }

  String? validateAdDescription(String? adsDetails) {
    if (adsDetails!.trim().length == 0) {
      return AppLocalizations.of(context)!
          .translate('ad_description_validation');
    }
    return null;
  }

  String? validatePassword(String? password) {
    _password = password!;
    if (password.trim().length == 0) {
      return AppLocalizations.of(context)!.translate('password_validation');
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword!.trim().length == 0) {
      return AppLocalizations.of(context)!
          .translate('confirm_password_validation');
    } else if (_password != confirmPassword) {
      return AppLocalizations.of(context)!.translate('Password_not_identical');
    }
    return null;
  }

  String? validateUserPhone(String? phone) {
    if (phone!.trim().length == 0 || !isNumeric(phone)) {
      return AppLocalizations.of(context)!.translate('phone_no_validation');
    } else if (phone.trim().length < 8) {
      return " عفوا يجب ان لا يقل الرقم عن 8 ارقام";
    }
    return null;
  }

  String? validateAdPrice(String? adPrice) {
    if (adPrice!.trim().length == 0 || !isNumeric(adPrice)) {
      return AppLocalizations.of(context)!.translate('ad_price_validation');
    }
    return null;
  }

  // String validateKeySearch(String keySearch) {
  //   if (keySearch.trim().length == 0) {
  //     return ' يرجى إدخال كلمة البحث';
  //   }
  //   return null;
  // }

  // String validateAge(String age) {
  //   if (age.trim().length == 0 || !isNumeric(age)) {
  //     return ' يرجى إدخال العمر';
  //   }
  //   return null;
  // }

  bool checkAddAdValidation(BuildContext context,
      {CategoryModel? adMainCategory,
      City? adCity,
      String? adKind,
      File? imgFile}) {
    if (adMainCategory == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context)!
              .translate('ad_category_validation')!,
          color: Colors.red);
      return false;
    } else if (adCity == null) {
      Commons.showToast(context,
          message:
              AppLocalizations.of(context)!.translate('ad_city_validation')!,
          color: Colors.red);
      return false;
    }
    return true;
  }

  bool checkEditAdValidation(BuildContext context,
      {CategoryModel? adMainCategory, City? adCity, String? adKind}) {
    if (adMainCategory == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context)!
              .translate('ad_category_validation')!,
          color: Colors.red);
      return false;
    } else if (adCity == null) {
      Commons.showToast(context,
          message:
              AppLocalizations.of(context)!.translate('ad_city_validation')!,
          color: Colors.red);
      return false;
    }
    return true;
  }

  bool checkSearchValidation(
    BuildContext context, {
     CategoryModel? searchCategory,
    String? keysearch,
  }) {
    if (keysearch == "") {
      Commons.showToast(context,
          message:
              AppLocalizations.of(context)!.translate('search_validation_msg')!,
          color: Colors.red);
      return false;
    }
    return true;
  }

  bool checkValidationCountry(
    BuildContext context, {
    Country? country,
  }) {
    if (country == null) {
      Commons.showToast(context,
          message:
              AppLocalizations.of(context)!.translate('country_validation')!,
          color: Colors.red);
      return false;
    }
    return true;
  }
}
