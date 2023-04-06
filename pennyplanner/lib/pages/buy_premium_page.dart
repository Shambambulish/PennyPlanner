import 'package:flutter/material.dart';

import '../widgets/pp_appbar.dart';
import 'package:pennyplanner/notifications.dart';

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
    return Scaffold(
      appBar: const PPAppBar(
        title: 'Settings',
        returnToHomePage: true,
      ),
      body: Stack(
        children: [
          Container(
            width: 422,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(children: [
              Container(
                padding: const EdgeInsets.all(60),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Moi,",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                          )),
                      Text("Osta premium",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Text("Tämmösiä hienoja ominaisuuksia mm. saat",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      Text("- Ei mainoksia",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await notificationService.showNotification(
                                id: 0,
                                title: "sike",
                                body: "ei olis kannattanu");
                          },
                          child: const Text("Osta heti")),
                    ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
