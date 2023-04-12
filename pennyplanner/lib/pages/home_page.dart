import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pennyplanner/pages/buy_premium_page.dart';
import 'package:pennyplanner/widgets/manage_expenses.dart';
import '../widgets/pp_appbar.dart';
import 'history_page.dart';
import 'package:pennyplanner/notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    waitForPremiumNoti(); //JOS ALKAA ÄRSYTTÄÄ NIIN KOMMENTOI POIS
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
        title: "scheduled",
        body: "noni ostappa se premium jo painamalla tästä",
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
                Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
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
                      ),
                    ),
                    Expanded(flex: 7, child: Container()),
                  ],
                ),
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
