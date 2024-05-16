import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.model});
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: Icon(Icons.archive, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}
