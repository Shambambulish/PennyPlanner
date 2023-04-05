import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../widgets/pp_appbar.dart';
import 'history_page.dart';
import 'package:pennyplanner/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const PPAppBar(
          title: 'Home Page',
          returnToHomePage: false,
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
                Container(
                  child: Column(children: [
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
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await notificationService
                                            .showNotification(
                                                id: 0,
                                                title: "title",
                                                body: "body");
                                      },
                                      child: const Text("notifikaatio"))),
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(),
                    ),
                  ]),
                ),
                // 2nd tab
                Container(
                  child: Column(children: [
                    Expanded(flex: 3, child: HistoryPage()),
                  ]),
                ),
                // 3rd tab
                Container(
                  child: Column(
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
                            child: Column(
                              children: const [],
                            )),
                      ),
                      Expanded(flex: 7, child: Container()),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
