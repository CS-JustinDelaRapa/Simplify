import 'package:flutter/material.dart';

final List<String> iconImageList = [
  '001-panda.png',
  '002-lion.png',
  '003-tiger.png',
  '004-bear-1.png',
  '005-parrot.png',
  '006-rabbit.png',
  '007-chameleon.png',
  '008-sloth.png',
  '009-elk.png',
  '010-llama.png',
  '011-ant-eater.png',
  '012-eagle.png',
  '013-crocodile.png',
  '014-beaver.png',
  '015-hamster.png',
  '016-walrus.png',
  '017-bear.png',
  '018-cheetah.png',
  '019-kangaroo.png',
  '020-duck.png',
  '021-goose.png',
  '022-lemur.png',
  '023-ostrich.png',
  '024-owl.png',
  '025-boar.png',
  '026-penguin.png',
  '027-camel.png',
  '028-raccoon.png',
  '029-hippo.png',
  '030-monkey.png',
  '031-meerkat.png',
  '032-snake.png',
  '033-zebra.png',
  '034-donkey.png',
  '035-bull.png',
  '036-goat-1.png',
  '037-goat.png',
  '038-horse.png',
  '039-wolf.png',
  '040-koala.png',
  '041-hedgehog.png',
  '042-frog.png',
  '043-turtle.png',
  '044-gorilla.png',
  '045-giraffe.png',
  '046-deer.png',
  '047-rhinoceros.png',
  '048-elephant.png',
  '049-puma.png',
  '050-fox.png'
];

class ChangeUserIcon extends StatefulWidget {
  const ChangeUserIcon({Key? key}) : super(key: key);

  @override
  _ChangeUserIconState createState() => _ChangeUserIconState();
}

class _ChangeUserIconState extends State<ChangeUserIcon> {
  late String userIcon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
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
                  padding: EdgeInsets.all(10),
                  child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      padding: EdgeInsets.all(8),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: iconImageList.map(_makeGridTile).toList()),
                ),
              ),
            )
          ],
        ),
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
                    child: RaisedButton(
                      elevation: 8.0,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context, userIcon);
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
      ],
    );
  }

  Widget _makeGridTile(String userIconPath) {
    return GridTile(
      child: GestureDetector(
          onTap: () {
            setState(() {
              userIcon = userIconPath;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: userIconPath == userIcon ? Colors.yellow : Colors.white,
                border: userIconPath == userIcon
                    ? Border.all(width: 3, color: Colors.red)
                    : null,
              ),
              child: Image.asset('images/$userIconPath'))), //image,
    );
  }
}
