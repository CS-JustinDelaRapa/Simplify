import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

// ignore: must_be_immutable
class AddPostForm extends StatefulWidget {
  String? title;
  String? description;
  String? postUid;  

  BuildContext? contextFromPopUp;
  
  AddPostForm({Key? key, this.description, this.title, this.postUid, this.contextFromPopUp}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isProcessing = false;

  //input holder
 late String? _postUid;
 late String _title, _description;
 late BuildContext _currentContext; 

//upload to firebase
 String _publisherSchool = '';
 String _publisherFirstName = '';
 String _publisherLastName = '';
 String _publisherUserIcon = '';

//null right hand operand

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _description = widget.description ?? '';
    _postUid = widget.postUid ?? null;
    _currentContext = widget.contextFromPopUp ?? this.context;
    getInfo(_auth.currentUser!.uid);
  }

  Future getInfo(String publisherUid) async {
  FirebaseFirestore.instance
        .collection('users')
        .doc(publisherUid)
        .get().then((value) {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Write Post'),
        actions: [ _isProcessing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  )
          :TextButton(
              onPressed: () async {                           
                if (_addItemFormKey.currentState!.validate()) {
                  //if Creating a new post
                  if(widget.postUid == null){
                    await AuthService().addItem(
                    _title,
                    _description,
                    _publisherSchool,
                    _publisherFirstName,
                    _publisherLastName,
                    _publisherUserIcon                    
                  );
                  }
                  //if editing a new post
                  else{
                    await AuthService().updateItem(
                      _title,
                      _description,
                      _postUid!,
                    );
                  } 
                  
                  setState(() {
                    _isProcessing = true;
                  });
                  Navigator.of(_currentContext).pop();
                }
              },
            child: Text('Post', style: TextStyle(color: Colors.white,))
          )
        ],
      ),
      body: SingleChildScrollView(
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
                  ),
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Required Title' : null,
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
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Brief and clear explanation',
                    labelText: 'Description',
                    border: InputBorder.none, 
                  ),
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Required Description' : null,
                  onChanged: (value) {
                    setState(() {
                      _description = value.trim();
                    });
                  },
                ),
              ),            
            ],
          ),
        ),
      ),
      );
  }
}
