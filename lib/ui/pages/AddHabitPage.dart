import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streak/HabitUtils.dart';
import 'package:streak/models/Habit.dart';
import 'package:streak/models/TargetPeriod.dart';

class AddHabitPage extends StatefulWidget {

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  int _selectedPeriodIndex = 0;
  List<String> _periodOptions = EnumToString.toList(TargetPeriod.values);
  bool _everyOther = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _targetController = TextEditingController();

  Widget _buildPeriodChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _periodOptions.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedPeriodIndex == i,
        label: Text(_periodOptions[i], style: TextStyle(color: Colors.white)),
        elevation: 1,
        pressElevation: 0,
        backgroundColor: Colors.black54,
        selectedColor: Colors.blue,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedPeriodIndex = i;
            }
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      appBar: AppBar(
        title: Text("New Habit"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () {

                TargetPeriod targetPeriod = EnumToString.fromString(TargetPeriod.values,
                    _periodOptions[_selectedPeriodIndex]);
                //TODO validate
                //TODO calculate period end using every-other or every X
                Habit habit = Habit(
                    id: -1,
                    name: _nameController.text,
                    target: int.parse(_targetController.text),
                    targetPeriod: targetPeriod,
                    periodCount: 0,
                    streak: 0,
                    periodEnd: HabitUtils.calculatePeriodEnd(DateTime.now(), targetPeriod));
                Navigator.pop(context, habit);
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
              controller: _targetController,
              decoration: InputDecoration(labelText: "Target"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
            CheckboxListTile(
              title: Text("Every other"),
              value: _everyOther,
              onChanged: (newValue) {
                setState(() {
                  _everyOther = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            SizedBox(height: 50, child: _buildPeriodChips())
          ],
        ),
      ),
    );
  }
}
