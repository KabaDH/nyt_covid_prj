import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nyt_covid_prj/services/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      title: Text(
        'Covid-19 USA statistic',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.info,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _fontSize = 16.0;

    return Center(
      child: Container(
        color: Palette.primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        padding: EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Data from The New York Times, based on reports from state and local health agencies.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'The New York Times. (2022). Coronavirus (Covid-19) Data in the United States',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  Text(
                    'App dev by ',
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'KabaDH',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () async {
                      final creditsUrl = 'https://github.com/KabaDH';
                      if (await canLaunch(creditsUrl))
                        launch(creditsUrl, forceSafariVC: false);
                      else
                        throw 'Can`t load url';
                    },
                  ),
                  Text(
                    ' with ',
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () async {
                      final creditsUrl = 'https://flutter.dev/';
                      if (await canLaunch(creditsUrl))
                        launch(creditsUrl, forceSafariVC: false);
                      else
                        throw 'Can`t load url';
                    },
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
