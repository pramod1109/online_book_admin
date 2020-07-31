import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlinebooksadmin/notif.dart';
import 'package:onlinebooksadmin/request.dart';
import 'package:onlinebooksadmin/storage.dart';
import 'package:onlinebooksadmin/write.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<String> _contents = <String>['Requests', 'Write'];

class _HomeScreenState extends State<HomeScreen> {


  int _currentIndex = 0;

  bool gettingDetails = true;
  _onTapItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    await Firestore.instance.collection('user').getDocuments().then((value) {
      Storage.usersList = value.documents;
      Storage.usersList.forEach((element) {
        Storage.usersMap['${element.documentID}'] = element;
      });
    });
    await Firestore.instance.collection('categories').getDocuments().then((value) {
      value.documents.forEach((element) {
        Storage.catsMap['${element.documentID}'] = element;
      });
    });
    await NotificationHandler.instance.init(context);
    gettingDetails = false;
    setState(() {
    });
  }

  Widget _myBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Color(0xff61A4F1),
      unselectedItemColor: Colors.black.withOpacity(0.5),
      showUnselectedLabels: true,
      elevation: 100.0,
      onTap: _onTapItem,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text(_contents[0]),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mode_edit),
          title: Text(_contents[1]),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Image.asset('assets/images/Logo_Bhavatarangini.png',fit: BoxFit.contain, height: 64,
        ),
        backgroundColor: Color(0xff61A4F1),
      ),
      body: Stack(
        children: <Widget>[
          AbsorbPointer(
              absorbing: false,
              child: BottomNavContents(
                index: _currentIndex,
              )
          ),
          if(gettingDetails)
          LinearProgressIndicator()
        ],
      ),
      bottomNavigationBar: _myBottomNavBar(),
    );
  }
}

class BottomNavContents extends StatelessWidget {
  BottomNavContents({this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: navBarContents(index, context),
        ),
      ),
    );
  }

  Widget navBarContents(int index, BuildContext context) {
    switch (index) {
      case 0:
        return RequestScreen();
      case 1:
        return WriteScreen();
    }
  }
}