import 'package:pennyplanner/models/goal_category.dart';

class savedBudget {
  int id;
  DateTime startDate;
  DateTime endDate;
  double incomebudget;
  List<GoalCategory> goalCategories;

  savedBudget({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.incomebudget,
    required this.goalCategories,
  });

  DateTime get getStartDate {
    return startDate;
  }

  DateTime get getEndDate {
    return endDate;
  }

  double get getincomeBudget {
    return incomebudget;
  }

  List<GoalCategory> get getGoalCategories {
    return goalCategories;
  }
}
