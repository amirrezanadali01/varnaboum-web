import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:varnaboomweb/FirstLogin/loginpage.dart';
import 'base.dart';

String host = 'https://varnaboum.com';
// String host = 'http://192.168.96.14:8000';

const Myfont = 'Iran-Sans';

class CityModel {
  CityModel({required this.id, required this.name});

  final int id;
  final String name;
}

class ItemShop {
  ItemShop(
      {required this.id,
      required this.address,
      required this.name,
      required this.subcategory,
      required this.image});

  final int id;
  final String name;
  final List subcategory;
  final String image;
  final String address;
}

Future<void> loginToken(context,
    {required String username, required String password}) async {
  await EasyLoading.show(status: 'منتظر بمانید ...');

  http.Response hh = await http.post(
    Uri.parse('$host/api/token/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username.toString(),
      'password': password
    }),
  );

  var refreshToken = jsonDecode(hh.body)['refresh'];
  var accessToken = jsonDecode(hh.body)['access'];

  print(hh.body);
  print(hh.statusCode);

  if (hh.statusCode == 200) {
    var box = await Hive.box('token');
    box.put('access', accessToken);
    box.put('refresh', refreshToken);

    EasyLoading.dismiss();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return Directionality(
            textDirection: TextDirection.rtl, child: baseWidget());
      }),
    );
  } else {
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('نام کاربری یا گذرواژه اشتباه است'),
            ));
  }
}

Future<void> updateToken(context) async {
  await Hive.initFlutter();
  var boxToken = await Hive.openBox('token');
  String refresh = boxToken.get('refresh');
  String access = boxToken.get('access');

  http.Response verify_token = await http.post(
    Uri.parse('$host/api/token/verify/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'token': access}),
  );

  print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
  print(verify_token.statusCode);
  print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

  if (verify_token.statusCode == 401) {
    http.Response hh = await http.post(
      Uri.parse('$host/api/token/refresh/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'refresh': refresh}),
    );

    print('noooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    print(hh.body);
    print(hh.statusCode);
    print('noooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');

    if (jsonDecode(hh.body)['access'] == null || hh.statusCode == 401) {
      print(
          'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => login()));
    } else {
      boxToken.put('access', jsonDecode(hh.body)['access']);
    }

    print('-------------------------------------------');
    print(boxToken.get('access'));

    print('heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
  }
  // else {
  //   print('is valied');
  // }
}

class CategoriesItem {
  const CategoriesItem(
      {Key? key,
      required this.name,
      required this.image,
      required this.id,
      required this.subtitle});

  final String name;
  final String image;
  final int id;
  final List subtitle;
}

Map registerInformationShop = {};
