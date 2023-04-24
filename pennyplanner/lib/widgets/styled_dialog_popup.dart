import 'package:flutter/material.dart';

import '../utils/theme_provider.dart';

/*
custom styled dialog to run other dialogs through to keep themeing the same between dialogs without hardcoding a bunch of styling
*/

class StyledDialogPopup extends StatefulWidget {
  final List<Widget> children;

  static ThemeData customDialogTheme = ThemeData(
    buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    ),
    dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        alignment: Alignment.center,
        elevation: 10),
  );

  const StyledDialogPopup({super.key, required this.children});

  @override
  State<StyledDialogPopup> createState() => _StyledDialogPopupState();
}

class _StyledDialogPopupState extends State<StyledDialogPopup> {
  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return Theme(
        data: StyledDialogPopup.customDialogTheme,
        child: Dialog(
          backgroundColor: ppColors.isDarkMode ? const Color(0xff121212) : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.children,
            ),
          ),
        ));
  }
}
