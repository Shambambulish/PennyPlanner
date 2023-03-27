import 'expense.dart';

class ExpenseCategory {
  int id;
  String title;
  List<Expense> expenses;

  ExpenseCategory(
      {required this.id, required this.title, required this.expenses});
}
