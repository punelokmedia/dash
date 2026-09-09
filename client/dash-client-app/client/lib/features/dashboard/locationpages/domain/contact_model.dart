class ContactModel{

  final String name;
  final String phone;
  final String address;
  final String pincode;
  final bool useMobile;
  final String saveAs;

  ContactModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.pincode,
    required this.useMobile,
    required this.saveAs,
  });

  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "phone":phone, 
      "address":address,
      "pincode":pincode,
      "useMobile":useMobile,
      "saveAs":saveAs
    };
  }

}