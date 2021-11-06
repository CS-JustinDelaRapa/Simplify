import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

final List<String> iconImageList = [
  '001.png',
  '002.png',
  '003.png',
  '004.png',
  '005.png',
  '006.png',
  '007.png',
  '008.png',
  '009.png',
  '010.png',
  '011.png',
  '012.png',
  '013.png',
  '014.png',
  '015.png',
  '016.png',
];

class ChangeUserIcon extends StatefulWidget {
  final String uid;
  final String userIcon;
  const ChangeUserIcon({Key? key, required this.uid, required this.userIcon})
      : super(key: key);

  @override
  _ChangeUserIconState createState() => _ChangeUserIconState();
}

class _ChangeUserIconState extends State<ChangeUserIcon> {
  late String userIconn;

  @override
  void initState() {
    userIconn = widget.userIcon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: <Widget>[
      SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height - size.height * 0.12,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      padding: const EdgeInsets.all(8),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: iconImageList.map(_makeGridTile).toList()),
                ),
              ),
            )
          ]),
      Positioned(
        bottom: 10,
        right: 10,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: ClipOval(
                child: Container(
                  color: Colors.blue,
                  height: 60.0, // height of the button
                  width: 60.0, // width of the button
                  child: ElevatedButton(
                    onPressed: () {
                      AuthService().updateUserIcon(userIconn, context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    ]);
  }

  Widget _makeGridTile(String userIconPath) {
    return GridTile(
      child: GestureDetector(
          onTap: () {
            setState(() {
              userIconn = userIconPath;
              print(userIconn);
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: userIconPath == userIconn ? Colors.yellow : Colors.white,
                border: userIconPath == userIconn
                    ? Border.all(width: 3, color: Colors.red)
                    : null,
              ),
              child: Image.asset('assets/images/$userIconPath'))), //image,
    );
  }
}
