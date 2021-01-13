import 'package:flutter/material.dart';
import 'package:flutter_app/dataservice.dart';
import 'package:flutter_app/writememo.dart';
import 'package:flutter_svg/svg.dart';
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
            //primarySwatch: Colors.blue,
            primaryColor: kPrimaryColor[600],
            accentColor: Color(0xFF1EE5DE),

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
  String _search = "";
  Future<List<Article>> _listFuture;

  final List<String> entries = <String>[
    'A',
    'B',
    'C',
  ];

  //List<Article> articles = <Article>[];

  final List<int> colorCodes = <int>[600, 500, 100];
  final RestorableBool isSelectedElevator = RestorableBool(true);
  final RestorableBool isSelectedWasher = RestorableBool(true);
  final RestorableBool isSelectedFireplace = RestorableBool(true);

  @override
  String get restorationId => ('filter_chip_demo' + DateTime.now().toString());

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
  }

  @override
  void initState() {
    super.initState();

    // initial load
    _listFuture = getArticles("");
  }

  void refreshList(String str) {
    // reload
    debugPrint("refreshList");
    setState(() {
      _listFuture = getArticles(str);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build called");
    Size size = MediaQuery.of(context).size;
    HeaderWithSearchBox header = HeaderWithSearchBox(
      size: size,
      function: refreshList,
    );
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            header,
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
            FutureBuilder(
                future: _listFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return new Expanded(child:Center(
                      child: new CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    final articles = snapshot.data ?? <Article>[];

                    return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: articles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  child: Column(children: <Widget>[
//                          Text("aaaa"),
                                ListTile(
                                  //                                 leading: FlutterLogo(size: 56.0),
                                  title: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // これで両端に寄せる
                                      children: <Widget>[
                                        Text(
                                          'no title1',
                                        ),
                                        /*Transform(
                                          transform: new Matrix4.identity()
                                            ..scale(0.8),
                                          child: new Chip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            label: new Text(
                                              "Chip",
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFa3bdc4),
                                          ),
                                        ),*/
                                      ]),
                                  subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // これで両端に寄せる
                                      children: <Widget>[
                                        Text('${articles[index].title}'),
                                        Text("更新日：2020/10/10 12:20",
                                            style: TextStyle(fontSize: 10))
                                      ]),
                                  trailing: Icon(Icons.more_vert),
                                )
                              ]));
                            }));
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: SvgPicture.asset(
          "assets/icons/pen.svg",
          width: 24,
          height: 24,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // ※無限ループなるからsetStateをうったらあかん
  Future<String> _getFutureValue(String searchStr) async {
    debugPrint("searchStr:" + searchStr);
    var resultCode = "";
    await getArticles(searchStr).then((val) {
      /*    articles = val;
        debugPrint("articles:" + articles.toString());*/
      resultCode = "success";
    });
    return Future.value(resultCode);
  }
}
