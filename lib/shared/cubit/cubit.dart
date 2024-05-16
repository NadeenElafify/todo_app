import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/archive_tasks/archive_tasks_screen.dart';
import 'package:todo_app/module/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/module/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchiveTasksScreen(),
  ];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks",
  ];
  int currentIndex = 0;
  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.database', version: 1,
        //database load when oncreate done (load first)
        onCreate: (database, int version) async {
      // When creating the database, create the table
      print("database is created");
      await database.execute(
          //id integer ,title string, date string ,time string , status string
          'CREATE TABLE Todos (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      print("table is created");
    }, onOpen: (database) {
      print("database is opened");
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    return await database!.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Todos(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value inserted successfuly");
        emit(AppInsertDatabaseSate());

        getDataFromDatabase(database);
      }).catchError((error) {
        print(error.toString());
      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM Todos').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
        print(element['status']);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE Todos SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database!.rawDelete(
      'DELETE FROM Todos WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool bottomSheetIsShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    bottomSheetIsShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
