import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  int subStatus = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 80.0),
              child: Text(
                'What would like to do?',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            ToggleSwitch(
              minWidth: 120.0,
              initialLabelIndex: 0,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.blueGrey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['Subscribe', 'Unsubscribe'],
              icons: [CupertinoIcons.hand_thumbsup, CupertinoIcons.hand_thumbsdown],
              activeBgColors: [[Colors.blueAccent],[Colors.blueAccent]],
              onToggle: (index) {
                subStatus = index;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 80.0),
              child: Text(
                'Select Topics:',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 80.0),
              child: ListTile(
                leading:
                    Icon(CupertinoIcons.checkmark_seal_fill, color: Colors.redAccent),
                title: Text(
                  'Quit Smoking',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () {
                  if (subStatus == 0) {
                    FirebaseMessaging.instance.subscribeToTopic('QuitSmoking');
                  }
                  if (subStatus == 1){
                    FirebaseMessaging.instance.unsubscribeFromTopic('QuitSmoking');
                  }
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 80.0),
              child: ListTile(
                leading: Icon(CupertinoIcons.paperclip, color: Colors.green),
                title: Text(
                  'Study Exams',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onTap: () {
                  if (subStatus == 0) {
                    FirebaseMessaging.instance.subscribeToTopic('StudyExams');
                  }
                  if (subStatus == 1){
                    FirebaseMessaging.instance.unsubscribeFromTopic('StudyExams');
                  }
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 80.0),
              child: ListTile(
                leading:
                    Icon(CupertinoIcons.heart_slash_fill, color: Colors.pinkAccent),
                title: Text(
                  'Love Problems',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                  ),
                ),
                onTap: () {
                  if (subStatus == 0) {
                    FirebaseMessaging.instance.subscribeToTopic('LoveProblems');
                  }
                  if (subStatus == 1){
                    FirebaseMessaging.instance.unsubscribeFromTopic('LoveProblems');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
