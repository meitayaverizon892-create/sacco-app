class Loan {
  int? id;
  int memberId; // Foreign key -> members.id
  double amount;
  String purpose;
  int durationMonths;
  String guarantorName;
  String status; // Pending, Approved, Rejected
  String dateApplied;

  Loan({
    this.id,
    required this.memberId,
    required this.amount,
    required this.purpose,
    required this.durationMonths,
    required this.guarantorName,
    this.status = 'Pending',
    required this.dateApplied,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'amount': amount,
      'purpose': purpose,
      'durationMonths': durationMonths,
      'guarantorName': guarantorName,
      'status': status,
      'dateApplied': dateApplied,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      memberId: map['memberId'],
      amount: map['amount'],
      purpose: map['purpose'],
      durationMonths: map['durationMonths'],
      guarantorName: map['guarantorName'],
      status: map['status'],
      dateApplied: map['dateApplied'],
    );
  }
}