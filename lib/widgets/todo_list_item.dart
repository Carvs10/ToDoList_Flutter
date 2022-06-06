import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:note_pad/models/todo.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({Key? key, required this.todo, required this.onDelete})
      : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: (ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(todo),
              label: 'Deletar',
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            )
          ])),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200],
        ),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                )),
            Text(
              todo.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void doNothing(BuildContext context) {}
}
