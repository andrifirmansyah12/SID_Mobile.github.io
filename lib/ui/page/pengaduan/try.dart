import 'package:flutter/material.dart';
import 'model.dart';

class PageStatusPengaduan extends StatefulWidget {
  @override
  _PageStatusPengaduanState createState() => _PageStatusPengaduanState();
}

class _PageStatusPengaduanState extends State<PageStatusPengaduan> {
  String output = "no data";
  Pengaduan pengaduan = null;

  // @override
  // void initState() {
  //   Pengaduan.getPengaduan("123").then((pengaduan) {
  //     output = "";
  //     for (int i; i < pengaduan.length; i++)
  //       output = output + "[ " + pengaduan[i].nama + " ] ";
  //     setState(() {});
  //   });
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(output),
            RaisedButton(
              onPressed: () {
                Pengaduan.getPengaduan("123").then((pengaduan) {
                  output = "";
                  for (int i; i < pengaduan.length; i++)
                    output = output + "[ " + pengaduan[i].nama + " ] ";
                  setState(() {});
                });
              },
              child: Text("Get"),
            )
          ],
        ),
      ),
    );
  }
}
