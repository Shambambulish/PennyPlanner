import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pennyplanner/pages/buy_premium_page.dart';
import 'package:pennyplanner/utils/theme_provider.dart';
import 'package:pennyplanner/widgets/manage_expenses.dart';
import 'package:pennyplanner/widgets/manage_goals.dart';
import '../widgets/pp_appbar.dart';
import 'history_page.dart';
import 'package:pennyplanner/notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, User? user, required this.isPremium});
  bool isPremium;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Notifications notificationService;

  // COMPLETE: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  late Timer _timerForInter;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    notificationService = Notifications();
    notificationService.initialize();
    listenToNotification();

    // SHOW ADS AND NOTIFICATION IF NOT PREMIUM
    if (!widget.isPremium) {
      waitForPremiumNoti();

      _timerForInter = Timer.periodic(const Duration(seconds: 2), (result) {
        showInterAd();
      });
    }
    /////////////////////////

    checkAndUpdateBudget();
    super.initState();
  }

  //Show full-screen ad
  void showInterAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              //_moveToHome();
            },
          );

          if (mounted) {
            setState(() {
              _interstitialAd = ad;
            });
          }
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
    _interstitialAd?.show().then((value) => {_timerForInter.cancel()});
  }

// send notification about premium in 10 seconds after page load
  void waitForPremiumNoti() async {
    await notificationService.showScheduledNotification(
        id: 0,
        title: "Unlock additional features and remove ads",
        body: "Tap here to purchase PennyPlanner Premium now for 6,90!",
        seconds: 10);
  }

  /*
  check if budget information for user is empty
  if empty: set to default values
  if not: check if budget information is outdated (month has changed)
          if not: do nothing
          if yes: update for next month based on current reoccurring expenses and goals
  */
  void checkAndUpdateBudget() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('budgets');
    ref.child(FirebaseAuth.instance.currentUser!.uid).once().then((event) {
      Map<dynamic, dynamic> dbData = {};
      if (event.snapshot.children.isNotEmpty) {
        for (DataSnapshot data in event.snapshot.children) {
          dbData[data.key] = data.value;
        }
        DateTime firstOfThisMonth =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        if (DateTime.parse(dbData['createdOn']).isBefore(firstOfThisMonth)) {
          Map<String, dynamic> newCategories = {};

          double totalExpenses = 0;
          dbData['expenseCategories']
              .forEach((expenseCategoryKey, expenseCategoryValue) {
            Map<String, dynamic> newExpenses = {};
            expenseCategoryValue['expenses']
                .forEach((expenseKey, expenseValue) {
              totalExpenses += expenseValue['amount'];
              if (expenseValue['reoccurring']) {
                if (expenseValue['isDue'] != null) {
                  newExpenses[expenseKey] = {
                    'amount': expenseValue['amount'],
                    'date': expenseValue['date'],
                    'description': expenseValue['description'],
                    'reoccurring': expenseValue['reoccurring'],
                    'isDue': expenseValue['isDue']
                  };
                } else {
                  newExpenses[expenseKey] = {
                    'amount': expenseValue['amount'],
                    'date': expenseValue['date'],
                    'description': expenseValue['description'],
                    'reoccurring': expenseValue['reoccurring']
                  };
                }
              }
            });

            if (newExpenses.isNotEmpty) {
              newCategories[expenseCategoryKey] = {
                'budget': expenseCategoryValue['budget'],
                'categoryCreatedOn': expenseCategoryValue['categoryCreatedOn'],
                'description': expenseCategoryValue['description'],
                'expenses': newExpenses,
              };
            } else {
              newCategories[expenseCategoryKey] = {
                'budget': expenseCategoryValue['budget'],
                'categoryCreatedOn': expenseCategoryValue['categoryCreatedOn'],
                'description': expenseCategoryValue['description']
              };
            }
          });

          double totalMoneySaved = (dbData['budget'] - totalExpenses) *
              dbData['percentToSave'] /
              100;

          Map<String, dynamic> newGoals = {};
          if (dbData['goals'] != null) {
            dbData['goals'].forEach((goalKey, goalValue) {
              double goalMoneySaved = 0;
              if (goalValue['percentOfSavings'] != null &&
                  goalValue['percentOfSavings'].toDouble != 0) {
                goalMoneySaved +=
                    totalMoneySaved * goalValue['percentOfSavings'] / 100;
              }
              newGoals[goalKey] = {
                'amountSaved': goalValue['amountSaved'] + goalMoneySaved,
                'description': goalValue['description'],
                'percentOfSavings': goalValue['percentOfSavings'],
                'price': goalValue['price']
              };
            });
          }

          Map<String, dynamic> newBudget = {};

          newBudget[FirebaseAuth.instance.currentUser!.uid] = {
            'budget': dbData['budget'],
            'createdOn': DateTime.now().toIso8601String(),
            'expenseCategories': newCategories,
            'goals': newGoals,
            'income': dbData['income'],
            'percentToSave': dbData['percentToSave']
          };

          ref.set(newBudget);
        }
      } else {
        ref.child(FirebaseAuth.instance.currentUser!.uid).set({
          'budget': 0,
          'income': 0,
          'percentToSave': 0,
          'createdOn': DateTime.now().toIso8601String()
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PPAppBar(
          title: 'Home Page',
          returnToHomePage: false,
          showSettingsBtn: true,
          isPremium: widget.isPremium,
        ),
        body: Column(
          children: [
            Container(
              color:
                  ppColors.isDarkMode ? const Color(0xff141414) : Colors.white,
              child: TabBar(
                labelColor: ppColors.primaryTextColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.grey,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.manage,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.history,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.goals,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                // 1st tab
                ManageExpenses(isPremium: widget.isPremium),
                // 2nd tab
                HistoryPage(isPremium: widget.isPremium),
                // 3rd tab
                ManageGoals(isPremium: widget.isPremium),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // listen for taps on the notifications
  void listenToNotification() => notificationService.onNotificationClick.stream
      .listen(onNotificationListener);

  // move user to "buy premium" page after tapping notification
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BuyPremiumPage(
                    payload: payload,
                  )));
    }
  }
}
