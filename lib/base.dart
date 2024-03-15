import 'dart:convert';
import 'ContectUs.dart';
import 'package:flutter/material.dart';
import 'package:varnaboomweb/Detail.dart';
import '/Category/CategoriesPage.dart';
import 'ProfileUser/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class baseWidget extends StatefulWidget {
  @override
  _baseWidgetState createState() => _baseWidgetState();
}

class _baseWidgetState extends State<baseWidget> {
  int _selectedIndex = 0;

  List<Widget> pages = [Category(), ContectUs(), Profile()];

  //pages[_selectedIndex]

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF008594),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle:
              TextStyle(fontFamily: Myfont, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontFamily: Myfont),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
