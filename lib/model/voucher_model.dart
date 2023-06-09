import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String? id;
  final double amount;
  final String code;
  final String description;
  final DateTime expirationDate;
  final bool isPercent;

  Voucher({
    this.id,
    required this.amount,
    required this.code,
    required this.description,
    required this.expirationDate,
    required this.isPercent,
  });

  factory Voucher.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Voucher(
      id: snapshot.id,
      amount: data['amount']?.toDouble() ?? 0.0,
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      expirationDate: data['expirationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data['expirationDate'].millisecondsSinceEpoch)
          : DateTime.now(),
      isPercent: data['isPercent'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'code': code,
      'description': description,
      'expirationDate': expirationDate,
      'isPercent': isPercent,
    };
  }
}
