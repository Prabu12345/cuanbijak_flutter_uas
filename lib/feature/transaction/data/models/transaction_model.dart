import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.ownerId,
    required super.money,
    required super.category,
    required super.date,
    required super.updatedAt,
    required super.transactionStatus,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'owner_id': ownerId,
      'money': money,
      'category': category,
      'date': date.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'transaction_status': transactionStatus,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      ownerId: map['owner_id'] as String,
      money: double.parse(map['money'].toString()),
      category: map['category'] as String,
      date: map['date'] == null ? DateTime.now() : DateTime.parse(map['date']),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      transactionStatus: map['transaction_status'] as String,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? ownerId,
    double? money,
    String? category,
    String? transactionStatus,
    DateTime? date,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      money: money ?? this.money,
      category: category ?? this.category,
      date: date ?? this.date,
      updatedAt: updatedAt ?? this.updatedAt,
      transactionStatus: transactionStatus ?? this.transactionStatus,
    );
  }
}
