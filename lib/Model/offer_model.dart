class Offer {
  int? id;
  String? title;
  String? image;
  int? categoryId;
  int? ownerId;
  double? actualPrice;
  double? discountPrice;
  int? rewardPoints;
  String? shortDetail;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isClaimed;
  int? isAvailed;

  Offer({
    this.id,
    this.title,
    this.image,
    this.categoryId,
    this.ownerId,
    this.actualPrice,
    this.discountPrice,
    this.rewardPoints,
    this.shortDetail,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isClaimed,
    this.isAvailed,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        categoryId: json["category_id"],
        ownerId: json["owner_id"],
        actualPrice: json["actual_price"],
        discountPrice: json["discount_price"],
        rewardPoints: json["reward_points"],
        shortDetail: json["short_detail"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isClaimed: json["is_claimed"],
        isAvailed: json["is_availed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "category_id": categoryId,
        "owner_id": ownerId,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "reward_points": rewardPoints,
        "short_detail": shortDetail,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_claimed": isClaimed,
        "is_availed": isAvailed,
      };
}
