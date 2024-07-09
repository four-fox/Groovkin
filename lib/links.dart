class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class Meta {
  int? itemCount;
  int? totalItems;
  int? itemsPerPage;
  int? totalPages;
  int? currentPage;

  Meta({
    this.itemCount,
    this.totalItems,
    this.itemsPerPage,
    this.totalPages,
    this.currentPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    itemCount: json["itemCount"],
    totalItems: json["totalItems"],
    itemsPerPage: json["itemsPerPage"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "itemCount": itemCount,
    "totalItems": totalItems,
    "itemsPerPage": itemsPerPage,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}