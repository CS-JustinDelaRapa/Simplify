import 'package:flutter/material.dart';
import 'package:simplify/model/diary.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/page/diary/diaryScreens/diary_add_backend.dart';
import 'package:intl/intl.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage>
    with AutomaticKeepAliveClientMixin {
  late List<Diary> diaryContent;
  List<Diary> deleteList = [];

  bool allSelected = false;
  bool onLongPress = false;
  bool isLoading = false;

  final _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    this.diaryContent = await DatabaseHelper.instance.readAllDiary();
    setState(() => isLoading = false);
  }

  //Main UI diary
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: onLongPress
              ? IconButton(onPressed: cancelState, icon: Icon(Icons.cancel))
              : Container(),
          backgroundColor: Color(0xFF57A0D3),
          elevation: 0.0,
          centerTitle: true,
          title: onLongPress
              ? Text(
                  'Selected Items: ' + deleteList.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 23),
                )
              : Text(
                  'Diary',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
          actions: <Widget>[onLongPress ? trailingAppbar() : Container()],
        ),
        body: Container(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : diaryContent.isEmpty
                    ? Text(
                        'No Diary Content',
                        style: TextStyle(fontSize: 20),
                      )
                    : buildList(),
          ),
        ),
        floatingActionButton: onLongPress
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.blueGrey[900],
                child: Icon(
                  Icons.add,
                  size: 30.0,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEditDiaryPage()),
                  );
                  refreshState();
                },
              ),
      ),
    );
  }

//** */**Funtions */**Funtions */**Funtions */**Funtions */**Funtions *///** */**Funtions */**Funtions */**Funtions */**Funtions */**Funtions */

//listTiles
  Widget buildList() => ListView.builder(
      itemCount: diaryContent.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap
              //if
              : onLongPress
                  ? () async {
                      if (deleteList.contains(diaryContent[index])) {
                        setState(() {
                          deleteList.remove(diaryContent[index]);
                          allSelected = false;
                        });
                      } else {
                        setState(() {
                          deleteList.add(diaryContent[index]);
                          if (deleteList.length == diaryContent.length) {
                            allSelected = true;
                          }
                        });
                      }
                    }
                  //else
                  : () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditDiaryPage(
                              diaryContent: diaryContent[index])));
                      refreshState();
                    },
          onLongPress: () async {
            onLongPress = true;
            setState(() {
              deleteList.add(diaryContent[index]);
              if (deleteList.length == diaryContent.length) {
                allSelected = true;
              } else {
                allSelected = false;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: _lightColors[index % _lightColors.length],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: ListTile(
                  title: Text(
                    diaryContent[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(diaryContent[index].dateCreated),
                  ),
                  trailing: deleteList.contains(diaryContent[index])
                      ? Icon(Icons.check)
                      : null,
                ),
              ),
            ),
          ),
        );
      });

//appBar select all and delete button
  Widget trailingAppbar() {
    return Row(
      children: [
        Container(
            child: allSelected
                ? IconButton(
                    onPressed: unselectAll, icon: Icon(Icons.remove_rounded))
                : IconButton(
                    onPressed: selectAll,
                    icon: Icon(Icons.checklist_rtl_rounded))),
        IconButton(onPressed: deleteItems, icon: Icon(Icons.delete))
      ],
    );
  }

//cancleButton
  Future cancelState() async {
    setState(() {
      deleteList.length = 0;
      onLongPress = false;
    });
  }

//deleteButton
  Future deleteItems() async {
    for (int x = 0; x < deleteList.length; x++) {
      int? search = deleteList[x].id;
      await DatabaseHelper.instance.deleteDiary(search!);
    }
    setState(() {
      onLongPress = false;
      deleteList = [];
      refreshState();
    });
  }

//selectAll
  Future selectAll() async {
    setState(() {
      allSelected = true;
      deleteList = List.from(diaryContent);
    });
  }

//unselectAll
  Future unselectAll() async {
    setState(() {
      deleteList = [];
      allSelected = false;
    });
  }

  //persisting diary
  @override
  bool get wantKeepAlive => true;
}
