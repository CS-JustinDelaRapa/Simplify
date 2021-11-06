import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import '../../../../../algo/globals.dart' as globals;

// ignore: must_be_immutable
class AddPostForm extends StatefulWidget {
  String? title;
  String? description;
  String? postCategory;
  String? postUid;

  BuildContext? contextFromPopUp;

  AddPostForm(
      {Key? key,
      this.description,
      this.title,
      this.postCategory,
      this.postUid,
      this.contextFromPopUp})
      : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isProcessing = false;

  final List<String> category = [
    'Computer & Technology',
    'Science & Health',
    'Business Management',
    'Mathematics & Engineering',
    'English Literature',
    'Others'
  ];

  //input holder
  late String? _postUid;
  late String _title, _description; //, _category;
  late BuildContext _currentContext;

//upload to firebase
  String _publisherSchool = '';
  String _publisherFirstName = '';
  String _publisherLastName = '';
  String _publisherUserIcon = '';
  String _publisherPostCategory = '';

//null right hand operand

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _description = widget.description ?? '';
    // _category = widget.postCategory ?? '';
    _postUid = widget.postUid ?? null;
    _currentContext = widget.contextFromPopUp ?? this.context;
    getInfo(_auth.currentUser!.uid);
  }

  Future getInfo(String publisherUid) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(publisherUid)
        .get()
        .then((value) {
      setState(() {
        _publisherSchool = value.get('school');
        _publisherFirstName = value.get('first-name');
        _publisherLastName = value.get('last-name');
        _publisherUserIcon = value.get('userIcon');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.indigo.shade600,
          title: Text('Write Post'),
          actions: [
            _isProcessing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      //check if fields is not empty
                      if (_addItemFormKey.currentState!.validate()) {
                        //check for profanity
                        final profanityCheck =
                            ProfanityFilter.filterAdditionally(
                                globals.badWordsList);
                        bool hasProfanity = profanityCheck
                            .hasProfanity(_title + ' ' + _description);
                        if (hasProfanity) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Profanity Check"),
                                    content: Text(
                                        "Seems like your post contains inapropriate or improper words, Please consider reconstructiong your post."),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                        } else {
                          if (widget.postUid == null) {
                            await AuthService().addItem(
                                _title,
                                _description,
                                _publisherSchool,
                                _publisherFirstName,
                                _publisherLastName,
                                _publisherUserIcon,
                                _publisherPostCategory);
                          }
                          //if editing a new post
                          else {
                            await AuthService().updateItem(
                              _title,
                              _description,
                              _postUid!,
                              _publisherPostCategory,
                            );
                          }

                          setState(() {
                            _isProcessing = true;
                          });
                          Navigator.of(_currentContext).pop();
                        }
                      }
                    },
                    child: Text('Post',
                        style: TextStyle(
                          color: Colors.white,
                        )))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
          child: SingleChildScrollView(
            child: Form(
              key: _addItemFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      initialValue: _title,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'An Interesting Title',
                          labelText: 'Title',
                          labelStyle: TextStyle(
                              height: 3,
                              fontSize: 14,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)))),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Title'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _title = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      initialValue: _description,
                      maxLines: 5,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          hintText: 'Brief and clear explanation',
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                              height: 3,
                              fontSize: 14,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)))),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Description'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _description = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              height: 3,
                              fontSize: 14,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)))),
                      validator: (value) =>
                          value == null ? 'Required Post Category' : null,
                      isDense: true,
                      hint: Text('Post Category'),
                      isExpanded: true,
                      items: category.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _publisherPostCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
