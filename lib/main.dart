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
          title: 'Simple Memo',
          theme: ThemeData(
            // 全体適用
            //fontFamily: "NotoSansCJKJP"
            // This is the theme of your application.
            //primarySwatch: Colors.blue,
            primaryColor: kPrimaryColor[600],
            accentColor: Color(0xFF1EE5DE),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => MyHomePage(title: 'Simple Memo'),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/second': (context) =>
                WriteMemoPage(title: 'Simple Memo'),
          },
          navigatorObservers: [
            _routeObserver, // <= ここ!
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RestorationMixin {
  Future<List<Article>> _listFuture;

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

  void _writeArticle() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WriteMemoPage(
              )),
    );
  }

  void _editArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WriteMemoPage(
                article: article,
              )),
    );
  }

  @override
  void initState() {
    super.initState();

    // initial load
    _listFuture = getArticles("");
  }

  String currentSearch = "";
  void refreshList(String str) {
    // reload
    currentSearch = str;
    debugPrint("refreshList");
    setState(() {
      _listFuture = getArticles(str);
    });
  }

  void refreshListWithCurrentSearch() {
    // reload
    debugPrint("refreshList");
    setState(() {
      _listFuture = getArticles(currentSearch);
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
            icon: Image.asset("assets/icons/icon.png"),
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
            FutureBuilder(
                future: _listFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return new Expanded(
                        child: Center(
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
                                  child: InkWell(
                                      onTap: () {
                                        debugPrint("tap : " +
                                            '${articles[index].title}');
                                        _editArticle(articles[index]);
                                      },
                                      child: Column(children: <Widget>[
                                        ListTile(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween, // これで両端に寄せる
                                            children: <Widget>[
                                              Text(
                                                '${articles[index].title}',
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween, // これで両端に寄せる
                                              children: <Widget>[
                                                Text(formatStr('${articles[index].body}')),
                                                Text(
                                                    "更新日：${articles[index].updateDate}",
                                                    style:
                                                        TextStyle(fontSize: 10))
                                              ]),
                                          trailing: IconButton(
                                            icon: new Icon(Icons.delete),
                                            onPressed: () {
                                              _confirmDeleteDialog(articles[index].id);
                                            },
                                          ),
                                        )
                                      ])));
                            }));
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _writeArticle,
        tooltip: 'Increment',
        child: SvgPicture.asset(
          "assets/icons/pen.svg",
          width: 24,
          height: 24,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String formatStr(String str){
    if(str.indexOf("\n") >= 0){
      str = str.substring(0,str.indexOf("\n"));
      if(str.length >= 8){
        return str.substring(0,7) + "...";
      }else{
        return str + "...";
      }
    }
    if(str.length >= 8){
      return str.substring(0,7) + "...";
    }else{
      return str;
    }
  }

  Future<void> _confirmDeleteDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        debugPrint("id:"+id.toString());
        return AlertDialog(
          title: Text('削除しますか？'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('はいを選ぶと'),
                Text('メモが完全に破棄されます。'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: kPrimaryColor,
              child: Text('いいえ', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: kPrimaryColor,
              child: Text('はい', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop();
                deleteArticle(id);
                refreshListWithCurrentSearch();
              },
            )
          ],
        );
      },
    );
  }
}
