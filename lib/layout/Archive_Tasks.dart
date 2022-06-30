// ignore_for_file: file_names
// ignore: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/componants.dart';
import 'package:to_do_app/shared/cubit.dart';
import 'package:to_do_app/shared/states.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archiveTasks;
        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
