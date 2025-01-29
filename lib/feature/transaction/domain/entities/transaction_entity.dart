class TransactionEntity {
  final String id;
  final String ownerId;
  final double money;
  final String transactionStatus;
  final String category;
  final DateTime date;
  final DateTime updatedAt;

  TransactionEntity({
    required this.id,
    required this.ownerId,
    required this.money,
    required this.transactionStatus,
    required this.category,
    required this.date,
    required this.updatedAt,
  });
}
