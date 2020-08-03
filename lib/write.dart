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
  String name;
  File _image;


  @override
  void initState() {
    super.initState();
  }



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
      //print(error.toString());
    }
  }

  Future<void> _showMyDialog(String mis) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$mis field is left empty'),
                Text('Please do update it'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _noImageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Image field is left empty'),
                Text('Do you want update it or continue'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(title: _titleController.text,cat: _selectedCategory,imageUrl: null,user: name)),);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _next() async {
    if(_selectedCategory == null){
      _showMyDialog("Category");
    }
    if(_selectedCategory != null && _titleController.text.isEmpty )
    {
      _showMyDialog('Title');
    }
    if(_image!=null){
      imageUrl = await _uploadFile();
//    //print("The download URL is " + imageUrl);
      if(imageUrl != null){
        final snackBar =
        SnackBar(content: Text('Image Uploaded'));
        Scaffold.of(context).showSnackBar(snackBar);
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(title: _titleController.text,cat: _selectedCategory,imageUrl: imageUrl,user: name)),);
      }
    }
    if(_selectedCategory != null && _titleController.text.isNotEmpty && _image == null){
      _noImageDialog();
    }
    // Waits till the file is uploaded then stores the download url
  }

  Widget _buildCategoryTF() {
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: DropdownButton(
                hint: _selectedCategory == null
                    ? Text('Category')
                    : Text(
                  _selectedCategory,
                  style: TextStyle(color: Colors.black),
                ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.blue),
                items: _category.map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      _selectedCategory = val;
                    },
                  );
                },
              ),
            ),
          ],
        )

    );
  }

  Widget _buildTitle() {
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child:TextFormField(
          controller: _titleController,
          maxLength: 15,
          decoration: InputDecoration(labelText: 'Title'),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Name is Required';
            }
            return null;
          },
        ));
  }

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _next,
        color:  Color(0xff61A4F1).withOpacity(0.8),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
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
                        'ఇక్కడ వ్రాయండి',
                        style: TextStyle(
                          color: Color(0xff61A4F1),
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      _buildCategoryTF(),
                      SizedBox(height: 10.0,),
                      _buildTitle(),
                      SizedBox(height: 10.0,),
                      // _buildDesTF(),
                      SizedBox(height: 10.0,),
                      _image == null ? IconButton(
                        icon: Icon(Icons.add_a_photo),
                        tooltip: 'Pick Image',
                        onPressed: pickImage,
                        iconSize: 75.0,
                      ):Stack(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: 200,
                            child: Image.file(_image,fit: BoxFit.cover,),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              tooltip: 'Pick Image',
                              onPressed: (){
                                setState(() {
                                  _image=null;
                                });
                              },
                              iconSize: 15.0,
                            ),
                          )
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
  EditorPage({@required this.title,this.cat,this.imageUrl,this.user});
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
  File file;
  final contents=null;

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
        title: Image.asset('assets/images/Logo_Bhavatarangini.png',fit: BoxFit.contain, height: 64,
        ),
        backgroundColor: Color(0xff61A4F1),
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
    file = File(Directory.systemTemp.path + "/quick_start.json");
    final Delta delta = Delta()..insert("మీ రచనను ఇక్కడ రాయండి\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    StorageReference reference = FirebaseStorage.instance.ref().child(widget.title+"stories/");
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly:
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents).then((_) async {
      StorageUploadTask uploadTask = reference.putFile(file);
      String html = converter.encode(_controller.document.toDelta());
      _pushToCloud(html);
    });
  }

  final databaseReference = Firestore.instance;
  void _pushToCloud(String html) async {
//    //print(_controller);
    databaseReference.collection('categories').document(widget.cat).collection('books').add(
        {
          "imageUrl" :widget.imageUrl,
          "author" : widget.user,
          "story": html,
          "category" : widget.cat,
          "title": widget.title,
          "likes": [],
          "share": 0,
          "reads": 0,
        }).then((value) async{
//      //print(value.documentID);
      docUrl=value.documentID;
    });
    await databaseReference.collection('categories').document(widget.cat).collection('books').document(docUrl).updateData({
      "book_id": docUrl,
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
                Text('Confirm Submission'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  _controller=null;
                  file=null;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
              },
            ),
          ],
        );
      },
    );
  }

}



