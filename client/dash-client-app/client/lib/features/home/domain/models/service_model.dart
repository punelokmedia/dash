class ServiceModel {
  final String  id;
  final String  name;        // from API
  final String  type;        // "WITHIN_CITY" or "OUTSTATION"
  final String? icon;        // from API (nullable)
  final bool    isActive;
  final String  title;       // ✅ for static home cards
  final String  imageUrl;    // ✅ for static home cards

  ServiceModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.isActive = true,
    String? title,
    String? imageUrl,
  })  : title    = title    ?? name,
        imageUrl = imageUrl ?? '';

  // ✅ fallback asset for bottom sheet
  String get fallbackAsset {
    switch (type) {
      case 'WITHIN_CITY': return 'assets/Icons/vehicles/tata_ace.png';
      case 'OUTSTATION':  return 'assets/Icons/vehicles/14ft.png';
      default:            return 'assets/Images/home/truck.png';
    }
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id:       json['id']?.toString() ?? '',
    name:     json['name']           ?? '',
    type:     json['type']           ?? '',
    icon:     json['icon'] as String?,
    isActive: json['isActive']       ?? true,
  );
}