class Member {
  int? id;
  String name;
  String memberNumber;
  double savings;
  String phone;
  String? passwordHash; // Hashed with bcrypt - never store plain text

  Member({
    this.id,
    required this.name,
    required this.memberNumber,
    required this.savings,
    required this.phone,
    this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'memberNumber': memberNumber,
      'savings': savings,
      'phone': phone,
      'passwordHash': passwordHash,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      memberNumber: map['memberNumber'],
      savings: map['savings'],
      phone: map['phone'],
      passwordHash: map['passwordHash'],
    );
  }
}