class GetSpecificArtistGenre {
  bool? status;
  Datas? data;
  String? message;

  GetSpecificArtistGenre({this.status, this.data, this.message});

  GetSpecificArtistGenre.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = Datas.fromJson(json['data']);
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != dynamic) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Datas {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Datas(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Datas.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != dynamic) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != dynamic) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != dynamic) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != dynamic) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? itemName;
  String? type;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data(
      {this.id,
      this.userId,
      this.itemName,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != dynamic) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  dynamic deviceToken;
  dynamic referralCode;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? customerId;
  dynamic connectAccountId;
  int? isConnectedAccountExist;
  String? activeRole;
  String? currentRole;
  dynamic status;
  String? signupPlatform;
  String? platformId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Profile? profile;

  User(
      {this.id,
      this.name,
      this.email,
      this.deviceToken,
      this.referralCode,
      this.emailVerifiedAt,
      this.otp,
      this.customerId,
      this.connectAccountId,
      this.isConnectedAccountExist,
      this.activeRole,
      this.currentRole,
      this.status,
      this.signupPlatform,
      this.platformId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.profile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    deviceToken = json['device_token'];
    referralCode = json['referral_code'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    customerId = json['customer_id'];
    connectAccountId = json['connect_account_id'];
    isConnectedAccountExist = json['is_connected_account_exist'];
    activeRole = json['active_role'];
    currentRole = json['current_role'];
    status = json['status'];
    signupPlatform = json['signup_platform'];
    platformId = json['platform_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['profile'] != null) {
      profile = Profile.fromJson(json['profile']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['device_token'] = deviceToken;
    data['referral_code'] = referralCode;
    data['email_verified_at'] = emailVerifiedAt;
    data['otp'] = otp;
    data['customer_id'] = customerId;
    data['connect_account_id'] = connectAccountId;
    data['is_connected_account_exist'] = isConnectedAccountExist;
    data['active_role'] = activeRole;
    data['current_role'] = currentRole;
    data['status'] = status;
    data['signup_platform'] = signupPlatform;
    data['platform_id'] = platformId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (profile != dynamic) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  String? birthYear;
  String? phoneNumber;
  dynamic companyName;
  String? country;
  String? selectState;
  dynamic location;
  String? about;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.birthYear,
      this.phoneNumber,
      this.companyName,
      this.country,
      this.selectState,
      this.location,
      this.about,
      this.latitude,
      this.longitude,
      this.isInsurance,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthYear = json['birth_year'];
    phoneNumber = json['phone_number'];
    companyName = json['company_name'];
    country = json['country'];
    selectState = json['select_state'];
    location = json['location'];
    about = json['about'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isInsurance = json['is_insurance'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['birth_year'] = birthYear;
    data['phone_number'] = phoneNumber;
    data['company_name'] = companyName;
    data['country'] = country;
    data['select_state'] = selectState;
    data['location'] = location;
    data['about'] = about;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_insurance'] = isInsurance;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
