import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/theme_provider.dart';
import 'styled_dialog_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditExpenseDialog {
  static void run(
      BuildContext context,
      String title,
      double amount,
      String? dbDueDate,
      String categoryName,
      String expenseId,
      bool reoccurring) {
    bool dueDateCheckBoxValue = false;
    bool repeatEveryMonthCheckBoxValue = false;
    DateTime dueDate =
        DateTime.parse(dbDueDate ?? DateTime.now().toIso8601String());
    reoccurring
        ? repeatEveryMonthCheckBoxValue = true
        : repeatEveryMonthCheckBoxValue = false;

    dbDueDate == null
        ? dueDateCheckBoxValue = false
        : dueDateCheckBoxValue = true;
    final descriptionTextController = TextEditingController();
    descriptionTextController.text = title;
    final amountTextController = TextEditingController();
    amountTextController.text = amount.toString();
    final dueDateTextController = TextEditingController();
    if (dbDueDate != null) {
      dueDateTextController.text =
          DateFormat('dd.MM.yyyy').format(DateTime.parse(dbDueDate)).toString();
    }
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
                        Text(AppLocalizations.of(context)!.editExpense,
                            textAlign: TextAlign.left,
                            style: StyledDialogPopup
                                .customDialogTheme.textTheme.displayLarge
                                ?.apply(color: ppColors.secondaryTextColor)),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            bool deleteConfirm = await showDialog(
                                context: context,
                                builder: (context) {
                                  return StyledDialogPopup(children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .deleteExpenseConfirmation,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ppColors.secondaryTextColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                            onPressed: () {
                                              return Navigator.pop(
                                                  context, true);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 3,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            onPressed: () {
                                              return Navigator.pop(
                                                  context, false);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .no),
                                          )
                                        ],
                                      ),
                                    )
                                  ]);
                                });
                            if (deleteConfirm) {
                              DatabaseReference ref = FirebaseDatabase.instance
                                  .ref('budgets')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('expenseCategories')
                                  .child(categoryName)
                                  .child('expenses')
                                  .child(expenseId);
                              await ref.remove().then((value) {
                                var snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .deletingExpense));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              });
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: ppColors.secondaryTextColor,
                          ),
                        )
                      ],
                    ),
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
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xff0F5B2E)),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xff0F5B2E)),
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
                      AppLocalizations.of(context)!.amount,
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: amountTextController,
                      cursorColor: Colors.black,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xff0F5B2E)),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xff0F5B2E)),
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
                          AppLocalizations.of(context)!.dueDate,
                          style: StyledDialogPopup
                              .customDialogTheme.textTheme.displayMedium
                              ?.apply(color: ppColors.primaryTextColor),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 12,
                          width: 12,
                          child: Checkbox(
                              checkColor: ppColors.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              fillColor: MaterialStateProperty.all(
                                  dueDateCheckBoxValue
                                      ? ppColors.primaryTextColor
                                      : Colors.grey),
                              value: dueDateCheckBoxValue,
                              onChanged: (bool? newValue) {
                                dueDateTextController.text = "";
                                setState(() {
                                  dueDateCheckBoxValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: InkWell(
                      onTap: dueDateCheckBoxValue
                          ? () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now(), //get today's date
                                      firstDate: DateTime(
                                          2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101))
                                  .then((value) {
                                if (value != null) {
                                  dueDateTextController.text =
                                      DateFormat('dd.MM.yyyy')
                                          .format(value)
                                          .toString();

                                  dueDate = value;
                                }
                                return value;
                              });
                            }
                          : () {},
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dueDateTextController,
                          cursorColor: Colors.black,
                          obscureText: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: dueDateCheckBoxValue
                                ? Colors.white
                                : Colors.grey.shade300,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: dueDateCheckBoxValue
                                        ? const Color(0xff0F5B2E)
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(30.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: dueDateCheckBoxValue
                                        ? const Color(0xff0F5B2E)
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
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
                          AppLocalizations.of(context)!.repeatEveryMonth,
                          style: repeatEveryMonthCheckBoxValue
                              ? StyledDialogPopup
                                  .customDialogTheme.textTheme.displayMedium
                                  ?.apply(color: ppColors.primaryTextColor)
                              : const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 12,
                          width: 12,
                          child: Checkbox(
                              checkColor: ppColors.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              fillColor: MaterialStateProperty.all(
                                  repeatEveryMonthCheckBoxValue
                                      ? ppColors.primaryTextColor
                                      : Colors.grey),
                              value: repeatEveryMonthCheckBoxValue,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  repeatEveryMonthCheckBoxValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref('budgets')
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .child('expenseCategories')
                            .child(categoryName)
                            .child('expenses')
                            .child(expenseId);
                        await ref.update({
                          'date': DateTime.now().toIso8601String(),
                          'description': descriptionTextController.text.trim(),
                          'amount':
                              double.parse(amountTextController.text.trim()),
                          'isDue': dueDate,
                          'reoccurring': repeatEveryMonthCheckBoxValue
                        }).then((value) {
                          var snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .updatedExpense));
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
