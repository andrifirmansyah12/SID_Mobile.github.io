import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:sid_kenanga_mobile/ui/page/login/PageSignIn.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String username = "";
  @override
  void initState() {
    getSeesion();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Column(
        children: [
          Text("selamat datang, $username"),
          Center(
            child: RaisedButton(
                onPressed: () {
                  logout();
                },
                child: Text("Logout")),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("username");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PageSignIn()));
  }

  Future<void> getSeesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.get("username");
    });
  }
}
