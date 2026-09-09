class AddressModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String house;
  final String address;
  final String pincode;
  final double? latitude;   // ← nullable
  final double? longitude;  // ← nullable
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.house,
    required this.address,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id:        json['id'] as String,
      userId:    json['userId'] as String,
      name:      json['name'] as String,
      phone:     json['phone'] as String,
      house:     json['house'] as String,
      address:   json['address'] as String,
      pincode:   json['pincode'] as String,
      latitude:  (json['latitude'] as num?)?.toDouble(),   // ← null-safe
      longitude: (json['longitude'] as num?)?.toDouble(),  // ← null-safe
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':        id,
    'userId':    userId,
    'name':      name,
    'phone':     phone,
    'house':     house,
    'address':   address,
    'pincode':   pincode,
    'latitude':  latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };
}