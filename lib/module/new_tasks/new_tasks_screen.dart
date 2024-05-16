import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/widgets/task_card.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return (tasks.length != 0)
            ? ListView.separated(
                itemBuilder: ((context, index) => TaskCard(
                      model: tasks[index],
                    )),
                separatorBuilder: ((context, index) => Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    )),
                itemCount: tasks.length)
            : Center(
                child: Text(
                "there is no tasks please add one",
                style: TextStyle(color: Colors.deepPurple[300]),
              ));
      },
    );
  }
}
