class Ad {
  Ad({
    this.adsId,
    this.adsStar,
    this.adsRooms,
    this.adsVideo,
    this.adsTitle,
    this.adsUrl,
    this.adsDate,
    this.adsAge,
    this.adsFullDate,
    this.adsVisits,
    this.adsCat,
    this.adsCatName,
    this.adsCatImage,
    this.adsSub,
    this.adsSubCatName,
    this.adsCatUrl,
    this.adsCountry,
    this.adsCountryName,
    this.adsCountryUrl,
    this.adsCityName,
    this.adsMarka,
    this.adsMarkaName,
    this.adsMarkaUrl,
    this.adsType,
    this.adsTypeName,
    this.adsTypeUrl,
    this.adsModel,
    this.adsModelName,
    this.adsModelUrl,
    this.adsUser,
    this.adsUserName,
    this.adsUserUrl,
    this.adsPhoto,
    this.adsDetails,
    this.adsPrice,
    this.adsPhone,
    this.adsWhatsapp,
    this.adsRate,
    this.adsAdress,
    this.adsLocation,
    this.adsIsFavorite,
    this.adsGear,
    this.adsSpeedometer,
  });

  String? adsId;
  String? adsStar;
  String? adsRooms;
  String? adsVideo;
  String? adsTitle;
  String? adsUrl;
  String? adsDate;
  String? adsAge;
  String? adsFullDate;
  String? adsVisits;
  String? adsCat;
  String? adsCatName;
  String? adsCatImage;
  String? adsSub;
  String? adsSubCatName;
  String? adsCatUrl;
  String? adsCountry;
  String? adsCountryName;
  String? adsCountryUrl;
  String? adsCityName;
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
  String? adsUserUrl;
  String? adsPhoto;
  String? adsDetails;
  String? adsPrice;
  String? adsPhone;
  String? adsWhatsapp;
  String? adsRate;
  String? adsAdress;
  String? adsLocation;
  int? adsIsFavorite;
  String? adsGear;
  String? adsSpeedometer;

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        adsId: json["ads_id"],
        adsStar: json["ads_star"],
        adsRooms: json["ads_rooms"],
        adsVideo: json["ads_video"],
        adsTitle: json["ads_title"],
        adsUrl: json["ads_url"],
        adsDate: json["ads_date"],
        adsAge: json["ads_age"],
        adsFullDate: json["ads_full_date"],
        adsVisits: json["ads_visits"],
        adsCat: json["ads_cat"],
        adsCatName: json["ads_cat_name"],
        adsCatImage: json["ads_cat_image"],
        adsSub: json["ads_sub"],
        adsSubCatName: json["ads_sub_cat_name"],
        adsCatUrl: json["ads_cat_url"],
        adsCountry: json["ads_country"],
        adsCountryName: json["ads_country_name"],
        adsCountryUrl: json["ads_country_url"],
        adsCityName: json["ads_city_name"],
        adsMarka: json["ads_marka"],
        adsMarkaName: json["ads_marka_name"],
        adsMarkaUrl: json["ads_marka_url"],
        adsType: json["ads_type"],
        adsTypeName: json["ads_type_name"],
        adsTypeUrl: json["ads_type_url"],
        adsModel: json["ads_model"],
        adsModelName: json["ads_model_name"],
        adsModelUrl: json["ads_model_url"],
        adsUser: json["ads_user"],
        adsUserName: json["ads_user_name"],
        adsUserUrl: json["ads_user_url"],
        adsPhoto: json["ads_photo"],
        adsDetails: json["ads_details"],
        adsPrice: json["ads_price"],
        adsPhone: json["ads_phone"],
        adsWhatsapp: json["ads_whatsapp"],
        adsRate: json["ads_rate"],
        adsAdress: json["ads_adress"],
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
        "ads_title": adsTitle,
        "ads_url": adsUrl,
        "ads_date": adsDate,
        "ads_age": adsAge,
        "ads_full_date": adsFullDate,
        "ads_visits": adsVisits,
        "ads_cat": adsCat,
        "ads_cat_name": adsCatName,
        "ads_cat_image": adsCatImage,
        "ads_sub": adsSub,
        "ads_sub_cat_name": adsSubCatName,
        "ads_cat_url": adsCatUrl,
        "ads_country": adsCountry,
        "ads_country_name": adsCountryName,
        "ads_country_url": adsCountryUrl,
        "ads_city_name": adsCityName,
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
        "ads_user_url": adsUserUrl,
        "ads_photo": adsPhoto,
        "ads_details": adsDetails,
        "ads_price": adsPrice,
        "ads_phone": adsPhone,
        "ads_whatsapp": adsWhatsapp,
        "ads_rate": adsRate,
        "ads_adress": adsAdress,
        "ads_location": adsLocation,
        "ads_is_favorite": adsIsFavorite,
        "ads_gear": adsGear,
        "ads_speedometer": adsSpeedometer,
      };
}
