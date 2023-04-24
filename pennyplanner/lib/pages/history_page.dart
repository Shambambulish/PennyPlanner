import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';
import '../utils/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  bool? isPremium = false;
  HistoryPage({super.key, this.isPremium});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

DatabaseReference ref = FirebaseDatabase.instance.ref();

class _HistoryPageState extends State<HistoryPage> {
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  BannerAd? _bannerAd;
  Future<SharedPreferences>? prefsFuture;

  // Set up a stream to read data from the database
  Stream<DatabaseEvent> readStream = ref
      .child('budgets')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .onValue;

  @override
  void initState() {
    prefsFuture = SharedPreferences.getInstance();
    super.initState();

    // Check if user is premium
    if (!widget.isPremium!) {
      MobileAds.instance.initialize();

      // Load a banner ad
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              if (_bannerAd!.adUnitId.isEmpty) _bannerAd = ad as BannerAd;
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
    DateFormat dateFormat =
        DateFormat.yMMMMd(); // how you want it to be formatted

    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;

    return StreamBuilder(
      stream: readStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> dbData = {};
          for (DataSnapshot data in snapshot.data!.snapshot.children) {
            dbData[data.key] = data.value;
          }
          return FutureBuilder(
            future: prefsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                SharedPreferences prefs = snapshot.data!;

                List<Widget> categoriesIntoCards = [];
                List<Widget> expensesIntoList = [];
                Map<String, double> expensesForCalc = {};
                if (dbData['expenseCategories'] != null) {
                  dbData['expenseCategories']
                      .forEach((expenseCategoryKey, expenseCategoryValue) {
                    double sum = 0;
                    expensesIntoList = [];
                    List<Widget> expensesPerCategory = [];
                    if (expenseCategoryValue['expenses'] != null) {
                      print(expenseCategoryValue['expenses']);
                      expenseCategoryValue['expenses']
                          .forEach((expenseKey, expenseValue) {
                        if (DateTime.parse(expenseValue['date'])
                                .isAfter(startDate) &&
                            DateTime.parse(expenseValue['date'])
                                .isBefore(endDate)) {
                          sum += expenseValue['amount'];
                          expensesIntoList.add(Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: ppColors.secondaryTextColor!))),
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
                                    ))),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(DateFormat('dd.MM.yyyy').format(
                                        DateTime.parse(expenseValue['date']))),
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
                          ));
                        }
                      });

                      if (expensesIntoList.isNotEmpty) {
                        categoriesIntoCards.add(Card(
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
                                    expenseCategoryValue['description'],
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
                                          '${expensesIntoList.length.toString()} ${AppLocalizations.of(context)!.transactions}')),
                                ),
                                expanded: Column(children: expensesIntoList),
                              ),
                            ),
                          ),
                        ));
                      }

                      if (sum > 0) {
                        expensesForCalc[expenseCategoryValue['description']] =
                            sum;
                      }
                    }
                  });
                }

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
                                dateFormat.format(startDate),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "Hind Siliguri",
                                    color: ppColors.primaryTextColor),
                              ),
                              onTap: () async {
                                await showDatePicker(
                                        context: context,
                                        initialDate:
                                            startDate, //get today's date
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101))
                                    .then((value) {
                                  setState(() {
                                    if (value != null) {
                                      startDate = value;
                                    }
                                  });
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
                                await showDatePicker(
                                        context: context,
                                        initialDate: endDate, //get today's date
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101))
                                    .then((value) {
                                  setState(() {
                                    if (value != null) endDate = value;
                                  });
                                });
                              },
                              child: Text(
                                dateFormat.format(endDate),
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
                        if (expensesForCalc.isNotEmpty)
                          Container(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: PieChart(
                                dataMap: expensesForCalc,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
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
                          if (!widget.isPremium!) const SizedBox(height: 30), //
                          //AD END
                          ...categoriesIntoCards
                        ]),
                      ],
                    ),
                  ],
                ));
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
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
