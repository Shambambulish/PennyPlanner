class Goal {
  int id;
  String title;
  double amount;
  DateTime date;
  DateTime? beginDate;
  bool reoccurring;

  Goal(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date,
      this.beginDate,
      this.reoccurring = false});
}
