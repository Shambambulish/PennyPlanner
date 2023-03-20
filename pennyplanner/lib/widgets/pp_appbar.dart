import 'package:flutter/material.dart';
import 'package:pennyplanner/cost_tracker_page.dart';

class PPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool returnToMain;
  const PPAppBar({
    this.title = '',
    this.returnToMain = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFE381),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: const BoxDecoration(color: Color(0xffFFE381)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(36),
                color: Colors.transparent,
                child: returnToMain
                    ? InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CostTrackerPage()));
                        },
                        child: Image.asset('assets/pplogo_red.png'),
                      )
                    : Image.asset('assets/pplogo_red.png'),
              ),
              const Spacer(),
              SizedBox(
                  height: 40, child: Image.asset('assets/pplogo_bold_red.png')),
              const Spacer(),
              Material(
                borderRadius: BorderRadius.circular(36),
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () {},
                    iconSize: 30,
                    icon: const Icon(Icons.settings_outlined)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        50,
      );
}
