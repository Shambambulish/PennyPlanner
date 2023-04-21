import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/models/budget.dart';
import 'package:pennyplanner/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:pennyplanner/widgets/add_expense_dialog.dart';
import 'package:pennyplanner/widgets/edit_budget_dialog.dart';
import 'package:pennyplanner/widgets/edit_category_dialog.dart';
import 'package:pennyplanner/widgets/edit_expense_dialog.dart';
import 'package:pennyplanner/widgets/styled_dialog_popup.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ad_helper.dart';
import '../models/expense_category.dart';
import '../utils/theme_provider.dart';
import 'add_category_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/signup_page.dart';
import 'add_category_dialog.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class ManageExpenses extends StatefulWidget {
  bool? isPremium = false;
  ManageExpenses({super.key, this.isPremium});

  @override
  State<ManageExpenses> createState() => _ManageExpensesState();
}

final budgetdata = <String, dynamic>{
  'title': getRandomExpense(),
  'amount': Random().nextInt(25),
  'date': DateTime.now().millisecondsSinceEpoch,
};

// random datan settausta alla älä välitä, poista jos alkaa risomaan
String getRandomExpense() {
  final expenses = [
    'Groceries',
    'Bills',
    'Entertainment',
    'Clothes',
    'Transportation',
    'Bottle of soda',
    'Bacon',
    'Electricity',
    'Car payment',
    'Movie ticket',
    'T-shirt',
    'Bus ticket',
    'Other'
  ];
  return expenses[Random().nextInt(expenses.length)];
}

final userid = FirebaseAuth.instance.currentUser!.uid;
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref('expenses').child(userid);
// final dataget =await ref.child(userid + '/budgetdata/').get();

getexpensesfromDB() async {
  final dataget = await ref.child(userid + '/budgetdata/').get();
  print(dataget.value);
  return dataget.value;
}

class _ManageExpensesState extends State<ManageExpenses> {
  BannerAd? _bannerAd;

  Future<SharedPreferences>? prefsFuture;

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
              amount: 100.00,
              date: DateTime.now(),
            ),
            Expense(
              id: 1,
              title: 'Car payment',
              amount: 400.00,
              date: DateTime.now(),
            ),
          ],
        ),
      ]);
  //init dummy data end

  @override
  void initState() {
    super.initState();

    // async database query
    // if (user doesn't have premium)
    if (!widget.isPremium!) {
      MobileAds.instance.initialize();
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (this.mounted) {
              (() {
                _bannerAd = ad as BannerAd;
              });
            }
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        ),
      ).load();
    }
    ///// end premium check
    prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    for (final i in budget.expenseCategories) {
      for (final e in i.expenses) {
        totalCost += e.amount;
      }
    }
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            SharedPreferences prefs = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ppColors.isDarkMode
                            ? const Color(0xff141414)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: ppColors.isDarkMode
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
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
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: ppColors.primaryTextColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      EditBudgetDialog.run(
                                          context, budget.getBudget);
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
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
                                      '${(budget.getBudget - totalCost).toStringAsFixed(2)}${prefs.getString('currency')}',
                                      style: TextStyle(
                                        fontSize: 70,
                                        color: ppColors.isDarkMode
                                            ? ppColors.secondaryTextColor
                                            : ppColors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(7, 0, 0, 8),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        AppLocalizations.of(context)!.left,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: ppColors.isDarkMode
                                              ? ppColors.secondaryTextColor
                                              : ppColors.primaryTextColor,
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
                                '${budget.getBudget}${prefs.getString("currency")} ${AppLocalizations.of(context)!.budgetedForPeriod}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ppColors.primaryTextColor,
                                ),
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
                      color: ppColors.isDarkMode ? Colors.black : null,
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      width: double.infinity,
                      child: Center(
                        child: Column(children: [
                          //BANNER AD

                          if (_bannerAd != null)
                            Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: _bannerAd!.size.width.toDouble(),
                                height: _bannerAd!.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd!),
                              ),
                            ),
                          if (!widget.isPremium!) const SizedBox(height: 15),
                          //AD END
                          ...budget.expenseCategories.map((e) {
                            double expenseTotal = 0;
                            for (final i in e.expenses) {
                              expenseTotal += i.amount;
                            }

                            double indicatorValueCalc = 1 -
                                (e.allottedMaximum - expenseTotal) /
                                    e.allottedMaximum;
                            return Card(
                                color: ppColors.isDarkMode
                                    ? const Color(0xff141414)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 3,
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 5, 4, 5),
                                  child: ExpandableTheme(
                                    data: const ExpandableThemeData(
                                        hasIcon: false),
                                    child: ExpandablePanel(
                                      header: Row(children: [
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  width: double.infinity,
                                                  child: Text(
                                                    e.title,
                                                    style: TextStyle(
                                                        color: ppColors
                                                            .primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            indicatorValueCalc <
                                                                    0
                                                                ? Colors.red
                                                                : Color(
                                                                    0xff7BE116)),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '-$expenseTotal${prefs.getString("currency")}',
                                                  style: TextStyle(
                                                      color: ppColors
                                                          .secondaryTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${e.allottedMaximum}${prefs.getString("currency")}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),
                                      collapsed: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 5),
                                        child: Text(
                                          '${e.expenses.length.toString()} ${AppLocalizations.of(context)!.transactions}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  ppColors.secondaryTextColor),
                                        ),
                                      ),
                                      expanded: Column(
                                        children: [
                                          ...e.expenses.map((e) {
                                            return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 0, 5),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: ppColors
                                                              .secondaryTextColor!))),
                                              child: InkWell(
                                                onTap: () {
                                                  EditExpenseDialog.run(context,
                                                      e.title, e.amount);
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            child: e.reoccurring
                                                                ? Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .repeat,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      Text(e
                                                                          .title)
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    e.title))),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          DateFormat(
                                                                  'dd.MM.yyyy')
                                                              .format(e.date),
                                                          style: TextStyle(
                                                              color: e.date.isBefore(
                                                                          DateTime
                                                                              .now()) &&
                                                                      e.dueDate !=
                                                                          null
                                                                  ? Colors.red
                                                                  : ppColors
                                                                      .secondaryTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                '${e.amount}${prefs.getString("currency")}')))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 219, 211, 211),
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18))),
                                                onPressed: () {
                                                  AddExpenseDialog.run(context);
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xff0F5B2E),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18))),
                                                  onPressed: () {
                                                    EditCategoryDialog.run(
                                                        context,
                                                        e.title,
                                                        e.allottedMaximum);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .edit))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          }).toList(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 4, 0),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                AddCategoryDialog.run(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 3,
                                  backgroundColor: ppColors.isDarkMode
                                      ? const Color(0xff141414)
                                      : Colors.white,
                                  foregroundColor: ppColors.primaryTextColor),
                              child: Text(
                                  "+ ${AppLocalizations.of(context)!.newCategory}"),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
