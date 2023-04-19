import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pennyplanner/pages/buy_premium_page.dart';
import 'package:pennyplanner/widgets/manage_expenses.dart';
import 'package:pennyplanner/widgets/manage_goals.dart';
import '../widgets/pp_appbar.dart';
import 'history_page.dart';
import 'package:pennyplanner/notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, User? user});

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

    // async database query
    // if (user doesn't have premium)
    waitForPremiumNoti();

    _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {
      showInterAd();
    });
    super.initState();
  }

  void showInterAd() {
    print("show");
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

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
    _interstitialAd?.show().then((value) => {_timerForInter.cancel()});
  }

  void waitForPremiumNoti() async {
    await notificationService.showScheduledNotification(
        id: 0,
        title: "Unlock additional features and remove ads",
        body: "Click here to buy PennyPlanner Premium now for 6,90!",
        seconds: 4);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const PPAppBar(
          title: 'Home Page',
          returnToHomePage: false,
          showSettingsBtn: true,
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'MANAGE',
                ),
                Tab(
                  text: 'HISTORY',
                ),
                Tab(
                  text: 'GOALS',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                // 1st tab
                const ManageExpenses(),
                // 2nd tab
                const HistoryPage(),
                // 3rd tab
                const ManageGoals(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void listenToNotification() => notificationService.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BuyPremiumPage(payload: payload)));
    }
  }
}
