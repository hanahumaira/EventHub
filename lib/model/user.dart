class User {
  String name;
  String email;
  String password;
  String phoneNum;
  String accountType;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNum,
    required this.accountType,
  });

  String getName() => name;
  String getEmail() => email;
  String getPassword() => password;
  String getPhone() => phoneNum;
  String getAccountType() => accountType;

  set setName(String name) => this.name = name;
  set setEmail(String email) => this.email = email;
  set setPassword(String password) => this.password = password;
  set setPhone(String phoneNum) => this.phoneNum = phoneNum;
  set setAccountType(String accountType) => this.accountType = accountType;

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? phoneNum,
    String? accountType,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNum: phoneNum ?? this.phoneNum,
      accountType: accountType ?? this.accountType,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNum: json['phoneNum'],
      accountType: json['accountType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNum': phoneNum,
      'accountType': accountType
    };
  }
}
