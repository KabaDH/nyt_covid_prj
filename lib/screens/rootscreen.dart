import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/screens/info_screen.dart';
import 'package:nyt_covid_prj/widgets/singleton.dart';
import 'screens.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  var currentIndex = 0;
  final screens = [HomeScreen(), StateSelect(), InfoScreen()];
  var s1 = Singleton.instance;

  @override
  void initState() {
    super.initState();
    s1.currentIndex = currentIndex;
    timer();
  }

  //ХЗ как заставить взаимодействовать синлетон для изменения индекса botnavbar. OnTap тормозит и не всегда срабатывает.
  timer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        print(currentIndex);
        currentIndex = s1.currentIndex!;
      });
      timer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.blueGrey.shade200,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 20,
        onTap: (index) => setState(() => currentIndex = index),
        elevation: 0,
        items: [Icons.public, Icons.filter_list, Icons.info_outline_rounded]
            .asMap()
            .map((key, value) => MapEntry(
                key,
                BottomNavigationBarItem(
                    label: '',
                    icon: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: key == currentIndex
                              ? Colors.blue
                              : Colors.transparent),
                      child: Icon(value),
                    ))))
            .values
            .toList(),
      ),
    );
  }
}
