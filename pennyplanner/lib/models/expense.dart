class Expense {
  int id;
  String title;
  double amount;
  DateTime date;
  DateTime? dueDate;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.dueDate,
  });
}
