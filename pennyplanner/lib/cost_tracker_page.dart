import 'package:flutter/material.dart';

import '../widgets/pp_appbar.dart';

class CostTrackerPage extends StatefulWidget {
  const CostTrackerPage({super.key});

  @override
  State<CostTrackerPage> createState() => _CostTrackerPageState();
}

class _CostTrackerPageState extends State<CostTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const PPAppBar(
          title: 'Ayaya',
          returnToMain: false,
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
                            children: [],
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
                            children: [],
                          )),
                    ),
                    Expanded(flex: 7, child: Container()),
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
                              children: [],
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
