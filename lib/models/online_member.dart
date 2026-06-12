class OnlineMember {
  final int id;
  final String name;
  final String email;
  final String phone;

  OnlineMember({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // Convert JSON (from API) into an OnlineMember object
  factory OnlineMember.fromJson(Map<String, dynamic> json) {
    return OnlineMember(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
