import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/theme_provider.dart';
import 'styled_dialog_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditBudgetDialog {
  static void run(BuildContext context, double income) {
    final budgetTextController = TextEditingController();
    budgetTextController.text = income.toString();

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
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.editBudget,
                            textAlign: TextAlign.left,
                            style: StyledDialogPopup
                                .customDialogTheme.textTheme.displayLarge
                                ?.apply(color: ppColors.secondaryTextColor)),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      AppLocalizations.of(context)!.budget,
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: budgetTextController,
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
                        DatabaseReference ref =
                            FirebaseDatabase.instance.ref('budgets');
                        ref
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          "budget":
                              double.parse(budgetTextController.text.trim())
                        }).then((value) {
                          var snackBar = SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.addedCategory));
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
                      child: Text(AppLocalizations.of(context)!.save))
                ],
              );
            }));
  }
}
