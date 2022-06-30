import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/layout/Archive_Tasks.dart';
import 'package:to_do_app/layout/Done_Tasks.dart';
import 'package:to_do_app/layout/New_Tasks.dart';
import 'package:to_do_app/shared/states.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex =0;
  List<Widget> screen = [
    NewTasks(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('db created');
      database
          .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT  )')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database)
    {
      getDataFromDatabase(database);
      print('db opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction(
          (txn) => txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }),
    );
  }

  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then(
          (value) {

        value.forEach((element)
        {
          if(element['status']=='new')
            newTasks.add(element);
          else if(element['status']=='done')
            doneTasks.add(element);
          else  archiveTasks.add(element);
        });
        emit(AppGetDatabaseState());
      },
    );
  }

  void updateData({
    required String status,
    required int id,
  }) async{
    database.rawUpdate(
      'UPDATE tasks SET status=? WHERE id=?',
      ['$status',id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState ());

    });
  }

  void deleteData({
    required int id,
  }) async{
    database.rawDelete(
      'DELETE FROM tasks  WHERE id=?', [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState ());

    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeSheetState());
  }
}



