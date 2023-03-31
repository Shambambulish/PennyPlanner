import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

//MAP CATEGORIES

class _HistoryPageState extends State<HistoryPage> {
  bool init = false;

  var listOpenIndex = -1;
  List<Widget> testElements = [];

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryMap = {
      "Groceries": 5,
      "Bills": 3,
      "Car": 2,
      "Funmoney": 2,
    };

    List resultsData = [
      [
        "Groceries",
        [
          ["moi", "100€", "2.4."],
          ["moro", "100€", "4.4."],
          ["jou", "100€", "5.4."]
        ]
      ],
      [
        "Bills",
        [
          ["hei", "100€", "3.4."],
          ["jou", "100€", "5.4."]
        ]
      ],
      [
        "Car",
        [
          ["moro", "100€", "4.4."]
        ]
      ],
      [
        "Funmoney",
        [
          ["jou", "100€", "5.4."],
          ["jou", "100€", "6.4."]
        ]
      ]
    ];

    return Stack(children: [
      Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                child: const Text(
                  "Jan 1. 2023 - Mar 16. 2023",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w100,
                      fontFamily: "Hind Siliguri",
                      color: Color(0xff0F5B2E)),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 50),
                  child: PieChart(
                    dataMap: categoryMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    // gradientList: ---To add gradient colors---
                    // emptyColorGradient: ---Empty Color gradient---
                  )),
              for (int i = 0; i < resultsData.length; i++) ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                  child: ExpandableTheme(
                    data: const ExpandableThemeData(hasIcon: false),
                    child: ExpandablePanel(
                      header: Expanded(
                        flex: 5,
                        child: Container(
                          //decoration:
                          //BoxDecoration(border: Border.all(width: 1)),
                          child: Column(
                            children: [
                              Text(
                                resultsData[i][0].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: "Hind Siliguri",
                                    color: Color(0xff0F5B2E)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      collapsed: SizedBox(
                          height: 20,
                          child: Text(resultsData[i][1].length.toString() +
                              " results")),
                      expanded: Column(children: [
                        for (var e in resultsData[i][1])
                          Row(children: [
                            for (var ex in e)
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    ex.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        fontFamily: "Hind Siliguri",
                                        color: Color(0xff0F5B2E)),
                                  ))
                          ]),
                      ]),
                    ),
                  ),
                )
              ],
            ],
          ),
        ],
      )
    ]);
  }
}
