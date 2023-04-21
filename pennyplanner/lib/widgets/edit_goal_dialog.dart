import 'package:flutter/material.dart';

import '../utils/theme.dart';
import 'styled_dialog_popup.dart';

class EditGoalDialog {
  static void run(
      BuildContext context, String title, double amount, double savedAmount) {
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
                        Text('EDIT GOAL',
                            textAlign: TextAlign.left,
                            style: StyledDialogPopup
                                .customDialogTheme.textTheme.displayLarge
                                ?.copyWith(color: ppColors.secondaryTextColor)),
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
                                        'Are you sure you want to delete this goal?',
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
                                            child: const Text('Yes'),
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
                                            child: const Text('No'),
                                          )
                                        ],
                                      ),
                                    )
                                  ]);
                                });
                            if (deleteConfirm) {
                              const snackBar =
                                  SnackBar(content: Text('Deleting goal'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
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
                      'Description',
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      initialValue: title,
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
                      'Price',
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium
                          ?.apply(color: ppColors.primaryTextColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      initialValue: amount.toString(),
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
                          'Amount to save in period',
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      initialValue: savedAmount.toString(),
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
                      onPressed: () {},
                      style: StyledDialogPopup
                          .customDialogTheme.elevatedButtonTheme.style
                          ?.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.onPrimary)),
                      child: const Text('Save'))
                ],
              );
            }));
  }
}
