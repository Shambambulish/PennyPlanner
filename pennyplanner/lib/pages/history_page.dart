import 'package:flutter/material.dart';

import '../widgets/pp_appbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool init = false;

  List<Widget> categoryElements = [];
  List<Widget> expenseElements = [];
  List<List<Widget>> allElements = [];

  FractionallySizedBox testElement = FractionallySizedBox(
    widthFactor: 1,
    child: Container(
      height: 60,
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
      child: Text("moi"),
    ),
  );

  var listOpenIndex = -1;
  List<Widget> testElements = [];

  void InitCategoryElements() {
    print("run only once");
    for (var i = 0; i < 2; i++) {
      categoryElements.add(Column(children: [
        FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 0.9,
            child: InkWell(
                onTap: () {
                  //
                  setState(() {
                    GetElements(0);
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 5))
                    ],
                  ),
                ))),
        Column(children: [
          for (var e in expenseElements) ...[
            SizedBox(
              height: 20,
            ),
            Container(child: e),
          ],
        ])
      ]));
    }
  }

  void InitTestElements() {
    testElements.add(testElement);
    testElements.add(testElement);
    testElements.add(testElement);
    allElements.add(testElements);
    init = true;
  }

  void GetElements(int index) {
    expenseElements = allElements[index];
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      InitCategoryElements();
      InitTestElements();
    }

    return Stack(
      children: [
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
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text("Jan 1. 2023 - Mar 16. 2023",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: "Hind Siliguri",
                                  color: Color(0xff0F5B2E))))
                    ],
                  )),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 7,
              child: Column(children: [
                for (var e in categoryElements) ...[
                  SizedBox(
                    height: 20,
                  ),
                  Container(child: e),
                ],
              ]),
            ),
          ]),
        ),
      ],
    );
  }
}
