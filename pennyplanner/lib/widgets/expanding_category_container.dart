import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/history_page.dart';

class ExpandingCategoryContainer extends StatefulWidget {
  final String categoryName;

  const ExpandingCategoryContainer({required this.categoryName, super.key});

  @override
  _ExpandingCategoryContainerState createState() =>
      _ExpandingCategoryContainerState();
}

class _ExpandingCategoryContainerState
    extends State<ExpandingCategoryContainer> {
  double containerHeight = 50;

  void changeHeight() {
    setState(() {
      containerHeight == 50 ? containerHeight = 200 : containerHeight = 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: InkWell(
        onTap: changeHeight,
        child: AnimatedContainer(
            height: containerHeight,
            width: MediaQuery.of(context).size.width * 0.9,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
            child: Text(
              //categoryName,
              "",
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w100,
                  fontFamily: "Hind Siliguri",
                  color: Color(0xff0F5B2E)),
            )),
      ),
    );
  }
}
