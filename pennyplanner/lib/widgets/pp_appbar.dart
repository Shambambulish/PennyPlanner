import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/settings_page.dart';

class PPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool returnToHomePage;
  final bool showSettingsBtn;
  const PPAppBar({
    this.title = '',
    this.returnToHomePage = true,
    this.showSettingsBtn = true,
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
                child: returnToHomePage
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Image.asset('assets/pplogo_red.png'),
                      )
                    : Image.asset('assets/pplogo_red.png'),
              ),
              const Spacer(),
              SizedBox(
                  height: 40, child: Image.asset('assets/pplogo_bold_red.png')),
              const Spacer(),
              showSettingsBtn
                  ? Material(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsPage()));
                          },
                          iconSize: 30,
                          icon: const Icon(Icons.settings_outlined)),
                    )
                  : const SizedBox(
                      width: 50,
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
