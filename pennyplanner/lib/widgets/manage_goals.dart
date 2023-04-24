import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ad_helper.dart';
import '../utils/theme_provider.dart';
import 'add_category_dialog.dart';
import 'package:pennyplanner/widgets/add_goal_dialog.dart';
import 'package:pennyplanner/widgets/edit_category_dialog.dart';
import 'package:pennyplanner/widgets/edit_goal_dialog.dart';
import 'package:pennyplanner/widgets/styled_dialog_popup.dart';
import 'package:pennyplanner/widgets/edit_income_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageGoals extends StatefulWidget {
  bool? isPremium = false;
  ManageGoals({super.key, this.isPremium});

  @override
  State<ManageGoals> createState() => _ManageGoalsState();
}

DatabaseReference ref = FirebaseDatabase.instance.ref();

class _ManageGoalsState extends State<ManageGoals> {
  BannerAd? _bannerAd;
  //alustetaan stream lukemaan dataa tietokannasta
  Stream<DatabaseEvent> readStream = ref
      .child('budgets')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .onValue;

  Future<SharedPreferences>? prefsFuture;

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

            return FutureBuilder(
                future: prefsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    SharedPreferences prefs = snapshot.data!;

                    List<Widget> goals = [];
                    double savingsUsed = 0;
                    //if there are goals, loop through and add them and their data to a list to append to the widget tree below
                    if (dbData['goals'] != null) {
                      dbData['goals'].forEach((goalKey, goalValue) {
                        if (goalValue['percentOfSavings'] != null) {
                          savingsUsed += goalValue['percentOfSavings'];
                        }
                        goals.add(Card(
                            color: ppColors.isDarkMode
                                ? const Color(0xff141414)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 3,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(8, 5, 4, 5),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              width: double.infinity,
                                              child: Text(
                                                '${goalValue['description']} (${goalValue['percentOfSavings']}%)',
                                                style: TextStyle(
                                                    color: ppColors
                                                        .primaryTextColor,
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
                                                    (goalValue['price'] -
                                                            goalValue[
                                                                'amountSaved']) /
                                                        goalValue[
                                                            'price'] as double),
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
                                              '${goalValue['price']}€ ',
                                              style: TextStyle(
                                                color:
                                                    ppColors.secondaryTextColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Text(
                                        '${goalValue['amountSaved']}${prefs.getString("currency")} ${AppLocalizations.of(context)!.savedSince} ${DateFormat('dd.MM.').format(DateTime.parse(goalValue['date'] ?? DateTime.now().toIso8601String()))}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff0F5B2E),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18))),
                                          onPressed: () {
                                            EditGoalDialog.run(
                                                context,
                                                goalValue['description'],
                                                goalValue['price'].toDouble(),
                                                goalValue['percentOfSavings']
                                                    .toDouble(),
                                                100 - savingsUsed,
                                                goalKey);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .edit))
                                    ],
                                  ),
                                ],
                              ),
                            )));
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .income,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: ppColors.primaryTextColor,
                                            ),
                                          ),
                                          Text(
                                            ' (${dbData['percentToSave']}% ${AppLocalizations.of(context)!.intoSavings})',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ppColors.primaryTextColor,
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              EditIncomeDialog.run(
                                                  context,
                                                  dbData['income'].toDouble(),
                                                  dbData['percentToSave']
                                                      .toDouble());
                                            },
                                            child: Icon(Icons.edit),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${dbData['income']}${prefs.getString("currency")}',
                                              style: TextStyle(
                                                fontSize: 70,
                                                color:
                                                    ppColors.primaryTextColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                ' ${AppLocalizations.of(context)!.perMonth}',
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  color:
                                                      ppColors.primaryTextColor,
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
                                  children: [
                                    //BANNER AD

                                    if (_bannerAd != null)
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: SizedBox(
                                          width:
                                              _bannerAd!.size.width.toDouble(),
                                          height:
                                              _bannerAd!.size.height.toDouble(),
                                          child: AdWidget(ad: _bannerAd!),
                                        ),
                                      ),
                                    if (!widget.isPremium!)
                                      SizedBox(height: 15), //
                                    //AD END
                                    ...goals,
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 4, 0),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (savingsUsed > 99.9) {
                                            var snackBar = SnackBar(
                                                content: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .savingsExceeded));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            return;
                                          }

                                          AddGoalDialog.run(
                                              context, 100 - savingsUsed);
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
                                                const Color(0xff0F5B2E)),
                                        child: Text(
                                          "+ ${AppLocalizations.of(context)!.newGoal}",
                                          style: TextStyle(
                                              color: ppColors.primaryTextColor),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
