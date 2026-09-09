class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final int bgColor; // hex color int e.g. 0xFF2E7D32

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl = '',
    this.bgColor  = 0xFF2E7D32,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id:       json['id']        as String,
        imageUrl: json['image_url'] as String? ?? '',
        title:    json['title']     as String,
        subtitle: json['subtitle']  as String? ?? '',
        bgColor:  json['bg_color']  as int?    ?? 0xFF2E7D32,
      );
}