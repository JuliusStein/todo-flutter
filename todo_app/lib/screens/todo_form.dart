import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../state/todo_model.dart';

// Create a Form screen widget. This widget is the root of your application.
class TodoEntryScreen extends StatelessWidget {
  const TodoEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create todo"),
        ),
        body: TodoForm());
  }
}

// Create a Form widget. This is a stateful widget with which users interact.
class TodoForm extends StatefulWidget {
  @override
  TodoFormState createState() {
    return TodoFormState();
  }
}

// Create a class for screen arguments
class ScreenArguments {
  final int todoId;

  ScreenArguments(this.todoId);
}

// Create a corresponding State class. This class holds data related to the form.
class TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isEditForm = false;
  var editableTodo;

  @override
  // Build the form and add a listener to the text field
  Widget build(BuildContext context) {
    loadTodoForEdit(context);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: Form(
                key: _formKey,
                child: Consumer<TodoModel>(
                  builder: (context, todoModel, child) =>
                      Column(children: <Widget>[
                    TextFormField(
                      controller: titleController,
                    ),
                    TextFormField(
                      controller: descriptionController,
                    ),
                    ElevatedButton(
                      child: Text(isEditForm ? "Update" : "Save"),
                      onPressed: () => {
                        isEditForm
                            ? editTodo(todoModel.update)
                            : createTodo(todoModel.add)
                      },
                    ), // Checks if the form is in edit mode in order to
                    //conditionally render the delete button
                    isEditForm
                        ? ElevatedButton(
                            child: Text("Delete"),
                            onPressed: () => deleteTodo(todoModel.delete),
                          )
                        : new Container()
                  ]), // Widget[]
                ) // Consumer
                ) // Form
            ) //  Scaffold
        ); // MaterialApp
  }

  void loadTodoForEdit(BuildContext context) {
    final ScreenArguments? arguments =
        ModalRoute.of(context)?.settings.arguments as ScreenArguments?;
    if (arguments != null && arguments.todoId != null) {
      isEditForm = true;

      editableTodo = TodoModel().read(arguments.todoId);
      titleController.text = editableTodo.title;
      descriptionController.text = editableTodo.description;
    }
  }

  // Pass in the addTodo function from the parent widget since
  // we can't access the parent's state directly
  void createTodo(addTodo) {
    var todo = Todo(
      id: 0,
      title: titleController.text,
      description: descriptionController.text,
    );
    addTodo(todo);
    Navigator.pop(context);
  }

  void editTodo(Function editTodo) {
    editTodo(editableTodo.id, titleController.text, descriptionController.text);
    Navigator.pop(context);
  }

  void deleteTodo(Function deleteTodo) {
    deleteTodo(editableTodo.id);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
