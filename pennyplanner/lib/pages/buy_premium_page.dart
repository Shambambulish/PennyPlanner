import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/theme_provider.dart';
import '../widgets/pp_appbar.dart';
import 'package:pennyplanner/notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuyPremiumPage extends StatefulWidget {
  BuyPremiumPage({super.key, required payload});

  @override
  State<BuyPremiumPage> createState() => _BuyPremiumPageState();
}

class _BuyPremiumPageState extends State<BuyPremiumPage> {
  late final Notifications notificationService;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    notificationService = Notifications();
    notificationService.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return Scaffold(
      appBar: PPAppBar(
        title: 'Settings',
        returnToHomePage: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: 422,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(children: [
              Container(
                padding: const EdgeInsets.all(60),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.premiumPageString1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: ppColors.secondaryTextColor)),
                      Text(AppLocalizations.of(context)!.premiumPageString2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ppColors.secondaryTextColor)),
                      Text(AppLocalizations.of(context)!.premiumPageString3,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: ppColors.secondaryTextColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(AppLocalizations.of(context)!.premiumPageString4,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: ppColors.secondaryTextColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(AppLocalizations.of(context)!.premiumPageString5,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: ppColors.secondaryTextColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(AppLocalizations.of(context)!.premiumPageString6,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: ppColors.secondaryTextColor)),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () async {
                            /* hasu vitsi mutta ei ehkä demoon
                            await notificationService.showNotification(
                                id: 0,
                                title: "sike",
                                body: "ei olis kannattanu");
                          */
                          },
                          child: Text(
                            AppLocalizations.of(context)!.premiumPageButton,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          )),
                    ]),
              ),
            ]),
          ),
        ],
      )),
    );
  }
}
