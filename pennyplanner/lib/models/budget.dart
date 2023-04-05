import 'package:pennyplanner/models/expense_category.dart';

class Budget {
  int id;
  DateTime startDate;
  DateTime endDate;
  double budget;
  List<ExpenseCategory> expenseCategories;

  Budget({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.expenseCategories,
  });

  DateTime get getStartDate {
    return startDate;
  }

  DateTime get getEndDate {
    return endDate;
  }

  double get getBudget {
    return budget;
  }

  List<ExpenseCategory> get getExpenseCategories {
    return expenseCategories;
  }
}
