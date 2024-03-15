import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Detail.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:varnaboomweb/ProfileUser/Edit/Movie/ShowMovie.dart';

//TODO: if profile Null bod
//TODO: Icon Instagram
//TODO: if Icon HA nall Box

class RetryProfile extends StatefulWidget {
  RetryProfile({Key? key, required this.id, required this.name})
      : super(key: key);

  final int id;
  final String name;

  @override
  _RetryProfileState createState() => _RetryProfileState();
}

class _RetryProfileState extends State<RetryProfile> {
  late List<String> shopImage;
  late Map<String, dynamic> infoUser;
  late List answerUser;
  List<Widget> option = [];

  late Timer _timer;
  int _currentPage = 0;
  PageController pageviewcontroller = PageController();

  Future<bool> GetShopImage(id) async {
    http.Response result = await http.get(
      Uri.parse('$host/api/ImageShop/$id/'),
    );

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    a.forEach((element) {
      shopImage.add(element['imag']);
    });

    if (result.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> GetInfoUser(id) async {
    http.Response result = await http.get(
      Uri.parse('$host/api/InfoUser/$id/'),
    );

    print('ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
    print(result.body);
    print('ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    if (a.length > 0) infoUser = a[0];

    if (result.statusCode == 200) {
      if (a[0]['lat'] != null) {
        option.add(
          IconButton(
              icon: Icon(
                Icons.location_on,
                size: 4.20.h,
                color: Colors.redAccent,
              ),
              onPressed: () async => {
                    print(
                        "geo:https://www.google.com/maps/@${a[0]['lat']},${a[0]['lng']}"),
                    await launch("geo:${a[0]['lat']},${a[0]['lng']}")
                  }),
        );
      }

      if (a[0]['number'] != null) {
        option.add(
          IconButton(
            icon: Icon(
              Icons.phone,
              size: 4.20.h,
              color: Colors.greenAccent,
            ),
            onPressed: () async => {await launch("tel:+98${a[0]['number']}")},
          ),
        );
      }

      if (a[0]['video'] != null) {
        option.add(
          IconButton(
            icon: Icon(
              Icons.movie,
              size: 4.20.h,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SampleVideoRetryProfile(
                      url: infoUser['video'],
                    );
                  });
            },
          ),
        );
      }

      if (a[0]['instagram'] != null && a[0]['instagram'] != '') {
        option.add(IconButton(
            icon: LineIcon.instagram(
              size: 4.20.h,
              color: Colors.pinkAccent,
            ),
            onPressed: () async {
              print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
              print(a[0]['instagram']);
              print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');

              await launch("https://www.instagram.com/${a[0]['instagram']}/");
            }));
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> GetAnswerQuestion(id) async {
    http.Response result = await http.get(
      Uri.parse('$host/api/AnswerUser/$id/'),
    );

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    answerUser = a;

    if (result.statusCode == 200) {
      return true;
    } else {
      print('fffffffffffffffffffffffffffffffffffffffffff');
      return false;
    }
  }

  Future<bool> ready() async {
    final a = await GetInfoUser(widget.id);
    final b = await GetShopImage(widget.id);
    final c = await GetAnswerQuestion(widget.id);

    if (a == true && b == true && c == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    shopImage = [];
    infoUser = {};
    answerUser = [];
    // GetInfoUser(widget.id);
    // GetShopImage(widget.id);
    // GetAnswerQuestion(widget.id);

    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageviewcontroller.hasClients) {
        if (_currentPage < shopImage.length) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        pageviewcontroller.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 700),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: TextStyle(
                fontSize: 18, fontFamily: Myfont, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF149694),
        ),
        body: FutureBuilder(
            future: ready(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5.h),
                            width: double.infinity,
                            child: Container(
                              height: 25.h,
                              child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Color(0xffeeeeee),
                                  child: PageView(
                                    controller: pageviewcontroller,
                                    children: [
                                      for (var i in shopImage)
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                              size: 30.sp,
                                                            )),
                                                        Image(
                                                            image: NetworkImage(
                                                                i)),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(i)),
                                        )
                                    ],
                                  )),
                            ),
                          ),
                          CircleAvatar(
                            radius: 5.h,
                            backgroundImage: NetworkImage(infoUser['profile']),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: option,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10, top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'آدرس',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontFamily: Myfont,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    infoUser['address'],
                                    style: TextStyle(fontFamily: Myfont),
                                  ),
                                ),
                                SizedBox(height: 20),
                                for (var i in answerUser)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        i['questions'],
                                        style: TextStyle(
                                            fontFamily: Myfont,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(i['answer'],
                                            style: TextStyle(
                                              fontFamily: Myfont,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      SizedBox(height: 20)
                                    ],
                                  ),
                                if (infoUser['bio'] != '')
                                  Text(
                                    'درباره ما',
                                    style: TextStyle(
                                        fontFamily: Myfont,
                                        fontWeight: FontWeight.bold),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    infoUser['bio'],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontFamily: Myfont,
                                    ),
                                  ),
                                ),
                                if (infoUser['bio'] != '') SizedBox(height: 20),
                                Text(
                                  'محصولات و خدمات',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontFamily: Myfont,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    infoUser['tags'],
                                    style: TextStyle(fontFamily: Myfont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }

              return Center(
                  child: CircularProgressIndicator(
                color: Color(0xFF149694),
              ));
            }));
  }
}
