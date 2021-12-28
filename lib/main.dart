import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HttpJson());
  }
}

class HttpJson extends StatefulWidget {
  const HttpJson({Key? key}) : super(key: key);

  @override
  State<HttpJson> createState() => _HttpJsonState();
}

class _HttpJsonState extends State<HttpJson> {
  String result = '';
  List? data;

  @override
  void initState() {
    super.initState();
    data = new List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getJSONData();
          },
          child: Icon(Icons.file_download),
        ),
        body: Container(
            child: Center(
                child: data!.length == 0
                    ? Text('데이터가 없습니다.')
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Image.network(
                                      data![index]['thumbnail'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                      Text(
                                        "${data![index]['title'].toString()}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                          "게시자 : ${data![index]['author'].toString()}"),
                                      Text(
                                          "등록일 : ${data![index]['datetime'].toString()}"),
                                      Text(
                                          "재생시간 : ${data![index]['play_time'].toString()}"),
                                    ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: data!.length,
                      ))),
      ),
    );
  }

  Future<String?> getJSONData() async {
    var url = 'https://dapi.kakao.com/v2/search/vclip?target=title&query=오징어게임';
    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK 24e46bad35177bd68da7f1fbe3b26e6f"});
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data!.addAll(result);
    });
    return "Success!!";
  }
}
