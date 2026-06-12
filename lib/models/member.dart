class Member {
  int? id;
  String name;
  String memberNumber;
  double savings;
  String phone;

  Member({
    this.id,
    required this.name,
    required this.memberNumber,
    required this.savings,
    required this.phone,
  });

  // Convert a Member into a Map (for saving to database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'memberNumber': memberNumber,
      'savings': savings,
      'phone': phone,
    };
  }

  // Convert a Map (from database) into a Member object
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      memberNumber: map['memberNumber'],
      savings: map['savings'],
      phone: map['phone'],
    );
  }
}
