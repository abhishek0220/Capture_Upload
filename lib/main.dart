import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String phpEndPoint = 'http://192.168.1.100:5000/Generate';
  File file;
  void _choose() async{
    file = await ImagePicker.pickImage(source: ImageSource.camera);
  }
  void _upload() {
    if(file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    print(base64Image);
    String fileName = file.path.split("/").last;
    print(base64Image.length);
    http.post(phpEndPoint, body:{
      "image":base64Image,
      "name":fileName,
    }).then((res) {
      print(res.statusCode);
      if(res.statusCode == 200){
        String qrdata = res.body;
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => 
            new ShowQR(qrdata),
        );
        Navigator.of(context).push(route);
      }
    }).catchError((err) {
      print(err);
    });
    print('done');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
