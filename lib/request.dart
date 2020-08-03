// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:onlinebooksadmin/notif.dart';
import 'package:onlinebooksadmin/storage.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {

  final databaseReference = Firestore.instance;

  Future<void> _approveDialog(String col, String author, String story, String title, String id, String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This writing is approved'),
                Text('Please do conform'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Undo'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                _onPressed(col, author, story, title, id, url);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onPressed(String col, String author, String story, String title, String id, String url) async {
    await databaseReference.collection('categories').document(col).collection('books').document(id).setData(
        {
          "author" : author,
          "likes": [],
          "share": 0,
          "story": story,
          "reads": 0,
          "title": title,
          "book_id": id,
          "imageUrl" : url
        });
    Storage.catsMap[col]['subscription'].forEach((u) async {
      await NotificationHandler.instance.sendMessage('New Book in $col', 'There is a new book added in your favourite catogory $col', Storage.usersMap[u]['notif_token']);
    });
    _approve(author, story, title, id, url);
    _delete(id);
  }

  _approve(String author, String story, String title, String id, String url) async{
    databaseReference.collection("approve").add(
        {
          "author" : author,
          "story": story,
          "title": title,
          "book_id": id,
          "imageUrl" : url
        }).then((value){
//      //print(value.documentID);
    });
  }

  Future<void> _rejectDialog(String author, String story, String title, String id, String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This writing is approved'),
                Text('Please do conform'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Undo'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('reject'),
              onPressed: () {
                _reject(author, story, title, id, url);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _reject(String author, String story, String title, String id, String url) async{
    databaseReference.collection("reject").add(
        {
          "author" : author,
          "story": story,
          "title": title,
          "book_id": id,
          "imageUrl" : url
        }).then((value){
//      //print(value.documentID);
    });
    _delete(id);
  }

  _delete(String doc) async {
    await databaseReference
        .collection('request')
        .document(doc)
        .delete();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('request').snapshots(),
        builder: (BuildContext content, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return new CircularProgressIndicator();
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context ,index){
              DocumentSnapshot ds = snapshot.data.documents[index];
              return Card(
                shadowColor: Colors.redAccent.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: ds['imageUrl'] != null ? Image.network(ds['imageUrl']) : Icon(Icons.album),
                        title: new Text(ds['title']),
                        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>Story(story: ds)));},
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            ds['author']  != null ? Text("Author: "+ds['author']) : SizedBox(height: 3.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    child: Text("Approve"),
                                    onPressed: (){_approveDialog(ds['category'], ds['author'], ds['story'], ds['title'], ds.documentID, ds['imageUrl']);},
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: RaisedButton(
                                    child: Text("Reject"),
                                    onPressed: () {_rejectDialog(ds['author'], ds['story'], ds['title'], ds.documentID, ds['imageUrl']);},
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
  }



}

class Story extends StatelessWidget {

  final story;

  Story({@required this.story});

  @override
  Widget build(BuildContext context) {
    print("read");
    return Scaffold(
        appBar: new AppBar(
          title: Image.asset('assets/images/Logo_Bhavatarangini.png',fit: BoxFit.contain, height: 64,
          ),
          backgroundColor: Color(0xff61A4F1),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Text("Title:"+'\n'+story['title']+'\n\n\n'+"Category:"+'\n'+story['category']+'\n\n\n'+"Story:"),
                Html(data: story['story'],)
              ],
            )
          ),
        )
    );
  }
}
