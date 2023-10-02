
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(MyApp());
}

//fatchig the data from the internet
Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/6'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

//http update the date
 Future<Album> UpdatingData(String name) async {
  final response = await http.put(Uri.parse('https://jsonplaceholder.typicode.com/users/6'),
    headers: <String, String>{
     'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'name': name}));
  
  if(response.statusCode ==200){
    return Album.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('Failed to update album');
  }
 }

 //Album-> To convert the json data to obj and display to user
class Album {
  final String username;
  final String name;
  final int id;
  final String email;

   Album( {
     required this.name,
    required this.username,
    required this.id,
     required this.email,
  });

  factory Album.fromJson(Map<String,dynamic> json) {
    return Album(
      name: json['name'],
      username: json['username'],
      id: json['id'],
      email: json['email'],
    );
  }
}
class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller=TextEditingController();
  TextEditingController _controller1=TextEditingController();
  TextEditingController _controller2=TextEditingController();
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title:Text('Update Data'),
        ),
        body: Container(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState==ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data!.name),
                        Text(snapshot.data!.username),
                        Text(snapshot.data!.email),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(hintText: " Enter Name"),
                        ),
                        TextField(
                          controller: _controller1,
                          decoration: InputDecoration(hintText: " user name"),
                        ),
                        TextField(
                          controller: _controller2,
                          decoration: InputDecoration(hintText: "email"),
                        ),
                        ElevatedButton(onPressed: () {
                          setState(() {
                            futureAlbum = UpdatingData(_controller.text);
                            futureAlbum = UpdatingData(_controller1.text);
                            futureAlbum = UpdatingData(_controller2.text);
                          });
                        },
                            child: Text('Update Data'))
                      ],
                    );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }
              // By default, show a loading spinner.
              return  CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}