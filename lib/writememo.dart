import 'package:flutter/material.dart';

import 'constants.dart';
import 'dataservice.dart';

class WriteMemoPage extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;

  WriteMemoPage({Key key, this.title, this.routeObserver}) : super(key: key);
  final String title;

  @override
  _WriteMemoPageState createState() => _WriteMemoPageState();
}

class _WriteMemoPageState extends State<WriteMemoPage> with RouteAware {
  bool _isAutoFocus = true;
  String initTitle = "";
  String initBody = "";
  TextEditingController _titleController;
  TextEditingController _bodyController;

  @override
  void didPop() {
    debugPrint("vintern");
    // この画面から別の画面に遷移する (Pop) 場合にコールされます。
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }


  // TextFieldの入力内容が変更された時に呼ばれる
  void _handleTextField() {
    // なんか処理書く
    debugPrint("pontern");
    debugPrint(_bodyController.text);
  }

  // ウィジェットの初期化時にリスナーを登録
  @override
  void initState() {
    initTitle = "no title";
    initBody = "hunge";
    _titleController = TextEditingController(text: initTitle);
    _bodyController = TextEditingController(text: initBody);

    super.initState();
    _titleController.addListener(_handleTextField);
    _bodyController.addListener(_handleTextField);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_isAutoFocus：" + _isAutoFocus.toString());
    FloatingActionButton fab = FloatingActionButton(
      //backgroundColor: Color.fromARGB(120, 33, 150, 243),
      backgroundColor: Color(0x401EE5DE),
      onPressed: () async {
        var article = Article(
          title: _titleController.text,
          body: _bodyController.text,
        );
        await insertArticle(article);

        debugPrint("保存しました");
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
        Navigator.of(context).popAndPushNamed("/");
      },
      tooltip: 'Increment',
      child: Icon(Icons.save,color: Color(0x66FFFFFF),),
      mini: true,
    );
     TextField tTitle = TextField(
      controller: _titleController,
      decoration: InputDecoration(
        //border: OutlineInputBorder(),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        labelText: "タイトル",
      ),
    );
    TextField tBody = TextField(
      style: TextStyle(fontFamily: "NotoSansCJKJP"),
//      style: TextStyle(fontFamily: "NotoSerifCJKJP",fontWeight: FontWeight.w600),
      controller: _bodyController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 10,
      autofocus: _isAutoFocus,
      decoration: InputDecoration(
        //enabledBorder: InputBorder.none,

        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black87),
        //border: OutlineInputBorder(),
        //labelText: "テキストボックス",
        hintText: "本文",
      ),
    );
    //FocusScope.of(context).requestFocus(_focusNode);

    return WillPopScope(
        onWillPop: () {
          // バックキーを押すとここに来る。
          // popしてあげないと、閉じてくれない。
          // Navigator.of(context).pop();
          if(initTitle != _titleController.text || initBody != _bodyController.text){
            _showMyDialog();
          }else{
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: kToolbarHeight * 0.5,
            iconTheme: IconThemeData(
              color: Colors.black26, //change your color here
            ),
            //title: Text(widget.title,style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white.withOpacity(0.0),
            elevation: 0.0,
          ),
          body: Container(
            padding: EdgeInsets.only(right: 8.0 ,left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                tTitle,
                Divider(height: 8.0,),
                Expanded(child: tBody)
              ],
            ),
          ),
          floatingActionButton: fab,
          //resizeToAvoidBottomInset: false,
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('保存しますか？'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('いいえを選ぶと'),
                Text('変更が破棄されます。'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: kPrimaryColor,
              child: Text('いいえ', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: kPrimaryColor,
              child: Text('はい', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                _isAutoFocus = false;
                //await createData();
                var article = Article(
// 指定しなければ自動インクリメントされる
//                  id: 0,
                  title: _titleController.text,
                  body: _bodyController.text,
                );
                await insertArticle(article);

                debugPrint("保存しました");
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed("/");
              },
            )
          ],
        );
      },
    );
  }
}
