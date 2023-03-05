class AdDetails {
  AdDetails({
    this.adsId,
    this.adsStar,
    this.adsRooms,
    this.adsVideo,
    this.adsPhone,
    this.adsWhatsapp,
    this.adsTitle,
    this.checkAddFav,
    this.checkAddFollow,
    this.adsDetails,
    this.adsPrice,
    this.adsUrl,
    this.adsDate,
    this.adsFullDate,
    this.adsVisits,
    this.adsAge,
    this.adsGender,
    this.adsComments,
    this.adsCat,
    this.adsCatName,
    this.adsCatImage,
    this.adsCatPhone,
    this.adsCatAddress,
    this.adsCatUrl,
    this.adsCountry,
    this.adsCountryName,
    this.adsCountryUrl,
    this.adsCity,
    this.adsCityName,
    this.adsCityUrl,
    this.adsMarka,
    this.adsMarkaName,
    this.adsMarkaUrl,
    this.adsType,
    this.adsTypeName,
    this.adsTypeUrl,
    this.adsModel,
    this.adsModelName,
    this.adsUser,
    this.adsUserName,
    this.adsUserPhone,
    this.adsUserPhoto,
    this.adsUserUrl,
    this.adsMainPhoto,
    this.photos,
    this.adsOwner,
    this.userDetails,
    this.adsRate,
    this.adsAdress,
    this.adsDays,
    this.adsLocation,
    this.adsIsFavorite,
    this.adsGear,
    this.adsSpeedometer,
  });

  String? adsId;
  String? adsStar;
  String? adsRooms;
  String? adsVideo;
  String? adsPhone;
  String? adsWhatsapp;
  String? adsTitle;
  int? checkAddFav;
  int? checkAddFollow;
  String? adsDetails;
  String? adsPrice;
  String? adsUrl;
  String? adsDate;
  String? adsFullDate;
  String? adsVisits;
  String? adsAge;
  String? adsGender;
  List<dynamic>? adsComments;
  String? adsCat;
  String? adsCatName;
  String? adsCatImage;
  dynamic adsCatPhone;
  dynamic adsCatAddress;
  String? adsCatUrl;
  String? adsCountry;
  String? adsCountryName;
  String? adsCountryUrl;
  String? adsCity;
  String? adsCityName;
  String? adsCityUrl;
  String? adsMarka;
  String? adsMarkaName;
  String? adsMarkaUrl;
  String? adsType;
  String? adsTypeName;
  String? adsTypeUrl;
  String? adsModel;
  String? adsModelName;
  String? adsModelUrl;
  String? adsUser;
  String? adsUserName;
  String? adsUserPhone;
  String? adsUserPhoto;
  String? adsUserUrl;
  String? adsMainPhoto;
  List<Photo>? photos;
  String? adsOwner;
  List<UserDetail>? userDetails;
  int? adsRate;
  String? adsAdress;
  dynamic adsDays;
  String? adsLocation;
  int? adsIsFavorite;
  String? adsGear;
  String? adsSpeedometer;

  factory AdDetails.fromJson(Map<String, dynamic> json) => AdDetails(
        adsId: json["ads_id"],
        adsStar: json["ads_star"],
        adsRooms: json["ads_rooms"],
        adsVideo: json["ads_video"],
        adsPhone: json["ads_phone"],
        adsWhatsapp: json["ads_whatsapp"],
        adsTitle: json["ads_title"],
        checkAddFav: json["check_add_fav"],
        checkAddFollow: json["check_add_follow"],
        adsDetails: json["ads_details"],
        adsPrice: json["ads_price"],
        adsUrl: json["ads_url"],
        adsDate: json["ads_date"],
        adsFullDate: json["ads_full_date"],
        adsVisits: json["ads_visits"],
        adsAge: json["ads_age"],
        adsGender: json["ads_gender"],
        adsComments: List<dynamic>.from(json["ads_comments"].map((x) => x)),
        adsCat: json["ads_cat"],
        adsCatName: json["ads_cat_name"],
        adsCatImage: json["ads_cat_image"],
        adsCatPhone: json["ads_cat_phone"],
        adsCatAddress: json["ads_cat_address"],
        adsCatUrl: json["ads_cat_url"],
        adsCountry: json["ads_country"],
        adsCountryName: json["ads_country_name"],
        adsCountryUrl: json["ads_country_url"],
        adsCity: json["ads_city"],
        adsCityName: json["ads_city_name"],
        adsCityUrl: json["ads_city_url"],
        adsMarka: json["ads_marka"],
        adsMarkaName: json["ads_marka_name"],
        adsMarkaUrl: json["ads_marka_url"],
        adsType: json["ads_type"],
        adsTypeName: json["ads_type_name"],
        adsTypeUrl: json["ads_type_url"],
        adsModel: json["ads_model"],
        adsModelName: json["ads_model_name"],
        adsUser: json["ads_user"],
        adsUserName: json["ads_user_name"],
        adsUserPhone: json["ads_user_phone"],
        adsUserPhoto: json["ads_user_photo"],
        adsUserUrl: json["ads_user_url"],
        adsMainPhoto: json["ads_main_photo"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        adsOwner: json["ads_owner"],
        userDetails: List<UserDetail>.from(
            json["user_details"].map((x) => UserDetail.fromJson(x))),
        adsRate: json["ads_rate"],
        adsAdress: json["ads_adress"],
        adsDays: json["ads_days"],
        adsLocation: json["ads_location"],
        adsIsFavorite: json["ads_is_favorite"],
        adsGear: json["ads_gear"],
        adsSpeedometer: json["ads_speedometer"],
      );

  Map<String, dynamic> toJson() => {
        "ads_id": adsId,
        "ads_star": adsStar,
        "ads_rooms": adsRooms,
        "ads_video": adsVideo,
        "ads_phone": adsPhone,
        "ads_whatsapp": adsWhatsapp,
        "ads_title": adsTitle,
        "check_add_fav": checkAddFav,
        "check_add_follow": checkAddFollow,
        "ads_details": adsDetails,
        "ads_price": adsPrice,
        "ads_url": adsUrl,
        "ads_date": adsDate,
        "ads_full_date": adsFullDate,
        "ads_visits": adsVisits,
        "ads_age": adsAge,
        "ads_gender": adsGender,
        "ads_comments": List<dynamic>.from(adsComments!.map((x) => x)),
        "ads_cat": adsCat,
        "ads_cat_name": adsCatName,
        "ads_cat_image": adsCatImage,
        "ads_cat_phone": adsCatPhone,
        "ads_cat_address": adsCatAddress,
        "ads_cat_url": adsCatUrl,
        "ads_country": adsCountry,
        "ads_country_name": adsCountryName,
        "ads_country_url": adsCountryUrl,
        "ads_city": adsCity,
        "ads_city_name": adsCityName,
        "ads_city_url": adsCityUrl,
        "ads_marka": adsMarka,
        "ads_marka_name": adsMarkaName,
        "ads_marka_url": adsMarkaUrl,
        "ads_type": adsType,
        "ads_type_name": adsTypeName,
        "ads_type_url": adsTypeUrl,
        "ads_model": adsModel,
        "ads_model_name": adsModelName,
        "ads_model_url": adsModelUrl,
        "ads_user": adsUser,
        "ads_user_name": adsUserName,
        "ads_user_phone": adsUserPhone,
        "ads_user_photo": adsUserPhoto,
        "ads_user_url": adsUserUrl,
        "ads_main_photo": adsMainPhoto,
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "ads_owner": adsOwner,
        "user_details": List<dynamic>.from(userDetails!.map((x) => x.toJson())),
        "ads_rate": adsRooms,
        "ads_adress": adsAdress,
        "ads_days": adsDays,
        "ads_location": adsLocation,
        "ads_is_favorite": adsIsFavorite,
        "ads_gear": adsGear,
        "ads_speedometer": adsSpeedometer,
      };
}

class Photo {
  Photo({
    this.id,
    this.photo,
  });

  String? id;
  String? photo;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
      };
}

class UserDetail {
  UserDetail({
    this.id,
    this.name,
    this.phone,
    this.numberOfAds,
    this.userImage,
  });

  String? id;
  String? name;
  String? phone;
  int? numberOfAds;
  String? userImage;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        numberOfAds: json["number of ads"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "number of ads": numberOfAds,
        "user_image": userImage,
      };
}
