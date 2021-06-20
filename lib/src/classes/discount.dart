class Discount {
  final String code;
  final int percent; // 20 means 20% discount

  const Discount(this.code, this.percent);

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(json['code'], json['percent']);
  }

}