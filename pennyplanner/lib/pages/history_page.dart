import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/expense_category.dart';
import 'package:pennyplanner/models/budget.dart';
import 'package:pennyplanner/models/expense.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';
import '../utils/theme.dart';

class HistoryPage extends StatefulWidget {
  bool? isPremium = false;
  HistoryPage({super.key, this.isPremium});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

//MAP CATEGORIES

class _HistoryPageState extends State<HistoryPage> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    // widget.isPremium = if (async database query user doesn't have premium)
    if (!widget.isPremium!) {
      MobileAds.instance.initialize();

      // COMPLETE: Load a banner ad
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        ),
      ).load();
    }
    ///// end premium check
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void fetchWithDate() {
      if (kDebugMode) {
        print("fetchwithdate");
      }

      //tietokantakutsu startdaten ja enddaten perusteella
      // asetus resultdataan
    }

    fetchWithDate();

    Budget history = Budget(
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

    Map<String, double> calcPercentages() {
      Map<String, double> chartMap = {};
      for (ExpenseCategory e in history.expenseCategories) {
        double sum = 0;
        for (Expense ex in e.expenses) {
          sum += ex.amount;
        }
        chartMap[e.title] = sum;
      }
      return chartMap;
    }

    DateFormat dateFormat =
        DateFormat.yMMMMd(); // how you want it to be formatted

    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;

    return SingleChildScrollView(
        child: Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                InkWell(
                  child: Text(
                    startDate == null
                        ? dateFormat.format(DateTime.now())
                        : dateFormat.format(startDate!),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Hind Siliguri",
                        color: ppColors.primaryTextColor),
                  ),
                  onTap: () async {
                    startDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101))
                        .then((value) {
                      setState(() {
                        // d = value!;
                      });
                      return value;
                    });
                  },
                ),
                Text(
                  " - ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Hind Siliguri",
                      color: ppColors.primaryTextColor),
                ),
                InkWell(
                  onTap: () async {
                    endDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101))
                        .then((value) {
                      setState(() {
                        // d = value!;
                      });
                      return value;
                    });
                  },
                  child: Text(
                    endDate == null
                        ? dateFormat.format(DateTime.now())
                        : dateFormat.format(endDate!),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Hind Siliguri",
                        color: ppColors.primaryTextColor),
                  ),
                ),
              ]),
            ),
            //PIECHART
            Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: PieChart(
                  dataMap: calcPercentages(),
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                )),
            //PIECHART END
            Column(children: [
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
              if (!widget.isPremium!) SizedBox(height: 30), //
              //AD END
              ...history.expenseCategories.map((e) {
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
                        header: Container(
                          child: Text(
                            e.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Hind Siliguri",
                                color: ppColors.primaryTextColor),
                          ),
                        ),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 20,
                              child: Text(
                                  '${e.expenses.length.toString()} transactions')),
                        ),
                        expanded: Column(children: [
                          ...e.expenses.map((e) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color:
                                              ppColors.secondaryTextColor!))),
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
                                          alignment: Alignment.centerRight,
                                          child: Text('${e.amount}€')))
                                ],
                              ),
                            );
                          }).toList(),
                        ]),
                      ),
                    ),
                  ),
                );
              })
            ]),
          ],
        ),
      ],
    ));
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
