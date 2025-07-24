class User {
  final String userId;
  final String uniqueNickname;
  final String email;
  final String numberPhone;
  final String? displayedNickname;
  final DateTime lastEnter;

  User({
    required this.userId,
    required this.uniqueNickname,
    required this.email,
    required this.numberPhone,
    this.displayedNickname,
    required this.lastEnter,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      uniqueNickname: json['unique_nickname'],
      email: json['email'],
      numberPhone: json['number_phone'],
      displayedNickname: json['displayed_nickname'],
      lastEnter: DateTime.parse(json['last_enter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'unique_nickname': uniqueNickname,
      'email': email,
      'number_phone': numberPhone,
      'displayed_nickname': displayedNickname,
      'last_enter': lastEnter.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User('
        '  userId: $userId, '
        '  uniqueNickname: $uniqueNickname, '
        '  email: $email, '
        '  numberPhone: $numberPhone, '
        '  displayedNickname: $displayedNickname, '
        '  lastEnter: $lastEnter'
        ')';
  }
}

