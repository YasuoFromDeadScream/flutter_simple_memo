import 'package:flutter/material.dart';
import 'package:flutter_app/dataservice.dart';
import 'package:flutter_app/writememo.dart';
import 'header_with_seachbox.dart';
import 'constants.dart';
import 'dataservice.dart';

void main() {
  runApp(MyApp());
}

final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RootRestorationScope(
        restorationId: 'root',
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // 全体適用
            //fontFamily: "NotoSansCJKJP"
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            //primarySwatch: Colors.blue,
            primaryColor: kPrimaryColor,

            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: WriteMemoPage(title: 'Flutter Demo Home Page'),
          //home: MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/second': (context) =>
                WriteMemoPage(title: 'Flutter Demo Home Page'),
          },
          navigatorObservers: [
            _routeObserver, // <= ここ!
          ],
        ));
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

class _MyHomePageState extends State<MyHomePage> with RestorationMixin {
  int _counter = 0;
  final List<String> entries = <String>[
    'A',
    'B',
    'C',
  ];
  List<Article> articles = <Article>[];

  final List<int> colorCodes = <int>[600, 500, 100];
  final RestorableBool isSelectedElevator = RestorableBool(true);
  final RestorableBool isSelectedWasher = RestorableBool(true);
  final RestorableBool isSelectedFireplace = RestorableBool(true);

  @override
  String get restorationId => 'filter_chip_demo';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(isSelectedElevator, 'selected_elevator');
    registerForRestoration(isSelectedWasher, 'selected_washer');
    registerForRestoration(isSelectedFireplace, 'selected_fireplace');
  }

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WriteMemoPage(
                title: "hungin",
                routeObserver: _routeObserver,
              )),
    );
/*    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //initData();
    dogs().then((content) async {
      print(content);
    });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Image.asset("assets/images/logo.png"),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: FutureBuilder(
          future: _getFutureValue(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && snapshot.data == "success") {
              return Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Invoke "debug painting" (press "p" in the console, choose the
                  // "Toggle Debug Paint" action from the Flutter Inspector in Android
                  // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                  // to see the wireframe for each widget.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HeaderWithSearchBox(size: size),
/*                    Wrap(
                      children: [
                        FilterChip(
                          selectedColor: Colors.amber,
                          disabledColor: Colors.black12,
                          label: Text("note"),
                          selected: isSelectedElevator.value,
                          onSelected: (value) {
                            setState(() {
                              isSelectedElevator.value =
                                  !isSelectedElevator.value;
                            });
                          },
                        ),
                        FilterChip(
                          label: Text("下書き"),
                          selected: isSelectedWasher.value,
                          onSelected: (value) {
                            setState(() {
                              isSelectedWasher.value = !isSelectedWasher.value;
                            });
                          },
                        ),
                        FilterChip(
                          label: Text("完成版"),
                          selected: isSelectedFireplace.value,
                          onSelected: (value) {
                            setState(() {
                              isSelectedFireplace.value =
                                  !isSelectedFireplace.value;
                            });
                          },
                        ),
                      ],
                    ),*/
/*            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),*/
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: articles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  child: Column(children: <Widget>[
//                          Text("aaaa"),
                                ListTile(
                                  leading: FlutterLogo(size: 56.0),
                                  title: Text('no title1'),
                                  subtitle: Text('${articles[index].title}'),
                                  trailing: Icon(Icons.more_vert),
                                ),
                              ]));
                            }))
                  ],
                ),
              );
            } else {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 500,
                height: 500,
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // ※無限ループなるからsetStateをうったらあかん
  Future<String> _getFutureValue() async {
    var resultCode = "";
    await getArticles().then((val) {
      articles = val;
      debugPrint("articles:" + articles.toString());
      resultCode = "success";
    });
    return Future.value(resultCode);
  }
}
