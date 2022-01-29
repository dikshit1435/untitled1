import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final imgUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "";
  bool  isDone = false;

  @override


  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(imgUrl, "${dir.path}/myimage.jpg",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      isDone = true;
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
        child: downloading
            ? Container(
          height: 120.0,
          width: 200.0,
          child: Card(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Downloading File: $progressString",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
        )
            : !isDone?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Image'),
                TextButton(onPressed: (){ downloadFile();},
                    child:Text('Press Here to Download Image')),
              ],
            ): Text('Download Completed')

      ),
    );
  }
}