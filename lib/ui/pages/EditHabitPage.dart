import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streak/models/Habit.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage({Key key, this.habit}) : super(key: key);

  final Habit habit;

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    TextEditingController _nameController = TextEditingController();
    _nameController.text = widget.habit.name;
    TextEditingController _streakController = TextEditingController();
    _streakController.text = widget.habit.streak.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit: " + widget.habit.name),
        actions: [
          IconButton(
              icon: Icon(Icons.save), tooltip: 'Save', onPressed: () {
          widget.habit.name = _nameController.text;
          widget.habit.streak = int.parse(_streakController.text);
          Navigator.pop(context, widget.habit);
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Habit Name"),
              controller: _nameController,
            ),
            TextField(
              controller: _streakController,
              decoration: InputDecoration(labelText: "Current streak"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
          ],
        ),
      ),
    );
  }
}
