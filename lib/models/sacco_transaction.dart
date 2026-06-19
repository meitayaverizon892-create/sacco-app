class SaccoTransaction {
  int? id;
  int memberId; // Foreign key -> members.id
  String type; // Deposit, Withdrawal
  double amount;
  String date;

  SaccoTransaction({
    this.id,
    required this.memberId,
    required this.type,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'type': type,
      'amount': amount,
      'date': date,
    };
  }

  factory SaccoTransaction.fromMap(Map<String, dynamic> map) {
    return SaccoTransaction(
      id: map['id'],
      memberId: map['memberId'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}