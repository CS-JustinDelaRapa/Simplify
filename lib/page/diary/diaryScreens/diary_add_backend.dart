import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/diary.dart';
import 'package:simplify/page/diary/diaryScreens/diary_add_UI.dart';

class AddEditDiaryPage extends StatefulWidget {
  final Diary? diaryContent;
  const AddEditDiaryPage({Key? key, this.diaryContent}) : super(key: key);

  @override
  _AddEditDiaryPageState createState() => _AddEditDiaryPageState();
}

class _AddEditDiaryPageState extends State<AddEditDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  late int color;
  late String title;
  late String description;
  late DateTime dateCreated;
  late bool _btnEnabled = false;
  late String id;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    id = widget.diaryContent?.id.toString() ?? 'temp';
    title = widget.diaryContent?.title ?? '';
    description = widget.diaryContent?.description ?? '';
    dateCreated = widget.diaryContent?.dateCreated ?? DateTime.now();
    loadColorShared();
  }

    void loadColorShared() async {
      setState(() {
        isLoading = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int _color = (prefs.getInt(id.toString()) ?? Colors.amber.value);
      color = _color;
    });
        setState(() {
        isLoading = false;
      });
    print('colorsssss '+color.toString());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.indigo.shade800,
          actions: [buildButton(_btnEnabled)],
        ),
        body: isLoading?
          Center(child: CircularProgressIndicator(),)
        :Form(
          key: _formKey,
          child: DiaryFormWidget(
              color: color,
              title: title,
              description: description,
              dateCreated: dateCreated,
              onChangedTitle: (titleChanged) {
                validateFields();
                return setState(() => this.title = titleChanged);
              },
              onChangedDescription: (description) {
                validateFields();
                return setState(
                  () => this.description = description,
                );
              }, onChangeColor: (int value) {
                print(color);
                validateFields();
                return setState(
                  () => color = value,
                );
              },),
        ),
      );

  void validateFields() {
    if (title.isNotEmpty && description.isNotEmpty) {
      _btnEnabled = true;
    }
    buildButton(_btnEnabled);
  }

  Widget buildButton(bool valid) {
    if (valid) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: addOrUpdateDiary,
          child: Text(
            'Save',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void addOrUpdateDiary() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.diaryContent != null;
      if (isUpdating) {
        await updateDiary();
      } else {
        await addDiary();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(id, color);
    final diary = widget.diaryContent!.returnID(
      title: title,
      description: description,
    );
    await DatabaseHelper.instance.updateDiary(diary);
  }

  Future addDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final diary = Diary(
        title: title, description: description, dateCreated: DateTime.now());
    int returnID = await DatabaseHelper.instance.createDiary(diary);
    print(returnID);
    prefs.setInt(returnID.toString(), color);
  }
}
