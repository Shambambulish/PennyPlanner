import 'package:flutter/material.dart';

import '../widgets/pp_appbar.dart';
import 'package:pie_chart/pie_chart.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

//MAP CATEGORIES
Map<String, double> categoryMap = {
  "Groceries": 5,
  "Bills": 3,
  "Car": 2,
  "Funmoney": 2,
};

class _HistoryPageState extends State<HistoryPage> {
  bool init = false;

  List<Widget> categoryElements = [];
  List<List<Widget>> allElements = [];

  var listOpenIndex = -1;
  List<Widget> testElements = [];

  void InitCategoryElements() {
    categoryMap.forEach((key, value) {
      categoryElements.add(Column(children: [
        FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 0.9,
            child: InkWell(
                onTap: () {
                  //
                  setState(() {});
                },
                child: Container(
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      key,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w100,
                          fontFamily: "Hind Siliguri",
                          color: Color(0xff0F5B2E)),
                    ),
                  ),
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
      ]));
    });
  }

  void InitTestElements() {
    init = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      InitCategoryElements();
      InitTestElements();
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          "Jan 1. 2023 - Mar 16. 2023",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w100,
                              fontFamily: "Hind Siliguri",
                              color: Color(0xff0F5B2E)),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: PieChart(
                          dataMap: categoryMap,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: "",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                          // gradientList: ---To add gradient colors---
                          // emptyColorGradient: ---Empty Color gradient---
                        ))
                  ],
                )),
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
          ],
        ),
      ],
    );
  }
}
