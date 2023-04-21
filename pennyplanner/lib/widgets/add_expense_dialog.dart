import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/signup_page.dart';
import 'styled_dialog_popup.dart';

final descriptionController = TextEditingController();
final amountController = TextEditingController();
final duedateController = TextEditingController();
final repeatEveryController = TextEditingController();

@override
void dispose() {
  // Clean up the controller when the widget is disposed.
  descriptionController.dispose();
  amountController.dispose();
  duedateController.dispose();
}

final userid = FirebaseAuth.instance.currentUser!.uid;

class AddExpenseDialog {
  static void run(BuildContext context) {
    bool dueDateCheckBoxValue = false;
    bool repeatEveryMonthCheckBoxValue = false;

    final dueDateTextController = TextEditingController();
    final descriptionTextController = TextEditingController();
    final amountTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return StyledDialogPopup(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1))),
                    child: Text('ADD EXPENSE',
                        textAlign: TextAlign.left,
                        style: StyledDialogPopup
                            .customDialogTheme.textTheme.displayLarge),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Description',
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: descriptionController,
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
                      'Amount',
                      style: StyledDialogPopup
                          .customDialogTheme.textTheme.displayMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: amountController,
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
                          'Due date',
                          style: dueDateCheckBoxValue
                              ? StyledDialogPopup
                                  .customDialogTheme.textTheme.displayMedium
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
                          'Repeat every month',
                          style: repeatEveryMonthCheckBoxValue
                              ? StyledDialogPopup
                                  .customDialogTheme.textTheme.displayMedium
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
                      onPressed: () async{
                        final expensedata = <String, dynamic>{
                          'title': descriptionController.text.trim(),
                          'amount': amountController.text.trim(),
                          'date': duedateController.text.trim(),
                          'repeating': repeatEveryCheckBoxValue.toString(),
                        };
                        final newPostKey = FirebaseDatabase.instance.ref().child(userid + '/budgetdata/').push().key;
                        firebase.child(userid + '/budgetdata/' + newPostKey!).set(expensedata);
                        Navigator.of(context).pop();
                        descriptionController.clear();
                        amountController.clear();
                        duedateController.clear();
                      },
                      style: StyledDialogPopup
                          .customDialogTheme.elevatedButtonTheme.style,
                      child: const Text('Add'))
                ],
              );
            }));
  }
}
