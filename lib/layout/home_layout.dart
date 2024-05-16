import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/widgets/default_form_field.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var dateController = TextEditingController();

  ///methods for database
//1.create database
//2.create tables
//3.open database // get database
//4.insert to database
//5.update
//6.delete from database

  void updateDatabase() {}

  void deleteDatabase() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseSate) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.bottomSheetIsShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultFormFiled(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter a task title";
                                      }
                                    },
                                    prefixIcon: const Icon(Icons.title),
                                    controller: titleController,
                                    inputType: TextInputType.text,
                                    label: const Text("Task Title"),
                                    isSecure: false,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DefaultFormFiled(
                                    onTap: () {
                                      //Time
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter a task time";
                                      }
                                    },
                                    prefixIcon:
                                        const Icon(Icons.watch_later_outlined),
                                    controller: timeController,
                                    inputType: TextInputType.datetime,
                                    label: Text("Task Time"),
                                    isSecure: false,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DefaultFormFiled(
                                    onTap: () {
                                      ///Date
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-12-30'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter a task date";
                                      }
                                      return null;
                                    },
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    controller: dateController,
                                    inputType: TextInputType.datetime,
                                    label: Text("Task date"),
                                    isSecure: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: AppCubit.get(context)
                      .currentIndex, //make color in currentIndex
                  onTap: (index) {
                    cubit.ChangeIndex(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: "Tasks",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: "Done",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: "Archive",
                    ),
                  ]),
              body: state is! AppGetDatabaseLoadingState
                  ? AppCubit().screens[cubit.currentIndex]
                  : const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
