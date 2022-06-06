import 'package:flutter/material.dart';
import 'package:note_pad/models/todo.dart';
import 'package:note_pad/repositories/todo_repo.dart';
import 'package:note_pad/widgets/todo_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController notesController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> notes = [];
  late int countNotes;
  var now = DateTime.now();
  int? deletedPos;
  Todo? deletedTodo;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    countNotes = notes.length;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                            errorText: errorText,
                            labelText: 'Adicionar Nova Tarefa',
                            labelStyle:
                                const TextStyle(color: Color(0xff00d7f3)),
                            border: const OutlineInputBorder(),
                            hintText: 'Ex. Comprar Frutas',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xff00d7f3)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              String text = notesController.text;

                              if (text.isEmpty) {
                                setState(() {
                                  errorText = 'O título não pode ser vazio';
                                });

                                return;
                              }

                              setState(() {
                                Todo newTodo =
                                    Todo(title: text, dateTime: DateTime.now());
                                notes.add(newTodo);
                                errorText = null;
                              });
                              notesController.clear();
                              todoRepository.saveTodoList(notes);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xff00d7f3),
                                padding: const EdgeInsets.all(14)))),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo note in notes)
                        ToDoListItem(
                          todo: note,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child:
                            Text('Você possui $countNotes Tarefas pendentes.')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          deleteConfirm();
                        },
                        child: const Text('Limpar Tudo'),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(14)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedPos = notes.indexOf(todo);
    deletedTodo = todo;

    setState(() {
      notes.remove(todo);
    });
    todoRepository.saveTodoList(notes);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${todo.title} deletada com sucesso!',
          style: const TextStyle(
            color: Color(0xff060708),
          )),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          textColor: const Color(0xff00d7f3),
          label: 'Desafazer',
          onPressed: () {
            setState(() {
              notes.insert(deletedPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(notes);
          }),
      backgroundColor: Colors.white,
    ));
  }

  void deleteConfirm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deletar Tudo!'),
              content:
                  const Text('Tem certeza que deseja deletar todas as notas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(primary: const Color(0xff00d7f3)),
                  child: const Text(
                    'Cancelar',
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteAll();
                    },
                    style: TextButton.styleFrom(primary: Colors.red),
                    child: const Text(
                      'Deletar',
                    ))
              ],
            ));
  }

  void deleteAll() {
    setState(() {
      notes.clear();
    });
    todoRepository.saveTodoList(notes);
  }
}
