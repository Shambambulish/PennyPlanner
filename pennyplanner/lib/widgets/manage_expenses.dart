import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennyplanner/widgets/add_expense_dialog.dart';
import 'package:pennyplanner/widgets/edit_budget_dialog.dart';
import 'package:pennyplanner/widgets/edit_category_dialog.dart';
import 'package:pennyplanner/widgets/edit_expense_dialog.dart';
import 'package:pennyplanner/widgets/styled_dialog_popup.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ad_helper.dart';
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

DatabaseReference ref = FirebaseDatabase.instance.ref();

class _ManageExpensesState extends State<ManageExpenses> {
  BannerAd? _bannerAd;
  //initialize data stream from database for the StreamBuilder
  Stream<DatabaseEvent> readStream = ref
      .child('budgets')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .onValue;

  Future<SharedPreferences>? prefsFuture;

  @override
  void initState() {
    super.initState();

    // async database query
    // if (user doesn't have premium)
    print(widget.isPremium);
    if (!widget.isPremium!) {
      MobileAds.instance.initialize();
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (this.mounted && _bannerAd!.adUnitId.isEmpty)
              _bannerAd = ad as BannerAd;
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
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return StreamBuilder(
      stream: readStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> dbData = {};
          for (DataSnapshot data in snapshot.data!.snapshot.children) {
            dbData[data.key] = data.value;
          }

          double totalCost = 0;
          if (dbData['expenseCategories'] != null) {
            dbData['expenseCategories'].forEach((k, category) {
              if (category['expenses'] != null) {
                category['expenses'].forEach((k, expense) {
                  totalCost += expense['amount'].toDouble();
                });
              }
            });
          }

          return FutureBuilder(
              future: prefsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  SharedPreferences prefs = snapshot.data!;

                  List<Widget> categoriesIntoCards = [];

                  List<Widget> expensesIntoList = [];

                  //if there are expenseCategories, loop through them
                  //if there are expenses in those categories, loop through them
                  //add expenses to a list
                  //add categories to a list, includes the list of expenses
                  //append the list to the rendered page further down
                  if (dbData['expenseCategories'] != null) {
                    categoriesIntoCards = [];
                    dbData['expenseCategories']
                        .forEach((expenseCategoryKey, expenseCategoryValue) {
                      double expenseTotal = 0;
                      if (expenseCategoryValue['expenses'] != null) {
                        expenseCategoryValue['expenses'].forEach((k, v) {
                          expenseTotal += v['amount'];
                        });
                      }
                      double indicatorValueCalc = 1 -
                          (expenseCategoryValue['budget'] - expenseTotal) /
                              expenseCategoryValue['budget'] as double;

                      expensesIntoList = [];
                      if (expenseCategoryValue['expenses'] != null) {
                        expenseCategoryValue['expenses']
                            .forEach((expenseKey, expenseValue) {
                          expensesIntoList.add(Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: ppColors.secondaryTextColor!))),
                            child: InkWell(
                              onTap: () {
                                EditExpenseDialog.run(
                                    context,
                                    expenseValue['description'],
                                    expenseValue['amount'].toDouble(),
                                    expenseValue['isDue'],
                                    expenseCategoryKey,
                                    expenseKey,
                                    expenseValue['reoccurring'],
                                    widget.isPremium);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          expenseValue['reoccurring']
                                              ? Icon(
                                                  Icons.repeat,
                                                  size: 16,
                                                )
                                              : Container(),
                                          expenseValue['isDue'] != null
                                              ? Icon(Icons.lock_clock, size: 16)
                                              : Container(),
                                          Text(expenseValue['description'])
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        DateFormat('dd.MM.yyyy').format(
                                            expenseValue['isDue'] == null
                                                ? DateTime.parse(
                                                    expenseValue['date'])
                                                : DateTime.parse(
                                                    expenseValue['isDue'])),
                                        style: TextStyle(
                                            color: expenseValue['isDue'] == null
                                                ? ppColors.secondaryTextColor
                                                : DateTime.parse(expenseValue[
                                                                'isDue'])
                                                            .isBefore(DateTime
                                                                .now()) &&
                                                        expenseValue['isDue'] !=
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
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              '${expenseValue['amount']}${prefs.getString("currency")}')))
                                ],
                              ),
                            ),
                          ));
                        });
                      }

                      categoriesIntoCards.add(Card(
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
                                  data:
                                      const ExpandableThemeData(hasIcon: false),
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
                                                    expenseCategoryValue[
                                                            'description'] ??
                                                        "null",
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
                                                            indicatorValueCalc >=
                                                                    1
                                                                ? Colors.red
                                                                : Color(
                                                                    0xff7BE116)),
                                                    value: indicatorValueCalc),
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
                                                  '${expenseCategoryValue['budget']}${prefs.getString("currency")}',
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
                                          '${expenseCategoryValue['expenses'] == null ? '0' : expenseCategoryValue['expenses'].length.toString()} ${AppLocalizations.of(context)!.transactions}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  ppColors.secondaryTextColor),
                                        ),
                                      ),
                                      expanded: Column(children: [
                                        ...expensesIntoList,
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 219, 211, 211),
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18))),
                                              onPressed: () {
                                                AddExpenseDialog.run(
                                                    context,
                                                    expenseCategoryKey,
                                                    widget.isPremium);
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
                                                        const Color(0xff0F5B2E),
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
                                                      expenseCategoryValue[
                                                          'description'],
                                                      expenseCategoryValue[
                                                              'budget']
                                                          .toDouble(),
                                                      expenseCategoryKey);
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .edit))
                                          ],
                                        )
                                      ]))))));
                    });
                  }

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
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('MMMM y').format(
                                              DateTime.parse(
                                                  dbData['createdOn'])),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: ppColors.primaryTextColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            EditBudgetDialog.run(context,
                                                dbData['budget'].toDouble());
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
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment
                                              .topLeft, // NULLCHECK TARVITAAN
                                          child: Text(
                                            '${(dbData['budget'] - totalCost).toStringAsFixed(2)}${prefs.getString('currency')}',
                                            style: TextStyle(
                                              fontSize: 70,
                                              color: ppColors.isDarkMode
                                                  ? ppColors.secondaryTextColor
                                                  : ppColors.primaryTextColor,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              7, 0, 0, 8),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .left,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: ppColors.isDarkMode
                                                    ? ppColors
                                                        .secondaryTextColor
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
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: double.infinity,
                                    child: Text(
                                      '${dbData['budget']}${prefs.getString("currency")} ${AppLocalizations.of(context)!.budgetedForPeriod}',
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

                                if (_bannerAd != null &&
                                    _bannerAd!.adUnitId.isEmpty)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      width: _bannerAd!.size.width.toDouble(),
                                      height: _bannerAd!.size.height.toDouble(),
                                      child: AdWidget(ad: _bannerAd!),
                                    ),
                                  ),
                                if (!widget.isPremium!)
                                  const SizedBox(height: 15),
                                //AD END
                                ...categoriesIntoCards,
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 4, 0),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AddCategoryDialog.run(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 3,
                                        backgroundColor: ppColors.isDarkMode
                                            ? const Color(0xff141414)
                                            : Colors.white,
                                        foregroundColor:
                                            ppColors.primaryTextColor),
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
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
