class HeroImage {
  final String url;

  HeroImage({required this.url});

  factory HeroImage.fromJson(Map<String, dynamic> json) {
    return HeroImage(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}