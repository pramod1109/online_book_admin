import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendScreen extends StatefulWidget {
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {

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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();

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
              _showMyDialog('Title');
            }
            return null;
          },
        ));
  }

  Widget _buildMsg() {
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child:TextFormField(
          controller: _msgController,
          maxLength: 25,
          decoration: InputDecoration(labelText: 'Message'),
          validator: (String value) {
            if (value.isEmpty) {
              _showMyDialog('Message');
            }
            return null;
          },
        ));
  }

  Widget _buildSendBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){},
        color:  Color(0xff61A4F1).withOpacity(0.8),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Send',
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
                      _buildTitle(),
                      SizedBox(height: 10.0,),
                      _buildMsg(),
                      _buildSendBtn(),
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