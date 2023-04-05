import 'package:flutter/material.dart';
import 'package:pennyplanner/widgets/manage_expenses.dart';

import '../widgets/pp_appbar.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                          child: Column(
                            children: const [],
                          )),
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
}
