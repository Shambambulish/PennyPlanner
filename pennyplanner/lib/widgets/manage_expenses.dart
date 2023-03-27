import 'package:flutter/material.dart';
import 'package:pennyplanner/models/budget.dart';
import 'package:pennyplanner/models/expense.dart';

import '../models/expense_category.dart';

class ManageExpenses extends StatefulWidget {
  const ManageExpenses({super.key});

  @override
  State<ManageExpenses> createState() => _ManageExpensesState();
}

class _ManageExpensesState extends State<ManageExpenses> {
  //init dummy data
  Budget budget = Budget(
      id: 0,
      startDate: DateTime.now(),
      endDate: DateTime(2023, 4, 30),
      budget: 2000,
      expenseCategories: [
        ExpenseCategory(
          id: 0,
          title: 'Groceries',
          expenses: [
            Expense(
              id: 0,
              title: 'Bottle of soda',
              amount: 1.72,
              date: DateTime.now(),
            ),
            Expense(
              id: 1,
              title: 'Bacon',
              amount: 2.89,
              date: DateTime.now(),
            ),
          ],
        ),
        ExpenseCategory(
          id: 1,
          title: 'Bills',
          expenses: [
            Expense(
                id: 0,
                title: 'Electricity',
                amount: 37.21,
                date: DateTime.now(),
                dueDate: DateTime(2023, 4, 12)),
            Expense(
                id: 1,
                title: 'Car payment',
                amount: 200,
                date: DateTime.now(),
                dueDate: DateTime(2023, 5, 2)),
          ],
        ),
      ]);
  //init dummy data end

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Text(
                        'Hi',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Text(
                        'Hi',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Text(
                        'Hi',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
          child: Container(),
        ),
      ],
    );
  }
}
