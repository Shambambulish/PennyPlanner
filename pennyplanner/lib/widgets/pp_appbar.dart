import 'package:flutter/material.dart';
import '../pages/settings_page.dart';
import '../utils/theme_provider.dart';

class PPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool returnToHomePage;
  final bool showSettingsBtn;
  final bool isPremium;

  const PPAppBar({
    this.title = '',
    this.returnToHomePage = true,
    this.showSettingsBtn = true,
    this.isPremium = false,
    super.key,
  });

/*

custom appbar with toggleable functionality to pop until first route or show a settings button

*/

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(36),
                color: Colors.transparent,
                child: returnToHomePage
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: ppColors.isDarkMode
                            ? Image.asset('assets/pplogo.png')
                            : Image.asset('assets/pplogo_red.png'),
                      )
                    : ppColors.isDarkMode
                        ? Image.asset('assets/pplogo.png')
                        : Image.asset('assets/pplogo_red.png'),
              ),
              const Spacer(),
              SizedBox(
                  height: 40,
                  child: ppColors.isDarkMode
                      ? Image.asset('assets/pplogo_bold_yellow.png')
                      : Image.asset('assets/pplogo_bold_red.png')),
              const Spacer(),
              showSettingsBtn
                  ? Material(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.transparent,
                      child: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                          isPremium: isPremium,
                                        )));
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
