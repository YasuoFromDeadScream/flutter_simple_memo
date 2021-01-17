import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'dataservice.dart';

class WriteMemoPage extends StatefulWidget {
  WriteMemoPage({Key key, this.title, this.article}) : super(key: key);
  final String title;
  final Article article;

  @override
  _WriteMemoPageState createState() => _WriteMemoPageState(article);
}

class _WriteMemoPageState extends State<WriteMemoPage> with RouteAware {
  _WriteMemoPageState(this._article);
  Article _article;
  bool _isAutoFocus = true;
  String initTitle = "";
  String initBody = "";
  TextEditingController _titleController;
  TextEditingController _bodyController;

  @override
  void didPop() {
    // この画面から別の画面に遷移する (Pop) 場合にコールされます。
  }

  // TextFieldの入力内容が変更された時に呼ばれる
  void _handleTextField() {
    debugPrint(_bodyController.text);
  }

  // ウィジェットの初期化時にリスナーを登録
  @override
  void initState() {
    if(_article != null){
      initTitle = _article.title;
      initBody = _article.body;
    }else{
      initTitle = "no title";
      initBody = "";
    }
    _titleController = TextEditingController(text: initTitle);
    _bodyController = TextEditingController(text: initBody);

    super.initState();
    _titleController.addListener(_handleTextField);
    _bodyController.addListener(_handleTextField);
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton fab = FloatingActionButton(
      backgroundColor: Color(0x401EE5DE),
      onPressed: () async {
        await _saveArticle();
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
      style: TextStyle(fontFamily: "NotoSansCJKJP"),
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
      controller: _bodyController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 10,
      autofocus: _isAutoFocus,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black87),
        hintText: "",
      ),
    );
    //FocusScope.of(context).requestFocus(_focusNode);

    return WillPopScope(
        onWillPop: () {
          // バックキーを押すとここに来る。
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
                await _saveArticle();
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

  void _saveArticle()async{
    var formatter = new DateFormat('yyyy/MM/dd HH:mm');
    var now = formatter.format(DateTime.now()); // DateからString
    var article = Article(
        title: _titleController.text,
        body: _bodyController.text,
        updateDate: now
    );
    if(_article != null){
      article.id = _article.id;
    }
    await insertArticle(article);

  }
}
