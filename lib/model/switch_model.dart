class SwitchProfile {
  bool? status;
  Data? data;
  String? message;

  SwitchProfile({this.status, this.data, this.message});

  SwitchProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  Null? referralCode;
  Null? emailVerifiedAt;
  Null? otp;
  String? activeRole;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? token;
  int? isEventCreated;
  int? isUserCreated;
  int? isManagerCreated;
  Profile? profile;
  List<Roles>? roles;

  Data(
      {this.id,
        this.name,
        this.email,
        this.deviceToken,
        this.referralCode,
        this.emailVerifiedAt,
        this.otp,
        this.activeRole,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.token,
        this.isEventCreated,
        this.isUserCreated,
        this.isManagerCreated,
        this.profile,
        this.roles});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    deviceToken = json['device_token'];
    referralCode = json['referral_code'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    activeRole = json['active_role'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
    isEventCreated = json['is_event_created'];
    isUserCreated = json['is_user_created'];
    isManagerCreated = json['is_manager_created'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['device_token'] = this.deviceToken;
    data['referral_code'] = this.referralCode;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['otp'] = this.otp;
    data['active_role'] = this.activeRole;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    data['is_event_created'] = this.isEventCreated;
    data['is_user_created'] = this.isUserCreated;
    data['is_manager_created'] = this.isManagerCreated;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['birth_year'] = this.birthYear;
    data['phone_number'] = this.phoneNumber;
    data['company_name'] = this.companyName;
    data['country'] = this.country;
    data['select_state'] = this.selectState;
    data['location'] = this.location;
    data['about'] = this.about;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_insurance'] = this.isInsurance;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
        this.name,
        this.guardName,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? modelType;
  int? modelId;
  int? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'];
    modelId = json['model_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    return data;
  }
}
