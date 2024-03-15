import 'dart:async';

import 'package:flutter/material.dart';
import 'package:varnaboomweb/ProfileUser/RetryProfile.dart';
import '../../Detail.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'CategoriesRetryPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SearchPage.dart';
import 'package:sizer/sizer.dart';

class Category extends StatefulWidget {
  @override
  _logoutState createState() => _logoutState();
}

class _logoutState extends State<Category> {
  List CategorisList = [];
  List<BannerModel> listBanner = [];

  List<CityModel> cityList = [];

  late Timer _timer;
  int _currentPage = 0;
  PageController pageviewcontroller = PageController();

  Future<void> getCategories() async {
    // await updateToken(context);
    // var boxToken = await Hive.openBox('token');
    // String access = boxToken.get('access');
    http.Response addcategories =
        await http.get(Uri.parse('$host/api/getcategoriesToday/'));

    var result = jsonDecode(utf8.decode(addcategories.bodyBytes));

    if ('detail' == result.keys.toList()[0]) {
    } else {
      readyListCategories(result);
    }
  }

  Future<void> GetBanner() async {
    // await updateToken(context);
    // var boxToken = await Hive.openBox('token');
    // String access = boxToken.get('access');
    http.Response addbanner = await http.get(Uri.parse('$host/api/getBanner/'));
    // headers: <String, String>{'Authorization': 'Bearer $access'});

    if (addbanner.statusCode == 200) {
      List result = jsonDecode(utf8.decode(addbanner.bodyBytes));
      result.forEach((element) {
        listBanner.add(BannerModel(
            image: element['image'],
            title: element['title'],
            action: element['action']));
      });
      setState(() {});
    }
  }

  Future<void> GetCity() async {
    // await updateToken(context);
    // var boxToken = await Hive.openBox('token');
    // String access = boxToken.get('access');
    http.Response addcity = await http.get(Uri.parse('$host/api/getCity/'));

    var result = jsonDecode(utf8.decode(addcity.bodyBytes));

    readyListCity(result);
  }

  void readyListCity(result) {
    for (var i in result) {
      cityList.add(CityModel(id: i['id'], name: i['name']));
    }
    setState(() {});
  }

  void readyListCategories(result) {
    for (var i in result.keys) {
      if (result[i]['subtitle'].isNotEmpty) {
        result[i]['subtitle'].insert(0, {
          'name': 'انتخاب کنید',
          'id': 50000,
          'subtitle': [
            {'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000}
          ]
        });

        for (var i in result[i]['subtitle']) {
          if (i['id'] != 50000) {
            i['subtitle'].insert(0, {
              'name': 'انتخاب کنید',
              'id': 50000,
              'subtitle': [
                {'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000}
              ]
            });
          }
          // i.insert({'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000});

        }
      }

      CategorisList.add(CategoriesItem(
          name: i,
          id: result[i]['id'],
          image: '$host' + result[i]['image'],
          subtitle: result[i]['subtitle']));
    }

    print('hiiiiiiiiiiiiiiiiiiiiiiiii');
    print(CategorisList[0].subtitle);
    print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');

    setState(() {});
  }

  @override
  void initState() {
    GetBanner();
    GetCity();
    getCategories();

    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageviewcontroller.hasClients) {
        if (_currentPage < listBanner.length) {
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image(
          image: AssetImage('assets/image/logo2.png'),
          fit: BoxFit.cover,
          color: Colors.white,
        ),

        // Image(image: AssetImage('assets/image/logo2.png'))

        backgroundColor: Color(0xFF008594),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () => Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => serach())),
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.only(left: 20, right: 10),
            //     height: 30,
            //     margin: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.search,
            //           color: Colors.grey,
            //         ),
            //         Text(
            //           'جست و جو',
            //           style: TextStyle(
            //               color: Colors.grey, fontSize: 15, fontFamily: Myfont),
            //         )
            //       ],
            //     ),
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //         color: Colors.grey[300],
            //         borderRadius: BorderRadius.all(Radius.circular(50))),
            //   ),
            // ),
            Container(
              width: double.infinity,
              height: 180,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: PageView(
                  controller: pageviewcontroller,
                  children: [
                    for (var i in listBanner)
                      GestureDetector(
                          onTap: () async {
                            if (i.action == 'varnaboom') {
                              List splitTitle = i.title.split(',');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: RetryProfile(
                                              name: splitTitle[1],
                                              id: int.parse(splitTitle[0])))));
                            }

                            if (i.action == 'instagram') {
                              await launch(
                                  "https://www.instagram.com/${i.title}/");
                            }
                            if (i.action == 'site') {
                              await launch("https://${i.title}/");
                            }
                            if (i.action == 'phone') {
                              await launch("tel:+98${i.title}");
                            }
                          },
                          child: Image(
                            image: NetworkImage(i.image),
                            fit: BoxFit.cover,
                          ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 0.90), //0.90
                  itemCount: CategorisList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctx, index) {
                    return CategoryItem(
                      id: CategorisList[index].id,
                      citys: cityList,
                      name: CategorisList[index].name,
                      image: CategorisList[index].image,
                      subtitle: CategorisList[index].subtitle,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.subtitle,
    required this.citys,
    Key? key,
  }) : super(key: key);

  final String name;
  final int id;
  final String image;
  final List subtitle;
  final List<CityModel> citys;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: CategoryRetry(
                      id: id,
                      subtitle: subtitle,
                      citys: citys,
                    ),
                  ))),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 0.38.h, //38   0.38.h
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image(
                    image: NetworkImage(image),
                    width: 20.w,
                    height: 20.h,
                  ),
                  maxRadius: 4.55.h, //4.27.h
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: TextStyle(fontFamily: Myfont),
          )
        ],
      ),
    ));
  }
}

class BannerModel {
  BannerModel({required this.image, required this.title, required this.action});

  final String image;
  final String title;
  final String action;
}
