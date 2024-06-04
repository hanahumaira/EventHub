class User {
  String name;
  String email;
  String password;
  String phoneNum;
  String accountType;
  String? address;
  String? website;
  String? sector;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNum,
    required this.accountType,
    this.address,
    this.website,
    this.sector,
  });

  String getName() => name;
  String getEmail() => email;
  String getPassword() => password;
  String getPhone() => phoneNum;
  String getAccountType() => accountType;
  String getAddress() => address ?? '';
  String getWebsite() => website ?? '';
  String getSector() => sector ?? '';

  set setName(String name) => this.name = name;
  set setEmail(String email) => this.email = email;
  set setPassword(String password) => this.password = password;
  set setPhone(String phoneNum) => this.phoneNum = phoneNum;
  set setAccountType(String accountType) => this.accountType = accountType;
  set setAddress(String address) => this.address = address;
  set setWebsite(String website) => this.website = website;
  set setSector(String sector) => this.sector = sector;

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? phoneNum,
    String? accountType,
    String? address,
    String? website,
    String? sector,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNum: phoneNum ?? this.phoneNum,
      accountType: accountType ?? this.accountType,
      address: address ?? this.address,
      website: website ?? this.website,
      sector: sector ?? this.sector,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNum: json['phoneNum'],
      accountType: json['accountType'],
      address: json['address'],
      website: json['website'],
      sector: json['sector'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNum': phoneNum,
      'accountType': accountType,
      'address': address,
      'website': website,
      'sector': sector,
    };
  }
}
