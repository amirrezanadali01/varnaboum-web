import 'dart:convert';
import 'Edit/ImageShopEdite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:varnaboomweb/Detail.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../FirstLogin/loginpage.dart';
import '../FirstLogin/Register/RegisterShop/CityRegister.dart';
import 'package:image_picker/image_picker.dart';
import 'Edit/ImagePrfileEdite.dart';
import 'Edit/mapPageEditor.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'Edit/TxtProfileEdit.dart';
import 'Edit/Movie/ShowMovie.dart';
import 'Edit/Movie/EditeMovie.dart';
import 'Edit/AnswerQuestionEdite.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum statusUser { nothing, registered, confirmation }

class _ProfileState extends State<Profile> {
  late String status;
  late Widget statusWidget;
  XFile? video;

  Future<void> get_video(int id) async {
    final ImagePicker _picker = ImagePicker();
    video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: EditeVideo(
                      id: id,
                      video: video as XFile,
                    ),
                  )));
    }
  }

  Future<List> GetShopImage() async {
    // await updateToken(context);
    var boxToken = await Hive.openBox('token');
    String access = boxToken.get('access');
    http.Response result = await http.get(Uri.parse('$host/api/ImageShopUser/'),
        headers: <String, String>{'Authorization': 'Bearer $access'});

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    return a;
  }

  Future<List> GetInfoUser() async {
    var boxToken = await Hive.openBox('token');
    String access = boxToken.get('access');
    //retryuser/

    http.Response result = await http.get(Uri.parse('$host/api/retryuser/'),
        headers: <String, String>{'Authorization': 'Bearer $access'});

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    return a;
  }

  Future<List> GetAnswerQuestion() async {
    var boxToken = await Hive.openBox('token');
    String access = boxToken.get('access');
    //retryuser/

    http.Response result = await http.get(
        Uri.parse('$host/api/AnswerQuestionProfile/'),
        headers: <String, String>{'Authorization': 'Bearer $access'});

    List a = jsonDecode(utf8.decode(result.bodyBytes));

    return a;
  }

  XFile? imageProfile;

  Future<void> get_ImageProfile(int id) async {
    final ImagePicker _picker = ImagePicker();
    imageProfile = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 85);

    if (imageProfile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: ProfileImage(
                      id: id,
                      imageProfile: imageProfile!,
                    ),
                  )));
    }
  }

  Future<void> SetStatusUser() async {
    var boxToken = await Hive.openBox('token');
    // await updateToken(context);
    String access = boxToken.get('access');

    http.Response statusUserRequest = await http.get(
      Uri.parse('$host/api/retryuser/'),
      headers: <String, String>{'Authorization': 'Bearer $access'},
    );

    print(statusUserRequest.statusCode.runtimeType);
    await Hive.openBox('InfUser');
    var boxStatus = Hive.box('InfUser');

    switch (statusUserRequest.statusCode) {
      case 500:
        boxStatus.put('StatusUser', "nothing");
        break;

      case 200:
        print(statusUserRequest.body);
        if (jsonDecode(statusUserRequest.body)[0]['Confirmation'] == false) {
          boxStatus.put('StatusUser', "registered");
        } else {
          boxStatus.put('StatusUser', "confirmation");
        }
    }

    // box.put('StatusUser', accessToken);

    var aa = await Hive.openBox('InfUser');
    status = aa.get('StatusUser');

    print(
        'statusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatus');
    print(status);
    print(
        'statusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatusstatus');

    switch (status) {
      case 'nothing':
        statusWidget = Container(
            width: double.infinity,
            child: Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF149694)),
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Directionality(
                              textDirection: TextDirection.rtl,
                              child: RegisterCategory()))),
                  child: Text(
                    'ثبت صنف',
                    style: TextStyle(
                      color: Color(0xFF149694),
                      fontFamily: Myfont,
                    ),
                  )),
            ));
        break;

      case 'registered':
        statusWidget = Center(
            child: Text('در انتظار تایید',
                style:
                    TextStyle(fontFamily: Myfont, color: Color(0xFF149694))));
        break;

      case 'confirmation':
        statusWidget = SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List>(
                  future: GetShopImage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ImageShop(
                                        Images: snapshot.data!,
                                      ),
                                    ))),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          width: double.infinity,
                          height: 200,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xffeeeeee),
                            child: PageView(
                              children: [
                                for (var i in snapshot.data!)
                                  Image(
                                    image: NetworkImage(i['imag']),
                                    fit: BoxFit.cover,
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: new CircularProgressIndicator(
                        color: Color(0xFF149694),
                      ),
                    );
                  }),
              FutureBuilder<List>(
                  future: GetInfoUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                get_ImageProfile(snapshot.data![0]['user']),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(snapshot.data![0]['profile']),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (snapshot.data![0]['number'] != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextEdite(
                                                        id: snapshot.data![0]
                                                            ['user'],
                                                        field: "number",
                                                        name: 'شماره تماس',
                                                        text: snapshot.data![0]
                                                                ['number']
                                                            .toString(),
                                                      ),
                                                    )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextEdite(
                                                        id: snapshot.data![0]
                                                            ['user'],
                                                        field: "number",
                                                        name: 'شماره تماس',
                                                      ),
                                                    )));
                                      }
                                    },
                                    icon: Icon(Icons.phone,
                                        size: 30,
                                        color:
                                            snapshot.data![0]['number'] != null
                                                ? Colors.greenAccent
                                                : Colors.orangeAccent)),
                                IconButton(
                                    onPressed: () {
                                      print(
                                          'innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
                                      print(snapshot.data![0]['instagram']);

                                      if (snapshot.data![0]['instagram'] !=
                                          null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextEdite(
                                                        id: snapshot.data![0]
                                                            ['user'],
                                                        field: "instagram",
                                                        name: 'اینستاگرام',
                                                        text: snapshot.data![0]
                                                                ['instagram']
                                                            .toString(),
                                                      ),
                                                    )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextEdite(
                                                        id: snapshot.data![0]
                                                            ['user'],
                                                        field: "instagram",
                                                        name: 'اینستاگرام',
                                                      ),
                                                    )));
                                      }
                                    },
                                    icon: LineIcon(
                                      LineIcons.instagram,
                                      size: 30,
                                      color: snapshot.data![0]['instagram'] !=
                                                  null &&
                                              snapshot.data![0]['instagram'] !=
                                                  ''
                                          ? Colors.pinkAccent
                                          : Colors.orangeAccent,
                                    )),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextEdite(
                                            id: snapshot.data![0]['user'],
                                            field: 'name',
                                            text: snapshot.data![0]['name'],
                                            name: 'نام',
                                          ),
                                        ))),
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'نام',
                                          style: TextStyle(
                                              fontFamily: Myfont,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data![0]['name'],
                                            style:
                                                TextStyle(fontFamily: Myfont),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextEdite(
                                            id: snapshot.data![0]['user'],
                                            field: 'tags',
                                            text: snapshot.data![0]['tags'],
                                            name:
                                                'چه خدمات و محصولاتی ارائه میدهی',
                                          ),
                                        ))),
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'چه خدمات و محصولاتی ارائه میدهی',
                                          style: TextStyle(
                                              fontFamily: Myfont,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data![0]['tags'],
                                            style:
                                                TextStyle(fontFamily: Myfont),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextEdite(
                                            id: snapshot.data![0]['user'],
                                            field: 'address',
                                            text: snapshot.data![0]['address'],
                                            name: 'ادرس',
                                          ),
                                        ))),
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'آدرس صنف',
                                          style: TextStyle(
                                              fontFamily: Myfont,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data![0]['address'],
                                              style: TextStyle(
                                                  fontFamily: Myfont)),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextEdite(
                                            id: snapshot.data![0]['user'],
                                            field: 'bio',
                                            text: snapshot.data![0]['bio'],
                                            name: 'درباره ما',
                                          ),
                                        ))),
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 20, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('درباره ما',
                                            style: TextStyle(
                                                fontFamily: Myfont,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data![0]['bio'],
                                              style: TextStyle(
                                                  fontFamily: Myfont)),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          FutureBuilder<List>(
                              future: GetAnswerQuestion(),
                              builder: (context, snapshop) {
                                if (snapshop.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshop.data!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: EditeAnswer(
                                                            id: snapshop.data![
                                                                index]['id'],
                                                            answer:
                                                                snapshop.data![
                                                                        index]
                                                                    ['answer']),
                                                      ))),
                                          child: Container(
                                            width: double.infinity,
                                            child: Card(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          top: 20,
                                                          bottom: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshop.data![index]
                                                            ['questions'],
                                                        style: TextStyle(
                                                            fontFamily: Myfont,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          snapshop.data![index]
                                                              ['answer'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  Myfont))
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );
                                        ;
                                      });
                                }

                                return Center(
                                  child: new CircularProgressIndicator(
                                    color: Color(0xFF149694),
                                  ),
                                );
                              })
                        ],
                      );
                    }
                    return Center(
                      child: new CircularProgressIndicator(
                        color: Color(0xFF149694),
                      ),
                    );
                    ;
                  })
            ],
          ),
        );
        break;
    }

    setState(() {});
  }

  Future<void> logout() async {
    // Hive.deleteBoxFromDisk('token');
    // Hive.
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => login()));

    var box = await Hive.box('token');
    box.delete('access');
    box.delete('token');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => login()));
  }

  @override
  void initState() {
    status = '';
    statusWidget = Text(status, style: TextStyle(fontFamily: Myfont));

    super.initState();
    SetStatusUser();
    print(
        'dskfjjdskalksdajlkdsajlkfdsjldfskajldkfsfdslkjdsalkjdfslkfjsdlkfsjlfksjfslkjfslkjfsmfdsncdskjdlskacnclkjacndsjnkncdsandcslkj');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () async => await logout(),
            icon: Icon(
              Icons.logout_rounded,
              size: 40,
              color: Color(0xFF149694),
            )),
      ),
      backgroundColor: Colors.white,
      body: statusWidget,
    );
  }
}
