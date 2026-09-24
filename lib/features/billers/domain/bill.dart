class Bill {
  final String id;
  final String savedBillerId;
  final double amount;
  final DateTime dueDate;
  final String billingPeriod;
  final bool isDue;

  const Bill({
    required this.id,
    required this.savedBillerId,
    required this.amount,
    required this.dueDate,
    required this.billingPeriod,
    required this.isDue,
  });
}