//Home Page
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'models.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<univeristyModel> universityList = [];
  bool loading = false;

  getData() async {
    setState(() {
      loading = true;
    });
    final responce = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=pakistan'));
    log(responce.statusCode.toString());
    if (responce.statusCode == 200) {
      List data = jsonDecode(responce.body).toList();

      for (int i = 0; i < data.length; i++) {
        univeristyModel uniModel = univeristyModel(
          countryName: data[i]['country'].toString(),
          countryCode: data[i]['alpha_two_code'].toString(),
          provinceName: data[i]['state-province'].toString(),
          universityName: data[i]['name'].toString(),
        );
        universityList.add(uniModel);
      }
      setState(() {
        loading = false;
      });
    }
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var token = pref.getString('token');
      print("Token: $token");
      final responce = await http.post(
        Uri.parse('http://adeegmarket.zamindarestate.com/api/v1/logout'),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token"
        },
      );

      print(responce.statusCode);
      print("Body: ${responce.body}");

      pref.setString('token', "null");
      Navigator.of(context).pushAndRemoveUntil(
          (MaterialPageRoute(builder: (context) => const Login())),
          (route) => false);
    } catch (e) {
      print("Catch Error.........");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: const Text('Get Data'),
              ),
              TextField(
                controller: controller,
                onChanged: (e) {
                  setState(() {
                    
                  
                  filterList = universityList
                      .where((universityModel element) => element.provinceName
                          .toString()
                          .toUpperCase()
                          .contains(controller.text.toString().toLowerCase())
                          || 
                          element.universityName.toString().toUpperCase().contains(controller.text.toString().toLowerCase())
                          
                          )
                      .toList();
                },
});
              ),
              loading == true
                  ? const Text("Loading...")
                  : 
                  filterList.length >0
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: universityList.length,
                      itemBuilder: (context, i) {
                        return Text(universityList[i].provinceName.toString());
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logout();
          // getData();
        },
        tooltip: 'Increment',
        label: const Text("Logout"),
      ),
    );
  }
}
