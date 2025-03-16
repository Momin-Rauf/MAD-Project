class ProfileDTO {
  final String name;
  final String imageName;
  final String phone;
  final String email;
  final bool biometric;
  final String address;

  ProfileDTO({
    required this.name,
    required this.imageName,
    required this.phone,
    required this.email,
    required this.biometric,
    required this.address,
  });

  // Convert from Map to DTO
  factory ProfileDTO.fromMap(Map<String, dynamic> map) {
    return ProfileDTO(
      name: map['name'] ?? '',
      imageName: map['imageName'] ?? 'assets/profile.png',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      biometric: map['biometric'] ?? false,
      address: map['address'] ?? '',
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageName': imageName,
      'phone': phone,
      'email': email,
      'biometric': biometric,
      'address': address,
    };
  }
}
