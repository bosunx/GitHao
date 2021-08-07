import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:githao/generated/l10n.dart';
import 'package:githao/util/const.dart';
import 'package:githao/widget/flutter_logo_animation.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container(),),
                  Text(S.of(context).app_name,
                    style: TextStyle(fontFamily: Const.font1, fontSize: 48, fontWeight: FontWeight.w900),
                  ),
                  Text(S.of(context).app_desc,
                    style: TextStyle(fontFamily: Const.font1),
                  ),
                  Expanded(child: Container(),),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/github.webp'),
                      const FlutterLogoAnimation(),
                    ],
                  ),
                  Expanded(child: Container(),),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageIcon(AssetImage('assets/images/github.webp'),),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(S.of(context).sing_in_with_github,)
                      ],
                    ),
                  ),
                  Expanded(child: Container(),),
                ],
              )
          )
      ),
    );
  }
}
