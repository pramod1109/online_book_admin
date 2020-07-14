import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {

  final databaseReference = Firestore.instance;

  void _onPressed(String col, String author, String des, String story, String title, String id) {
    databaseReference.collection(col).add(
        {
          "author" : author,
          "likes": 0,
          "share": 0,
          "story": story,
          "reads": 0,
          "title": title
        }).then((value){
      print(value.documentID);
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
                                    onPressed: (){_onPressed(ds['category'], ds['author'], ds['description'], ds['story'], ds['title'], ds.documentID);},
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: RaisedButton(
                                    child: Text("Reject"),
                                    onPressed: () {_delete(ds.documentID);},
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
        appBar: AppBar(
          title: Text("Story"),
          backgroundColor: Colors.redAccent,

        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Text("Title:"+'\n'+story['title']+'\n\n\n'+"Category:"+'\n'+story['category']+'\n\n\n'+"Description:"+'\n'+story['description']+'\n\n\n'+"Story:"),
                Html(data: story['story'],)
              ],
            )
          ),
        )
    );
  }
}
