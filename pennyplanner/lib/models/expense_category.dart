import 'expense.dart';

class ExpenseCategory {
  int id;
  String title;
  double allottedMaximum;
  List<Expense> expenses;

  ExpenseCategory(
      {required this.id,
      required this.title,
      required this.allottedMaximum,
      required this.expenses});
}
