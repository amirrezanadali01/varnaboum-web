import 'package:flutter/material.dart';
import '../../loginpage.dart';
import 'VerifyNumberUser.dart';
import 'package:varnaboomweb/Detail.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController username = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff00a6a6), Color(0xff006d84)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                  tag: "logo",
                  child: Image(
                    image: AssetImage('assets/image/logo1.png'),
                    color: Colors.white,
                  )),
              InputLogin(
                  controller: username,
                  name: 'شماره همراه',
                  color: Colors.grey.shade200),
              SizedBox(
                height: 10,
              ),
              InputLogin(
                  controller: password1,
                  name: 'گذرواژه',
                  color: Colors.grey.shade200),
              SizedBox(
                height: 10,
              ),
              InputLogin(
                  controller: password2,
                  name: 'تایید گذرواژه',
                  color: Colors.grey.shade200),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (username.text.isNotEmpty) {
                    if (username.text[0] == '0') {
                      username.text = username.text.substring(1);
                    }
                  }

                  if (password1.text != password2.text) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'گذرواژه درست نیست',
                                style: TextStyle(fontFamily: Myfont),
                              ),
                            ));
                  } else if (username.text.length != 10) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('شماره همراه درست نیست',
                                  style: TextStyle(fontFamily: Myfont)),
                            ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyNumber(
                                  password: password1.text,
                                  username: username.text,
                                )));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(100)),
                  margin: EdgeInsets.only(left: 50, right: 50),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'ثبت نام',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: Myfont,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
