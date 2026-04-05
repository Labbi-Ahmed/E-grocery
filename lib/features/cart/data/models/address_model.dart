class AddressModel {
  final String id;
  final String label;
  final String fullName;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String phone;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$address, $city, $state $zipCode, $country';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      label: json['label'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      zipCode: json['zip_code'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }
}
