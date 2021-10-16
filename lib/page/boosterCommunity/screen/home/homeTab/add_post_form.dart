import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  //input holder
  String _title = '',
        _description = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Write Post'),
        actions: [           _isProcessing
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
                  await AuthService().addItem(
                    _title,
                    _description,
                  );
                  setState(() {
                    _isProcessing = false;
                  });
                  Navigator.of(context).pop();
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
