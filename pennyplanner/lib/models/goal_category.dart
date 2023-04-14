import 'saving_goal.dart';

class GoalCategory {
  int id;
  String title;
  double goalAmount;
  double savedAmount;
  List<Goal> savingGoal;

  GoalCategory(
      {required this.id,
      required this.title,
      required this.goalAmount,
      required this.savedAmount,
      required this.savingGoal});
}
