import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

class HomePage extends StatefulWidget {
  HomePage({super.key, User? user});

  bool isPremium = false;
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
    //  widget.isPremium = if (user doesn't have premium)
    // end premium checker

    //SHOW ADS AND NOTI IF NOT PREMIUM
    if (!widget.isPremium) {
      waitForPremiumNoti();

      _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {
        showInterAd();
      });
    }
    /////////////////////////

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

          if (this.mounted) {
            print("ismoutned");
            setState(() {
              print("here");
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

  void waitForPremiumNoti() async {
    await notificationService.showScheduledNotification(
        id: 0,
        title: "Unlock additional features and remove ads",
        body: "Tap here to purchase PennyPlanner Premium now for 6,90!",
        seconds: 10);
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
