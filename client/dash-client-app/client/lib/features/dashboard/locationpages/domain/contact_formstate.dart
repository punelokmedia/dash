class ContactState {
  final String  name;
  final String  phone;
  final String  address;
  final String  pincode;
  final bool    useMobile;
  final String  saveAs;
  final bool    isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ContactState({
    this.name           = '',
    this.phone          = '',
    this.address        = '',
    this.pincode        = '',
    this.useMobile      = false,
    this.saveAs         = '',
    this.isLoading      = false,
    this.errorMessage,
    this.successMessage,
  });

  ContactState copyWith({
    String?  name,
    String?  phone,
    String?  address,
    String?  pincode,
    bool?    useMobile,
    String?  saveAs,
    bool?    isLoading,
    String?  errorMessage,
    String?  successMessage,
  }) {
    return ContactState(
      name:           name           ?? this.name,
      phone:          phone          ?? this.phone,
      address:        address        ?? this.address,
      pincode:        pincode        ?? this.pincode,
      useMobile:      useMobile      ?? this.useMobile,
      saveAs:         saveAs         ?? this.saveAs,
      isLoading:      isLoading      ?? this.isLoading,
      errorMessage:   errorMessage,
      successMessage: successMessage,
    );
  }
}