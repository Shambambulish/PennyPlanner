import 'package:flutter/material.dart';

class StyledDialogPopup extends StatefulWidget {
  final List<Widget> children;

  static ThemeData customDialogTheme = ThemeData(
    primaryColor: const Color(0xffAF6363),
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
            color: Color(0xff0F5B2E))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          backgroundColor: const Color(0xffAF6363)),
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
    return Theme(
        data: StyledDialogPopup.customDialogTheme,
        child: Dialog(
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
