import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/expense_category.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, startDate, endDate});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

//MAP CATEGORIES

class _HistoryPageState extends State<HistoryPage> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    void fetchWithDate() {
      if (kDebugMode) {
        print("fetchwithdate");
      }
      //tietokantakutsu startdaten ja enddaten perusteella
      // asetus resultdataan
    }

    fetchWithDate();

    List resultsData = [
      [
        "Groceries",
        [
          ["moi", 60, "2.4."],
          ["moro", 30, "4.4."],
          ["jou", 20, "5.4."]
        ]
      ],
      [
        "Bills",
        [
          ["hei", 560, "3.4."],
          ["jou", 50, "5.4."]
        ]
      ],
      [
        "Car",
        [
          ["moro", 320, "4.4."]
        ]
      ],
      [
        "Funmoney",
        [
          ["jou", 40, "5.4."],
          ["jou", 20, "6.4."]
        ]
      ]
    ];

    Map<String, double> calcPercentages() {
      Map<String, double> chartMap = {};
      for (int i = 0; i < resultsData.length; i++) {
        double sum = 0;
        for (var c in resultsData[i][1]) {
          sum += c[1];
        }
        chartMap[resultsData[i][0]] = sum;
      }
      return chartMap;
    }

    DateFormat dateFormat =
        DateFormat.yMMMMd(); // how you want it to be formatted

    return SingleChildScrollView(
        child: Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                InkWell(
                  child: Text(
                    dateFormat.format(startDate!),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "Hind Siliguri",
                        color: Color(0xff0F5B2E)),
                  ),
                  onTap: () async {
                    // DateTime d = DateTime.now();

                    startDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101))
                        .then((value) {
                      setState(() {
                        // d = value!;
                      });
                      return value;
                    });
                  },
                ),
                const Text(
                  " - ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Hind Siliguri",
                      color: Color(0xff0F5B2E)),
                ),
                InkWell(
                  onTap: () async {
                    // DateTime d = DateTime.now();

                    endDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101))
                        .then((value) {
                      setState(() {
                        // d = value!;
                      });
                      return value;
                    });
                  },
                  child: Text(
                    dateFormat.format(endDate!),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "Hind Siliguri",
                        color: Color(0xff0F5B2E)),
                  ),
                ),
              ]),
            ),
            Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: PieChart(
                  dataMap: calcPercentages(),
                  animationDuration: const Duration(milliseconds: 800),
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
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 5, 4, 5),
                  child: ExpandableTheme(
                    data: const ExpandableThemeData(hasIcon: false),
                    child: ExpandablePanel(
                      header: Container(
                        child: Text(
                          resultsData[i][0].toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Hind Siliguri",
                              color: Color(0xff0F5B2E)),
                        ),
                      ),
                      collapsed: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 20,
                            child: Text("${resultsData[i][1].length} results")),
                      ),
                      expanded: Column(children: [
                        for (var e in resultsData[i][1])
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1))),
                            child: Row(
                              children: [
                                Text("title"),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(DateFormat('dd.MM.yyyy')
                                        .format(DateTime.now())),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text('AMOUNT'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        /*
                        Row(children: [
                          for (var ex in e)
                            Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ex.toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Hind Siliguri",
                                      color: Color(0xff0F5B2E)),
                                ))
                        ]),*/
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ],
    ));
  }
}
