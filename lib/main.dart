import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iot_proj/utils.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
void main(){
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}
 BuildContext context1;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text('Welcome In Project',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.red
    );
  }
}

class AfterSplash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_AfterSplash();

}

class _AfterSplash extends State<AfterSplash> {

  BluetoothConnection connection;

  void toast(String msg){
    showToast(
     msg,
      duration: Duration(milliseconds: 3500),
      position: ToastPosition.bottom,
      backgroundColor: Colors.red.withOpacity(0.8),
      radius: 3.0,
      textStyle: TextStyle(fontSize: 30.0),
    );

  }


  Future<BluetoothConnection>connect() async{
    connection = await BluetoothConnection.toAddress("00:18:E4:40:00:06");
    return connection;
  }
  Widget cardW(String title,IconData icons,int id){

    return  Container(
        width: 150,
        height: 200,
        child:
        InkWell(
          onLongPress: (){
            setState(() {
              utils.devices.removeAt(id);
            });
          },
          onTap: (){

         if(connection==null) {
           toast("please press buetooth icon");
           return;
         }
if(connection.isConnected) {

  String source = "pressed "+id.toString()+"@";
  print(source.length.toString() + ': "' + source + '" (' + source.runes.length.toString() + ')');

  // String (Dart uses UTF-16) to bytes
  var list = new List<int>();
  source.runes.forEach((rune) {
    if (rune >= 0x10000) {
      rune -= 0x10000;
      int firstWord = (rune >> 10) + 0xD800;
      list.add(firstWord >> 8);
      list.add(firstWord & 0xFF);
      int secondWord = (rune & 0x3FF) + 0xDC00;
      list.add(secondWord >> 8);
      list.add(secondWord & 0xFF);
    }
    else {
      list.add(rune >> 8);
      list.add(rune & 0xFF);
    }
  });
  Uint8List bytes = Uint8List.fromList(list);

  connection.output.add(bytes);
}
          },
          child: Container(


            child: Column(
                children: <Widget>[
                  SizedBox(height:40),
                  Icon(icons,size:70,color: Colors.black54,),
                  SizedBox(height:10),
                  Text(title,style: TextStyle( color: Color(0xffC0221C),fontSize: 20,fontWeight: FontWeight.w700),)

                ]
            ),

          ),
        )
    );

  }
  void _startDiscovery() {
    var _streamSubscription = FlutterBluetoothSerial.instance
        .startDiscovery().listen((r) {
      print(r.device.name);
    });
  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final _formKey = GlobalKey<FormState>();


    return new Scaffold(
        appBar: new AppBar(
          title: Text("stats",style: TextStyle(color: Color(0xffC0221C),fontWeight: FontWeight.bold),),
            centerTitle: true,
          actions: <Widget>[
            InkWell(
              onTap: () {
                final _name = TextEditingController();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
//                                  Padding(
//                                    padding: EdgeInsets.all(8.0),
//                                    child: TextFormField(),
//                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(controller: _name,
                                        decoration: InputDecoration(
                                            hintText: 'Enter Device Name'
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text("Save"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          String _icon=null;
                                          setState(() {
                                          List<String>icons=  iconMap.keys.toList();
                                          for(int i=0;i<icons.length;i++)
                                            {
                                              if(_name.text.contains(icons[i]))
                                                _icon=icons[i];
                                              return;
                                            }
                                            IconData icon;
                                            if(_icon==null)
                                              icon=MdiIcons.devices;
                                            else
                                              icon=MdiIcons.fromString(_icon);
                                            utils.devices.add(new device(id: 1,icon: icon,name: _name.text));
                                            _name.text='';
                                          });

                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Icon(Icons.add,color: Color(0xffC0221C)),
            ),
            new Padding(padding: EdgeInsets.all(5),)
          ],
          leading:  InkWell(

              child: Icon(
                Icons.bluetooth,
                color: Color(0xffC0221C),

              ),
              onTap: (){
                toast("please turn on buetooth");
//          _startDiscovery();

// Some simplest connection :F
                try {

                  print('Connected to the device');

                  connect().then((connection) => (){
                    toast("bluetooth connected");
                    connection.input.listen((Uint8List data) {
                      print('Data incoming: ${ascii.decode(data)}');
                      connection.output.add(data); // Sending data

                      if (ascii.decode(data).contains('!')) {
                        connection.finish(); // Closing connection
                        toast("bluetooth disconnected");

                      }
                    }).onDone(() {

                      toast("bluetooth disconnected");
// Find th
                    });
                  }).catchError((){
                    print("please turn on buetooth");
                    toast("please turn on buetooth");
                  });


                }
                catch (exception) {
//            toast("not connected");
                }



              }
          ),
          backgroundColor: Color(0xffF9F9F7),
        ),
        body:OKToast(
       child: Container(
         child: Column(
           children: <Widget>[
             Expanded(
               flex: 6, // 60% of space => (6/(6 + 4))
               child: Container(
                 color: Colors.white10,
                 child:GridView.builder(
                   itemCount: utils.devices.length,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                   itemBuilder: (BuildContext context, int index) {
                     return new Container(
                       child: new GridTile(
                           child: cardW(utils.devices[index].name, utils.devices[index].icon, index) //just for testing, will fill with image later
                       ),
                     );
                   },
                 ) ,
               ),
             ),
             Expanded(
               flex: 4, // 40% of space
               child: Container(
                 color: Color(0xffC0221C),
               ),
             ),
           ],
         ),
       ),
        )


    );


  }

}