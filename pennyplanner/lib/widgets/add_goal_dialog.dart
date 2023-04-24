import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/theme_provider.dart';
import 'styled_dialog_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGoalDialog {
  static void run(BuildContext context, double percentLeft) {                     // As the filename implies, this is a dialog for editing goals
    final descriptionTextController = TextEditingController();
    final priceTextController = TextEditingController();
    final percentOfSavingsTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              final PPColors ppColors =
                  Theme.of(context).extension<PPColors>()!;
              return StyledDialogPopup(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: ppColors.secondaryTextColor!))),
                    child: Text(AppLocalizations.of(context)!.newGoal,
                        textAlign: TextAlign.left,
                        style: StyledDialogPopup
                            .customDialogTheme.textTheme.displayLarge
                            ?.apply(color: ppColors.secondaryTextColor)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      AppLocalizations.of(context)!.description,
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: descriptionTextController,
                      cursorColor: Colors.black,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      AppLocalizations.of(context)!.price,
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: priceTextController,
                      cursorColor: Colors.black,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.percentOfSavings,
                          style: StyledDialogPopup
                              .customDialogTheme.textTheme.displayMedium
                              ?.apply(color: ppColors.primaryTextColor),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ' ($percentLeft% ${AppLocalizations.of(context)!.left})',
                          style: StyledDialogPopup
                              .customDialogTheme.textTheme.displayMedium
                              ?.copyWith(
                                  color: ppColors.primaryTextColor,
                                  fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: percentOfSavingsTextController,
                      cursorColor: Colors.black,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ppColors.primaryTextColor!),
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (percentLeft -
                                double.parse(percentOfSavingsTextController.text
                                    .trim()) <
                            0) {
                          var snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .savingsExceeded));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref('budgets')
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .child('goals')
                            .push();
                        ref.set({
                          "description": descriptionTextController.text.trim(),
                          "price":
                              double.parse(priceTextController.text.trim()),
                          "percentOfSavings": double.parse(
                              percentOfSavingsTextController.text.trim()),
                          "amountSaved": 0,
                          "date": DateTime.now().toIso8601String()
                        }).then((value) {
                          var snackBar = SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.addedGoal));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        });
                      },
                      style: StyledDialogPopup
                          .customDialogTheme.elevatedButtonTheme.style
                          ?.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.onPrimary)),
                      child: Text(AppLocalizations.of(context)!.create))
                ],
              );
            }));
  }
}
