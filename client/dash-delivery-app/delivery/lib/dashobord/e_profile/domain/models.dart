class ProfileModel {
  final String name;
  final String regNo;
  final String vehicleRc;
  final String fuelType;
  final String numberPlate;
  final String dateOfManufacture;
  final String? profileImageUrl;

  const ProfileModel({
    required this.name,
    required this.regNo,
    required this.vehicleRc,
    required this.fuelType,
    required this.numberPlate,
    required this.dateOfManufacture,
    this.profileImageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> j) => ProfileModel(
        name: j['name'] ?? '',
        regNo: j['reg_no'] ?? '',
        vehicleRc: j['vehicle_rc'] ?? '',
        fuelType: j['fuel_type'] ?? '',
        numberPlate: j['number_plate'] ?? '',
        dateOfManufacture: j['date_of_manufacture'] ?? '',
        profileImageUrl: j['profile_image_url'],
      );

  static const demo = ProfileModel(
    name: 'Manoj Yadav',
    regNo: '2897635 0000',
    vehicleRc: '2345678',
    fuelType: 'Petrol',
    numberPlate: 'MH 12 12345678900',
    dateOfManufacture: '13-03-2013',
  );
}