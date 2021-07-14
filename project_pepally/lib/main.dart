import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

String homeQuote = "Pepally";
const kittySound = "KittyMeow.mp3";

class _SplashScreen extends State<SplashScreen> {
  Future<void> getData() async {
    var docRef =
        FirebaseFirestore.instance.collection('QuoteOfTheDay').doc('0');
    var quoteOfTheDay = (await docRef.get()).data();
    setState(() {
      homeQuote = quoteOfTheDay!['Body'];
      ;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextLiquidFill(
              text: 'Pepally',
              waveColor: Colors.blueAccent,
              boxBackgroundColor: Colors.purpleAccent,
              textStyle: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.normal,
              ),
              boxHeight: (MediaQuery.of(context).size.height),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.purpleAccent,
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
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepOrange,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ills/BackgroundTile.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 332.0,
                  height: 83.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Agne',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(homeQuote),
                      ],
                      isRepeatingAnimation: false,
                      onTap: () {
                        Fluttertoast.cancel();
                        Fluttertoast.showToast(
                          msg: homeQuote,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      audioPlayer.play(kittySound);
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Kitty meows!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    },
                    child: Container(
                        width: 332.0,
                        height: 223.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    AssetImage('ills/SplashCatFinal.png'))))),
              ]),
        ),
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
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepOrange,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ills/BackgroundTile.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 80.0),
                child: Text(
                  'What would like to do?',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
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
                icons: [
                  CupertinoIcons.hand_thumbsup,
                  CupertinoIcons.hand_thumbsdown
                ],
                activeBgColors: [
                  [Colors.blueAccent],
                  [Colors.blueAccent]
                ],
                onToggle: (index) {
                  subStatus = index;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 80.0),
                child: Text(
                  'Select Topics:',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 80.0),
                child: ListTile(
                  leading: Icon(CupertinoIcons.checkmark_seal_fill,
                      color: Colors.redAccent),
                  title: Text(
                    'Quit Smoking',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onTap: () {
                    if (subStatus == 0) {
                      FirebaseMessaging.instance
                          .subscribeToTopic('QuitSmoking');
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Subscribed to Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                    if (subStatus == 1) {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic('QuitSmoking');
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Unsubscribed from Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
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
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Subscribed to Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                    if (subStatus == 1) {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic('StudyExams');
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Unsubscribed from Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 80.0),
                child: ListTile(
                  leading: Icon(CupertinoIcons.heart_slash_fill,
                      color: Colors.pinkAccent),
                  title: Text(
                    'Love Problems',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                    ),
                  ),
                  onTap: () {
                    if (subStatus == 0) {
                      FirebaseMessaging.instance
                          .subscribeToTopic('LoveProblems');
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Subscribed to Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                    if (subStatus == 1) {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic('LoveProblems');
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: "Succesfully Unsubscribed from Topic!",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
