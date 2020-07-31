import 'package:cloud_firestore/cloud_firestore.dart';

class Storage{
  static List<DocumentSnapshot> usersList = new List<DocumentSnapshot>();
  static Map<String,dynamic> usersMap = new Map<String,dynamic>();
  static Map<String,dynamic> catsMap = new Map<String,dynamic>();
}