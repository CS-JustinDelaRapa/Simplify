import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoadingPrefs = false;

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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: onLongPress
              ? IconButton(onPressed: cancelState, icon: Icon(Icons.cancel))
              : null,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: onLongPress
              ? Text(deleteList.length == 1?
                     deleteList.length.toString() + ' Selected Item'
                     :deleteList.length == 0? 'Select an Item'
                     :deleteList.length.toString() + ' Selected Items',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                )
              : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_rounded),
                Text(
                  ' Diary',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          actions: <Widget>[onLongPress ? trailingAppbar() : Container()],
        ),
        body: Container(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : diaryContent.isEmpty
                    ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 180,
                                width: 180,
                                 decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/folder.png"),
          fit: BoxFit.cover,
        ),
      ),
                              ),
                              Text(
                                  'No Diary Content',
                                  style: TextStyle(fontSize: 20),
                                ),
                            ],
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

Future<int> loadShared(int id) async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  int sharedPref = pref.getInt(id.toString()) ?? Colors.amber.value;
  return sharedPref;
}

//listTiles
  Widget buildList() => ListView.builder(
      itemCount: diaryContent.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: loadShared(diaryContent[index].id!),
          builder: (context, snapshot){
          if(snapshot.hasData){
            final int color = snapshot.data as int;
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
            onLongPress: 
            !onLongPress?
            () async {
              onLongPress = true;
              setState(() {
                deleteList.add(diaryContent[index]);
                if (deleteList.length == diaryContent.length) {
                  allSelected = true;
                } else {
                  allSelected = false;
                }
              });
            }
            :(){},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 12),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            diaryContent[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                      Expanded(
                        flex: 2,
                        child: Text(
                        DateFormat.yMMMd().format(diaryContent[index].dateCreated),
                                        style: TextStyle(fontSize: 12),),
                      )                      
                      ],
                    ),
                    subtitle: Text(
                      diaryContent[index].description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),),
                    trailing: deleteList.contains(diaryContent[index])
                        ? Icon(Icons.check)
                        : null,
                  ),
                ),
              ),
            ),
          );
        } else{
         return Center(child: CircularProgressIndicator(),);
        }
        },
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
        deleteList.length == 0? SizedBox()
        :IconButton(onPressed: (){
              showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                        deleteList.length == 1? 'Delete ' + deleteList.length.toString()+ ' item?'
                        :deleteList.length == 0? 'sample'
                        :'Delete ' + deleteList.length.toString()+ ' items?'
                        ),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              deleteItems();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          )
                        ],
                      );
                  }
              );      
        }
        , icon: Icon(Icons.delete))
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
