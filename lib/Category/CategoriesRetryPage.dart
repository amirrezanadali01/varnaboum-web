//TODO: اگر زیر مجموعه نداشت چه درخواستی بفرستد

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../Detail.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../ProfileUser/RetryProfile.dart';

import 'package:sizer/sizer.dart';

class CategoryRetry extends StatefulWidget {
  const CategoryRetry(
      {Key? key,
      required this.subtitle,
      required this.citys,
      required this.id});

  final List subtitle;
  final List<CityModel> citys;
  final int id;

  @override
  _CategoryRetryState createState() => _CategoryRetryState();
}

class _CategoryRetryState extends State<CategoryRetry> {
  late String titleCity;
  late String titleSubCategory;
  late String titleSubTitle;

  late String? nextpageUrl;

  late List listCity;

  late List listSubTitle;

  int _value = 0;
  int _valueCity = 0;
  int _valueSubtitle = 0;
  late List<ItemShop> ListItme;
  int idSubCategory = 50000;
  int idSubTitle = 50000;
  bool is_firstload = true;
  bool is_load = false;

  Future<void> GetItmeShop({required bool is_all}) async {
    if (is_all == true) {
      ListItme = [];
      is_firstload = false;

      http.Response requestData = await http.get(
        Uri.parse('$host/api/AllItem/${widget.id}'),
      );

      var result = jsonDecode(utf8.decode(requestData.bodyBytes));

      nextpageUrl = result['next'];

      DecodeItemShop(result['results']);
    } else {
      ListItme = [];
      is_firstload = false;

      if (listSubTitle.isNotEmpty) {
        idSubCategory = listSubTitle[_value]['id'];
        if (listSubTitle[_value]['subtitle'].isNotEmpty) {
          idSubTitle = listSubTitle[_value]['subtitle'][_valueSubtitle]['id'];
        } else {
          idSubTitle = 50000;
        }
      }

      int idCity = listCity[_valueCity].id;

      http.Response requestData = await http.get(
        Uri.parse(
            '$host/api/ItemShop/${widget.id}/$idSubCategory/$idSubTitle/$idCity'),
      );

      var result = jsonDecode(utf8.decode(requestData.bodyBytes));

      nextpageUrl = result['next'];

      DecodeItemShop(result['results']);
    }
  }

  Future<void> GetNextPage(nextpage) async {
    http.Response requestData = await http.get(
      Uri.parse(nextpage),
    );

    var result = jsonDecode(utf8.decode(requestData.bodyBytes));

    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
    print(result['next']);
    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');

    nextpageUrl = result['next'];
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(nextpage);
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    DecodeItemShop(result['results'], isnextpage: true);
  }

  void DecodeItemShop(List body, {bool isnextpage = false}) {
    for (var i in body) {
      var subcategory = [];
      for (var j in i['subcategory']) {
        subcategory.add(j['name']);
      }
      ListItme.add(ItemShop(
          address: i['address'],
          id: i['user'],
          name: i['name'],
          subcategory: subcategory,
          image: i['profile']));
    }

    is_load = false;

    if (isnextpage == true || is_firstload == false) {
      setState(() {
        print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
        print(nextpageUrl);
        print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      });
    }
  }

  ScrollController _scrollController = ScrollController();

  late Future user;

  @override
  void initState() {
    ListItme = [];

    print('000000000000000000000000000');
    print(widget.subtitle);
    print('000000000000000000000000000');

    listCity = [];
    listSubTitle = [];

    listCity = widget.citys;
    listSubTitle = widget.subtitle;

    print(listSubTitle.isEmpty);

    // if (listSubTitle.isNotEmpty) {
    //   print(
    //       'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

    //   listSubTitle.insert(0, {
    //     'name': 'انتخاب کنید',
    //     'id': 50000,
    //     'subtitle': [
    //       {'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000}
    //     ]
    //   });

    //   for (var i in listSubTitle) {
    //     if (i['id'] != 50000) {
    //       i['subtitle'].insert(0, {
    //         'name': 'انتخاب کنید',
    //         'id': 50000,
    //         'subtitle': [
    //           {'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000}
    //         ]
    //       });
    //     }
    //     // i.insert({'id': 50000, 'name': 'انتخاب کنید', 'subcategory_id': 50000});

    //   }
    // }

    if (listCity[0].id != 50000) {
      listCity.insert(0, CityModel(id: 50000, name: 'شهر'));
    }

    //GetItmeShop();
    if (listSubTitle.isEmpty) {
      titleSubCategory = '';
    } else {
      titleSubCategory = listSubTitle[0]['name'];

      if (listSubTitle[0]['subtitle'].isEmpty) {
        titleSubTitle = '';
      } else {
        titleSubTitle = listSubTitle[0]['subtitle'][0]['name'];
      }
    }

    titleCity = listCity[0].name;
    user = GetItmeShop(is_all: is_firstload);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_forward_outlined))
          ],
          backgroundColor: Color(0xFF149694),
          leading: Container(),
        ),
        body: ListView(
          children: [
            if (listSubTitle.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                child: OutlinedButton(
                  child: Text(
                    titleSubCategory,
                    style: TextStyle(color: Colors.black54, fontFamily: Myfont),
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: StatefulBuilder(builder: (context, stat) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < listSubTitle.length;
                                        i++)
                                      ListTile(
                                        title: Text(
                                          listSubTitle[i]['name'],
                                          style: TextStyle(fontFamily: Myfont),
                                        ),
                                        leading: Radio<int>(
                                            focusColor: Color(0xFF149694),
                                            activeColor: Color(0xFF149694),
                                            value: i,
                                            groupValue: _value,
                                            onChanged: (value) {
                                              setState(() {
                                                _value = value as int;

                                                if (widget
                                                    .subtitle[_value]
                                                        ['subtitle']
                                                    .isNotEmpty) {
                                                  titleSubTitle = widget
                                                          .subtitle[_value]
                                                      ['subtitle'][0]['name'];
                                                }
                                                _valueSubtitle = 0;
                                                titleSubCategory =
                                                    listSubTitle[i]['name'];
                                              });

                                              Navigator.pop(context);
                                            }),
                                      )
                                  ],
                                ),
                              );
                            }),
                          )),
                ),
              ),
            if (listSubTitle.isNotEmpty)
              if (listSubTitle[_value]['subtitle'].isNotEmpty &&
                  listSubTitle[_value]['subtitle'].length != 1)
                Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    right: 40,
                  ),
                  child: OutlinedButton(
                    child: Text(titleSubTitle,
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: Myfont,
                        )),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content:
                                  StatefulBuilder(builder: (context, stat) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              widget
                                                  .subtitle[_value]['subtitle']
                                                  .length;
                                          i++)
                                        ListTile(
                                          title: Text(
                                            listSubTitle[_value]['subtitle'][i]
                                                ['name'],
                                            style:
                                                TextStyle(fontFamily: Myfont),
                                          ),
                                          leading: Radio<int>(
                                              focusColor: Color(0xFF149694),
                                              activeColor: Color(0xFF149694),
                                              value: i,
                                              groupValue: _valueSubtitle,
                                              onChanged: (valueSubtitle) {
                                                setState(() {
                                                  _valueSubtitle =
                                                      valueSubtitle as int;

                                                  titleSubTitle = widget
                                                          .subtitle[_value]
                                                      ['subtitle'][i]['name'];
                                                });
                                                Navigator.pop(context);
                                              }),
                                        )
                                    ],
                                  ),
                                );
                              }),
                            )),
                  ),
                ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: OutlinedButton(
                child: Text(titleCity,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: Myfont,
                    )),
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          content: StatefulBuilder(builder: (context, stat) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (int i = 0; i < listCity.length; i++)
                                    ListTile(
                                      title: Text(
                                        listCity[i].name,
                                        style: TextStyle(fontFamily: Myfont),
                                      ),
                                      leading: Radio<int>(
                                          focusColor: Color(0xFF149694),
                                          activeColor: Color(0xFF149694),
                                          value: i,
                                          groupValue: _valueCity,
                                          onChanged: (valueCity) {
                                            setState(() {
                                              _valueCity = valueCity as int;
                                              titleCity = listCity[i].name;
                                            });
                                            Navigator.pop(context);
                                          }),
                                    )
                                ],
                              ),
                            );
                          }),
                        )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFF149694),
                    side: BorderSide(color: Color(0xFF149694))),
                child: Text(
                  'جست و جو',
                  style: TextStyle(color: Colors.white, fontFamily: Myfont),
                ),
                onPressed: () {
                  setState(() {
                    print('hiiiiiiiiiiiiiiiiiiii');
                    is_load = true;
                    GetItmeShop(is_all: is_firstload);
                  });
                },
              ),
            ),
            FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return new Center(
                      child: new CircularProgressIndicator(
                        color: Color(0xFF149694),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 20.h,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollEndNotification) {
                              if (nextpageUrl != null) {
                                GetNextPage(nextpageUrl);
                              }
                            }
                            return true;
                          },
                          child: is_load == true
                              ? Center(
                                  child: new CircularProgressIndicator(
                                    color: Color(0xFF149694),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: ListItme.length + 1,
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    if (index == ListItme.length) {
                                      if (nextpageUrl == null) {
                                        return Container();
                                      } else {
                                        return Center(
                                          child: new CircularProgressIndicator(
                                            color: Color(0xFF149694),
                                          ),
                                        );
                                      }
                                    } else {
                                      return Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: RetryProfile(
                                                              name: ListItme[
                                                                      index]
                                                                  .name,
                                                              id: ListItme[
                                                                      index]
                                                                  .id)))),
                                          child: Card(
                                            shadowColor: Color(0xFF149694),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 100,
                                                    width: 150,
                                                    child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        child: Image(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                ListItme[index]
                                                                    .image)))),
                                                Container(
                                                  width: 300,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 5,
                                                        ),
                                                        child: Text(
                                                            ListItme[index]
                                                                .name,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    Myfont,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .right),
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  right: 4),
                                                          child: Text(
                                                              ListItme[index]
                                                                  .address,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    Myfont,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                        ));
                  }
                })
          ],
        ));
  }
}
