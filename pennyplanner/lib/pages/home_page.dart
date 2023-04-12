
import 'package:flutter/material.dart';
import 'package:pennyplanner/widgets/manage_expenses.dart';
import 'package:pennyplanner/widgets/manage_goals.dart';

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
                  child: const ManageExpenses(),
                ),
                // 2nd tab
                Container(
                  child: Column(children: [
                    Expanded(flex: 3, child: HistoryPage()),
                  ]),
                ),
                // 3rd tab
                 Container(
                  child: Column(children: [
                    Expanded(flex: 3, child: ManageGoals()),
                  ]),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
