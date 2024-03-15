import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:varnaboomweb/Category/CategoriesPage.dart';
// import 'package:varnaboomweb/infopage.dart';
import 'FirstLogin/loginpage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'base.dart';
import 'package:path_provider/path_provider.dart';
// import 'TestImage.dart';
import 'FirstLogin/Register/RegisterShop/CityRegister.dart';
import 'ProfileUser/RetryProfile.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          title: 'وارنابوم',
          builder: EasyLoading.init(
              builder: (context, widget) => ResponsiveWrapper.builder(
                    widget,
                    maxWidth: 500,
                    minWidth: 250,
                    defaultScale: true,
                    breakpoints: [
                      ResponsiveBreakpoint.resize(400, name: MOBILE),
                      ResponsiveBreakpoint.autoScale(800, name: TABLET),
                      ResponsiveBreakpoint.resize(800, name: DESKTOP),
                    ],
                  )),
          scrollBehavior: MyCustomScrollBehavior(),
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: Directionality(
              textDirection: TextDirection.rtl, child: Category()));
    });
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
