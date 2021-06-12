import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sid_kenanga_mobile/model/user_model.dart';
import 'package:sid_kenanga_mobile/ui/page/dashboard/PageDashboard.dart';
import 'package:sid_kenanga_mobile/ui/page/surat/PageStatusPermintaanSurat.dart';

class PageSurat extends StatefulWidget {
  @override
  _PageSuratState createState() => _PageSuratState();
}

class _PageSuratState extends State<PageSurat> {
  TextEditingController _namaPendudukController = TextEditingController();
  TextEditingController _namaSuratController = TextEditingController();
  String nik = "";
  String nama = "";
  User user = null;

  // combo box surat
  NamaSurat pilihSurat;
  List<NamaSurat> surats = [
    NamaSurat("Surat Keterangan Usaha"),
    NamaSurat("Surat Keterangan Domisili")
  ];
  List<DropdownMenuItem> generateItems(List<NamaSurat> persons) {
    List<DropdownMenuItem> items = [];
    for (var item in surats) {
      items.add(DropdownMenuItem(
        child: Text(item.nama),
        value: item,
      ));
    }
    return items;
  }

  Future savePengaduan() async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/permintaan_surat"), body: {
      "nik": user.nik,
      "nama_penduduk": user.name,
      "nama_surat": _namaSuratController.text,
      "status": "Terkirim",
    });
    return json.decode(response.body);
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nik = pref.get("nik");
      User.connectToAPI(nik).then((value) {
        user = value;
        setState(() {});
      });
    });
  }

  Future pushNotifikasiSurat() async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/notifikasi"), body: {
      "nik": user.nik,
      "nama": user.name,
      "aksi": "Mengirim Permintaan Pembuatan Surat",
      "status": "Terkirim"
    });
    return json.decode(response.body);
  }

  @override
  void initState() {
    getSession();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF4511E),
          // title: Text('Login Screen App'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Permintaan Pembuatan Surat',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: <Widget>[
                      Text("Pilih Surat"),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                        value: pilihSurat,
                        items: generateItems(surats),
                        onChanged: (item) {
                          setState(() {
                            pilihSurat = item;
                            _namaSuratController.text = pilihSurat.nama;
                          });
                        },
                      ),
                      // Text((pilihSurat != null) ? pilihSurat.nama : "Pilih")
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Color(0xFFF4511E),
                  // child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xFFF4511E),
                      child: Text('Kirim'),
                      onPressed: () {
                        // print(_namaController.text);
                        pushNotifikasiSurat();
                        savePengaduan().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageDashboard())));
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Info"),
                          content: Text("Permintaan Surat Berhasil Terkirim"),
                          actions: [
                            FlatButton(
                                child: Text(""),
                                onPressed: () => Navigator.of(context).pop()),
                          ],
                        );
                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Cek Status Permintaan Surat'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PageStatusPermintaanSurat()));
                      },
                    ))
              ],
            )));
  }
}

class NamaSurat {
  String nama;
  NamaSurat(this.nama);
}
