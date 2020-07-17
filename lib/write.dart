import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:onlinebooksadmin/home.dart';

import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  List<String> _category = ['కథలు','కవితలు','సంపాదకీయం','భావ స్పందన','గ్రంథ సమీక్ష','బాలతరంగిణి','హాస్యం','నవలలు','బాల సాహిత్యం','బాల వ్యాఖ్య','నానీలు','చిత్ర వ్యాఖ్య', 'చిత్ర కథ', 'భావగీతం', 'చిత్ర కవిత', 'కార్టూన్ వ్యాఖ్య','సరదా సమాధానాలు'];
  String _selectedCategory;
  String imageUrl;

  File _image;

  Future<String> pickImage() async {
    //Get the file from the image picker and store it
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=pickedFile;
    });
  }

  Future<String> _uploadFile() async {
    try {
      final StorageReference storageRef = FirebaseStorage.instance.ref().child(_titleController.text +"images/");
      final StorageUploadTask task = storageRef.putFile(_image);
      return await (await task.onComplete).ref.getDownloadURL();
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
  }

  Future<void> _next() async {
    imageUrl = await _uploadFile();
    print("The download URL is " + imageUrl);
    // Waits till the file is uploaded then stores the download url
    if(imageUrl != null){
      final snackBar =
      SnackBar(content: Text('Image Uploaded'));
      Scaffold.of(context).showSnackBar(snackBar);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(title: _titleController.text,cat: _selectedCategory,imageUrl: imageUrl,user: 'admin')),);
    }
  }

  Widget _buildCategoryTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(
                  color: Colors.grey[800].withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(1.0,0)// changes position of shadow
              ),]
          ),
          height: 60.0,
          child: Row(
            children: <Widget>[
              SizedBox(width: 10.0,),
              DropdownButtonHideUnderline(child:DropdownButton<String>(
                hint: Text("Select Your Category                           ",
                ),
                dropdownColor: Colors.grey.withOpacity(0.8),
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: _category.map((category) {
                  return DropdownMenuItem(
                    child: new Text(category),
                    value: category,
                  );
                }).toList(),
              ),)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(
                  color: Colors.grey[800].withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(1.0,0)// changes position of shadow
              ),]
          ),
          height: 60.0,
          child: TextField(
            controller: _titleController,
            keyboardType: TextInputType.text,
            autofocus: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14.0),
              hintText: 'Title',

            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _next,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            color: Colors.redAccent.withOpacity(0.8),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Write Your Post',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      _buildCategoryTF(),
                      SizedBox(height: 10.0,),
                      _buildTitleTF(),
                      SizedBox(height: 10.0,),
                      // _buildDesTF(),
                      SizedBox(height: 10.0,),
                      _image == null ? RaisedButton(
                        child: Text(
                            "Image"
                        ),
                        textColor: Colors.redAccent,
                        onPressed: pickImage,
                      ):Column(
                        children: <Widget>[
                          Image.file(_image),
                          RaisedButton(child: Text('Change Image'),textColor: Colors.redAccent,onPressed: pickImage,)
                        ],
                      ),
                      _buildNextBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditorPage extends StatefulWidget {
  final cat;
  final title;
  final imageUrl;
  final user;
  EditorPage({@required this.cat,this.title,this.imageUrl,this.user});
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {

  /// Allows to control the editor and the document.
  ZefyrController _controller;
  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;
  String docUrl;
  final converter = NotusHtmlCodec();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(16),
            controller: _controller,
            focusNode: _focusNode,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  /// Loads the document asynchronously from a file if it exists, otherwise
  /// returns default document.
  Future<NotusDocument> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file
          .readAsString()
          .then((data) => Future.delayed(Duration(seconds: 1), () => data));
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    StorageReference reference = FirebaseStorage.instance.ref().child(widget.title+"stories/");
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly:
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents).then((_) async {
      StorageUploadTask uploadTask = reference.putFile(file);
      String html = converter.encode(_controller.document.toDelta());
      _pushToCloud(html);
    });
  }

  final databaseReference = Firestore.instance;
  void _pushToCloud(String html) {
    print(_controller);
    databaseReference.collection(widget.cat).add(
        {
          "imageUrl" :widget.imageUrl,
          "author" : 'admin',
          "story": html,
          "title": widget.title,
          "likes": [],
          "share": 0,
          "reads": 0,
        }).then((value){
      print(value.documentID);
    });
    _showMyDialog();
    // if(databaseReference.collection('request').document(id).get()!=null)
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your write is uploaded'),
                Text('Would you like to approve?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
              },
            ),
          ],
        );
      },
    );
  }

}


