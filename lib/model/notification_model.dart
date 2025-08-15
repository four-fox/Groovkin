class NotificationModel {
  bool? status;
  Data? data;
  String? message;

  NotificationModel({this.status, this.data, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? currentPage;
  List<Datas>? datas;
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

  Data(
      {this.currentPage,
      this.datas,
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

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      datas = <Datas>[];
      json['data'].forEach((v) {
        datas!.add(Datas.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
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
    if (datas != null) {
      data['data'] = datas!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
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

class Datas {
  int? id;
  String? text;
  int? sourceId;
  int? senderId;
  String? type;
  int? relatedId;
  String? relatedType;
  String? createdAt;
  String? updatedAt;
  NotificationReceiver? notificationReceiver;
  Sender? sender;

  Datas(
      {this.id,
      this.text,
      this.sourceId,
      this.senderId,
      this.type,
      this.relatedId,
      this.relatedType,
      this.createdAt,
      this.updatedAt,
      this.notificationReceiver,
      this.sender});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    sourceId = json['source_id'];
    senderId = json['sender_id'];
    type = json['type'];
    relatedId = json['related_id'];
    relatedType = json['related_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    notificationReceiver = json['notification_receiver'] != null
        ? NotificationReceiver.fromJson(json['notification_receiver'])
        : null;
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['source_id'] = sourceId;
    data['sender_id'] = senderId;
    data['type'] = type;
    data['related_id'] = relatedId;
    data['related_type'] = relatedType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (notificationReceiver != null) {
      data['notification_receiver'] = notificationReceiver!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    return data;
  }
}

class NotificationReceiver {
  int? id;
  int? notificationId;
  int? receiverId;
  int? isSeen;
  String? createdAt;
  String? updatedAt;
  Receiver? receiver;

  NotificationReceiver(
      {this.id,
      this.notificationId,
      this.receiverId,
      this.isSeen,
      this.createdAt,
      this.updatedAt,
      this.receiver});

  NotificationReceiver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationId = json['notification_id'];
    receiverId = json['receiver_id'];
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    receiver =
        json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notification_id'] = notificationId;
    data['receiver_id'] = receiverId;
    data['is_seen'] = isSeen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    return data;
  }
}

class Receiver {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  Null referralCode;
  Null emailVerifiedAt;
  Null otp;
  String? activeRole;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  ProfilePicture? profilePicture;

  Receiver(
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
      this.profile,
      this.profilePicture});

  Receiver.fromJson(Map<String, dynamic> json) {
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
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    profilePicture = json["profile_picture"] != null
        ? ProfilePicture.fromJson(json['profile_picture'])
        : null;
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
    data['active_role'] = activeRole;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (profilePicture != null) {
      data['profile_picture'] = profilePicture!.toJson();
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
  String? companyName;
  String? country;
  String? selectState;
  Null location;
  String? about;
  Null latitude;
  Null longitude;
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

class Sender {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic referralCode;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? activeRole;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  ProfilePicture? profilePicture;

  Sender({
    this.id,
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
    this.profile,
    this.profilePicture,
  });

  Sender.fromJson(Map<String, dynamic> json) {
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
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    profilePicture = json["profile_picture"] != null
        ? ProfilePicture.fromJson(json['profile_picture'])
        : null;
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
    data['active_role'] = activeRole;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (profilePicture != null) {
      data['profile_picture'] = profilePicture!.toJson();
    }
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

class ProfilePicture {
  final int id;
  final String mediaFor;
  final String? thumbnail;
  final String mediaPath;
  final String mediaType;
  final String galleryableType;
  final int galleryableId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfilePicture({
    required this.id,
    required this.mediaFor,
    this.thumbnail,
    required this.mediaPath,
    required this.mediaType,
    required this.galleryableType,
    required this.galleryableId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method to parse JSON into ProfilePicture object
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: json['id'],
      mediaFor: json['media_for'],
      thumbnail: json['thumbnail'],
      mediaPath: json['media_path'],
      mediaType: json['media_type'],
      galleryableType: json['galleryable_type'],
      galleryableId: json['galleryable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert ProfilePicture object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_for': mediaFor,
      'thumbnail': thumbnail,
      'media_path': mediaPath,
      'media_type': mediaType,
      'galleryable_type': galleryableType,
      'galleryable_id': galleryableId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
