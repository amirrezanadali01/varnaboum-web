import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:line_icons/line_icon.dart';
import 'package:varnaboomweb/Detail.dart';
import '../mapPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:varnaboomweb/base.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class EndRegister extends StatefulWidget {
  const EndRegister(
      {Key? key,
      required this.questionAnswer,
      required this.AssetImage,
      required this.imageProfile})
      : super(key: key);

  final List<Map> questionAnswer;
  final List AssetImage;
  final XFile? imageProfile;

  @override
  _EndRegisterState createState() => _EndRegisterState();
}

class _EndRegisterState extends State<EndRegister> {
  String idCategory = registerInformationShop['category'];

  late bool isMap;
  bool is_load = false;

  late dio.FormData formdata;

  late List<Map> questionAnswer;
  late List asstImages;
  late XFile? imageProfile;

  XFile? video;
  late TextEditingController controllerNumber;
  late TextEditingController controllerInstagram;
  late TextEditingController controllerBio;
  late List questionCategory = [];

  dio.Dio _dio = dio.Dio();

  Future<void> get_video() async {
    final ImagePicker _picker = ImagePicker();
    video = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {});
  }

  Future<bool> getQuestion() async {
    if (is_load == false) {
      await updateToken(context);

      var boxToken = await Hive.openBox('token');

      String access = boxToken.get('access');
      http.Response questions = await http.get(
          Uri.parse('$host/api/retryQuestionOptional/$idCategory/'),
          headers: <String, String>{'Authorization': 'Bearer $access'});

      questionCategory = jsonDecode(utf8.decode(questions.bodyBytes));
      createTextField(questionCategory);
    }

    is_load = true;

    return true;
  }

  void createTextField(result) {
    for (var i in result) {
      i['controller'] = TextEditingController();
    }
    setState(() {});
  }

  @override
  void initState() {
    questionAnswer = widget.questionAnswer;
    asstImages = widget.AssetImage;
    imageProfile = widget.imageProfile;

    print('fffffffffffffffffffffffffffffffffffffffffffffffffffffff');
    print(registerInformationShop['lat']);
    print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');

    if (registerInformationShop.containsKey('lat')) {
      print('ffffffffffffffffffffffffffffff');

      isMap = true;
      setState(() {});
    } else {
      isMap = false;
    }

    controllerNumber = TextEditingController();
    controllerInstagram = TextEditingController();
    controllerBio = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF400CCCB),
          child: Icon(Icons.done),
          onPressed: () async {
            if (controllerBio.text.isNotEmpty) {
              registerInformationShop['bio'] = controllerBio.text;
            }
            if (controllerNumber.text.isNotEmpty) {
              registerInformationShop['number'] = controllerNumber.text;
            }

            EasyLoading.show(status: 'منتظر بمانید ...');

            updateToken(context);
            var boxToken = await Hive.openBox('token');
            String access = boxToken.get('access');

            registerInformationShop['user'] = access;

            for (var i in questionCategory) {
              if (i['controller'].text.isNotEmpty)
                questionAnswer.add({
                  'question': i['id'].toString(),
                  'answer': i['controller'].text,
                  'user': access
                });
            }

            String fileNameProfile =
                imageProfile?.path.split('/').last as String;

            fileNameProfile = fileNameProfile.toEnglishDigit();

            print(imageProfile?.name);

            if (video == null) {
              formdata = dio.FormData.fromMap({
                "InfoUser": json.encode(registerInformationShop),
                "AnswerQuestion": json.encode(questionAnswer),
                "ImageStore": asstImages,
                "Profile": MultipartFile.fromBytes(
                    await imageProfile!.readAsBytes() as List<int>,
                    filename: "${fileNameProfile}.png"),
              });
            } else {
              String fileNameVideo = video?.path.split('/').last as String;
              formdata = dio.FormData.fromMap({
                "InfoUser": json.encode(registerInformationShop),
                "AnswerQuestion": json.encode(questionAnswer),
                "ImageStore": asstImages,
                "Profile": await MultipartFile.fromBytes(
                    await imageProfile?.readAsBytes() as List<int>,
                    filename: fileNameProfile.toEnglishDigit(),
                    contentType: MediaType("image", "png")),
                "Vido": await MultipartFile.fromFile(video?.path as String,
                    filename: fileNameVideo.toEnglishDigit()),
              });
            }

            _dio.options.headers['content-Type'] = 'application/json';
            _dio.options.headers['Authorization'] = 'Bearer $access';

            print(registerInformationShop);

            var response =
                await _dio.post("$host/api/registerShop/", data: formdata);

            EasyLoading.dismiss();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: baseWidget())));

            //fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffklj
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: IntrinsicHeight(
                    child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: TextField(
                                controller: controllerInstagram,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.pinkAccent)),
                                  labelStyle: TextStyle(
                                      fontFamily: Myfont,
                                      color: Colors.grey,
                                      fontSize: 17),
                                  labelText: 'نام کاربری اینستاگرام',
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                              content: Text(''),
                              actions: [
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          BorderSide(color: Color(0xFF149694)),
                                    ),
                                    child: Text(
                                      'ذخیره',
                                      style: TextStyle(fontFamily: Myfont),
                                    ),
                                    onPressed: () => setState(() {
                                          print(
                                              'mmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
                                          Navigator.pop(context);
                                          registerInformationShop['instagram'] =
                                              controllerInstagram.text;
                                        })),
                              ],
                            );
                          }),
                      child: Column(
                        children: [
                          (LineIcon.instagram(
                              size: 30,
                              color: controllerInstagram.text.isEmpty
                                  ? Colors.orangeAccent
                                  : Colors.greenAccent)),
                          Text(
                            'اینستاگرام',
                            style: TextStyle(
                                fontFamily: Myfont,
                                color: controllerInstagram.text.isEmpty
                                    ? Colors.orangeAccent
                                    : Colors.greenAccent),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 10, right: 10),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: controllerBio,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.greenAccent)),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontFamily: Myfont,
                                ),
                                labelText: 'درباره ما',
                                enabledBorder: InputBorder.none,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 10, right: 10),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controllerNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.greenAccent)),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontFamily: Myfont,
                                ),
                                labelText: 'شماره تماس',
                                enabledBorder: InputBorder.none,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
              FutureBuilder(
                  future: getQuestion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        is_load == false) {
                      return new Center(
                        child: new CircularProgressIndicator(
                          color: Color(0xFF149694),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            for (var i in questionCategory)
                              Card(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  width: double.infinity,
                                  child: TextField(
                                    controller: i['controller'],
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.greenAccent)),
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontFamily: Myfont,
                                      ),
                                      labelText: i['question'],
                                      enabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}




// i['question']