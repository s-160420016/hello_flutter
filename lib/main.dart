import 'package:flutter/material.dart';
import 'package:hello_flutter/about.dart';
import 'package:hello_flutter/addrecipe.dart';
import 'package:hello_flutter/basket.dart';
import 'package:hello_flutter/login.dart';
import 'package:hello_flutter/my_courses.dart';
import 'package:hello_flutter/popmovie.dart';
import 'package:hello_flutter/popularactor.dart';
import 'package:hello_flutter/popularmovie.dart';
import 'package:hello_flutter/quiz.dart';
import 'package:hello_flutter/search.dart';
import 'package:hello_flutter/history.dart';
import 'package:hello_flutter/studentlist.dart';
import 'package:hello_flutter/top_score.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

List<PopMovie> PMs = [];

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'quiz': (context) => Quiz(),
        'about': (context) => About(),
        'basket': (context) => Basket(),
        'studentlist': (context) => StudentList(),
        'mycourses': (context) => MyCourses(),
        'addrecipe': (context) => AddRecipe(),
        'popmovie': (context) => PopularMovie(),
        'popactor': (context) => PopularActor()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _user_id = "";

  int _counter = 0;
  Runes emoji = Runes("\u{1F603}");

  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Search(), History()];

  final List<String> _titles = ['Home', 'Screen', 'History'];

  String _top_user = "";
  int _top_point = 0;

  Future<void> getTopScore() async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();

    _top_user = prefs.getString("top_user") ?? "";
    _top_point = prefs.getInt("top_point") ?? 0;
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("xyz"),
            accountEmail: Text(_user_id),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: new Text("Inbox"),
                    leading: new Icon(Icons.inbox),
                  ),
                  ListTile(
                    title: new Text("My Basket"),
                    leading: new Icon(Icons.shopping_basket),
                    onTap: () {
                      Navigator.pushNamed(context, "basket");
                    },
                  ),
                  ListTile(
                    title: new Text("Student List"),
                    leading: new Icon(Icons.list),
                    onTap: () {
                      Navigator.pushNamed(context, "studentlist");
                    },
                  ),
                  ListTile(
                    title: new Text("My Courses"),
                    leading: new Icon(Icons.list),
                    onTap: () {
                      Navigator.pushNamed(context, "mycourses");
                    },
                  ),
                  ListTile(
                    title: new Text("Add Recipe"),
                    leading: new Icon(Icons.add),
                    onTap: () {
                      Navigator.pushNamed(context, "addrecipe");
                    },
                  ),
                  ListTile(
                    title: new Text("Quiz"),
                    leading: new Icon(Icons.quiz),
                    onTap: () {
                      Navigator.pushNamed(context, "quiz");
                    },
                  ),
                  ListTile(
                    title: Text("Top Score"),
                    leading: Icon(Icons.leaderboard),
                    onTap: () {
                      getTopScore();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TopScore(_top_user, _top_point)));
                    },
                  ),
                  ListTile(
                    title: Text("Popular Movie"),
                    leading: Icon(Icons.movie),
                    onTap: () {
                      Navigator.pushNamed(context, "popmovie");
                    },
                  ),
                  ListTile(
                    title: Text("Popular Actor"),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.pushNamed(context, "popactor");
                    },
                  ),
                  ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.help),
                    onTap: () {
                      Navigator.pushNamed(context, "about");
                    },
                  ),
                  ListTile(
                    title: Text("Log Out"),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      doLogout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;

      emoji = Runes("\u{1F603}");

      if (_counter % 5 == 0) {
        emoji = Runes("\u{1F620}");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      checkUser().then((value) => () {
            _user_id = value;
          });
    });
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
      drawer: myDrawer(),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(onPressed: () {}, child: Icon(Icons.skip_previous)),
        ElevatedButton(onPressed: () {}, child: Icon(Icons.skip_next))
      ],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.teal,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "History", icon: Icon(Icons.history))
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
