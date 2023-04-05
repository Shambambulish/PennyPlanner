import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/models/budget.dart';
import 'package:pennyplanner/models/expense.dart';
import 'package:intl/intl.dart';

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
          allottedMaximum: 350.00,
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
          allottedMaximum: 500.00,
          expenses: [
            Expense(
                id: 0,
                title: 'Electricity',
                amount: 50,
                reoccurring: true,
                date: DateTime.now(),
                dueDate: DateTime(2023, 4, 12)),
            Expense(
                id: 1,
                title: 'Car payment',
                amount: 200,
                reoccurring: true,
                date: DateTime.now(),
                dueDate: DateTime(2023, 5, 2)),
          ],
        ),
      ]);
  //init dummy data end

  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    for (final i in budget.expenseCategories) {
      for (final e in i.expenses) {
        totalCost += e.amount;
      }
    }

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            '${DateFormat('dd.MM.').format(budget.getStartDate)} - ${DateFormat('dd.MM.').format(budget.getEndDate)}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xff0F5B2E),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${(budget.getBudget - totalCost).toStringAsFixed(2)}€',
                              style: const TextStyle(
                                fontSize: 70,
                                color: Color(0xff0F5B2E),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(7, 0, 0, 8),
                            child: const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'left',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff0F5B2E),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: double.infinity,
                      child: Text(
                        '${budget.getBudget}€ budgeted for this period',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff0F5B2E),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            width: double.infinity,
            child: Center(
              child: Column(children: [
                ...budget.expenseCategories.map((e) {
                  double expenseTotal = 0;
                  for (final i in e.expenses) {
                    expenseTotal += i.amount;
                  }
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8, 5, 4, 5),
                        child: ExpandableTheme(
                          data: const ExpandableThemeData(hasIcon: false),
                          child: ExpandablePanel(
                            header: Row(children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        width: double.infinity,
                                        child: Text(
                                          e.title,
                                          style: const TextStyle(
                                              color: Color(0xff0F5B2E),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      LinearProgressIndicator(
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  Color(0xff7BE116)),
                                          value: 1 -
                                              (e.allottedMaximum -
                                                      expenseTotal) /
                                                  e.allottedMaximum),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '-$expenseTotal€',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${e.allottedMaximum}€',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ]),
                              ),
                            ]),
                            collapsed: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                '${e.expenses.length.toString()} transactions',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            expanded: Column(
                              children: [
                                ...e.expenses.map((e) {
                                  return Container(
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                                child: e.reoccurring
                                                    ? Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.repeat,
                                                            size: 16,
                                                          ),
                                                          Text(e.title)
                                                        ],
                                                      )
                                                    : Text(e.title))),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(DateFormat('dd.MM.yyyy')
                                                .format(e.date)),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text('${e.amount}€')))
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 219, 211, 211),
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18))),
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff0F5B2E),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18))),
                                        onPressed: () {},
                                        child: const Text("EDIT"))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                }).toList(),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}