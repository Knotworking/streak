import 'package:flutter/material.dart';
import 'package:streak/ui/StreakOverlay.dart';
import 'package:streak/data/DatabaseHelper.dart';
import 'package:streak/models/Habit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaks',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Streaks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseHelper _dbHelper = DatabaseHelper();

  void addHabit(String name) async {
    Habit newHabit =
        Habit(id: -1, name: name, streak: 0, lastRecordedDate: DateTime.now());
    _dbHelper.saveHabit(newHabit);
    print(await _dbHelper.getHabits());
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      //TODO read: what normally goes in setState()
    });
  }

  void incrementHabit(Habit habit) async {
    _dbHelper.modifyHabitCount(habit, 1);
    setState(() {
      // do something?
    });
    _showOverlay(context);
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(StreakOverlay());
  }

  void clearDb() async {
    int deleted = await _dbHelper.deleteAllHabits();
    SnackBar snackBar =
        SnackBar(content: Text('Deleted ' + deleted.toString() + ' habits'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    setState(() {});
  }

  Widget listWidget() {
    return FutureBuilder<List>(
      future: _dbHelper.getHabits(),
      initialData: [],
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int position) {
                  final habit = snapshot.data[position] as Habit;
                  //get your item data here ...
                  return Card(
                      child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(habit.toString()),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            incrementHabit(habit);
                          })
                    ],
                  ));
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget newHabitDialog() {
    TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text("New Habit"),
      content: TextFormField(
        controller: _controller,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.delete), tooltip: 'Clear DB', onPressed: clearDb)
        ],
      ),
      body: listWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return newHabitDialog();
              }).then((value) {
            addHabit(value);
          });
        },
        tooltip: 'Add Habit',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
