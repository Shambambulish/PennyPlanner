import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/models/savedbudget.dart';
import 'package:pennyplanner/models/saving_goal.dart';
import 'package:intl/intl.dart';
import 'add_category_dialog.dart';
import 'package:pennyplanner/widgets/add_goal_dialog.dart';
import 'package:pennyplanner/widgets/edit_category_dialog.dart';
import 'package:pennyplanner/widgets/edit_goal_dialog.dart';
import 'package:pennyplanner/widgets/styled_dialog_popup.dart';
import 'package:pennyplanner/widgets/edit_income_dialog.dart';

import '../models/goal_category.dart';

class ManageGoals extends StatefulWidget {
  const ManageGoals({super.key});

  @override
  State<ManageGoals> createState() => _ManageGoalsState();
}

class _ManageGoalsState extends State<ManageGoals> {
  //init dummy data
  savedBudget savedbudget = savedBudget(
      id: 0,
      startDate: DateTime(2023, 2, 1),
      endDate: DateTime.now(),
      incomebudget: 2480,
      goalCategories: [
        GoalCategory(
          savedAmount: 200,
          id: 0,
          title: 'Uusi jääkaappi',
          goalAmount: 600,

          savingGoal: [
          ],
        ),
        GoalCategory(
          savedAmount: 1000,
          id: 1,
          title: 'Autolaina',
          goalAmount: 3000,
          savingGoal: [
           
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
                            'Income',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Color(0xff0F5B2E),
                            ),
                          ),
                        Spacer(),
                        
                        InkWell(
                          onTap: () {
                            EditIncomeDialog.run(context, savedbudget.getincomeBudget);
                          },
                          child: Icon(
                            Icons.edit
                          ),
                        ),
                        SizedBox(width: 10),
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
                              '${savedbudget.getincomeBudget}€',
                              style: const TextStyle(
                                fontSize: 70,
                                color: Color(0xff0F5B2E),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                ' /month',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color(0xff0F5B2E),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [...savedbudget.goalCategories.map((e) {
                      e.goalAmount;
                      double totalCost = 0;
                      for (final i in e.savingGoal) {
                        totalCost += i.amount;
                      }
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(8, 5, 4, 5),
                      
                            child: Column (
                                children: [Row(children: [
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
                                                  (e.goalAmount - e.savedAmount) /
                                                      e.goalAmount),
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
                                             
                                            '${e.goalAmount}€ ',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ]),
                                Row(
                                      children: [
                                      Text(
                                    '${e.savedAmount}€ saved since ${savedbudget.startDate}',
                                    style: const TextStyle(fontSize: 14),
                                    
                                  ),
                                        const Spacer(),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff0F5B2E),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(18))),
                                            onPressed: () {
                                                  EditGoalDialog.run(context,
                                                  e.title, e.goalAmount, e.savedAmount);
                                            },
                                            child: const Text("EDIT"))
                                      ],
                                    ),
                                ],
                                
                            ),
                          
                          ));
                    }).toList(),
                    Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 4, 0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AddGoalDialog.run(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff0F5B2E)),
                      child: const Text("+ NEW GOAL"),
                    ),
                  )
                   
                  ],),
                ),
                
              ),
            ),
          
              
        ),
      ],
      );
  }
}
