import 'package:flutter/material.dart';
import 'package:onlinebooksadmin/request.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<String> _contents = <String>['Requests', 'Write'];

class _HomeScreenState extends State<HomeScreen> {


  int _currentIndex = 0;
  _onTapItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _myBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.redAccent,
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
        title: const Text('E-book Admin'),
        backgroundColor: Colors.redAccent,
      ),
      body: BottomNavContents(
        index: _currentIndex,
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
    return Container(
      child: Center(
        child: navBarContents(index, context),
      ),
    );
  }

  Widget navBarContents(int index, BuildContext context) {
    switch (index) {
      case 0:
        return RequestScreen();
      case 1:
        return Text('coming soon');
    }
  }
}