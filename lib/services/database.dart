import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  //string for user so that easier to render in screen but strength int because need to link with color on screen(something about intensity of coffee)
  Future updateUserData(String sugar, String name, int strength) async{
    return await brewCollection.document(uid).setData({
      'sugar' : sugar,
      'name' : name,
      'strength' : strength,
    });
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Brew(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugar: doc.data['sugar'] ?? '0'
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        sugar: snapshot.data['sugar'],
        strength: snapshot.data['strength']
    );
  }

  //get brew stream
Stream<List<Brew>> get brews{
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
}

  //get user doc stream
  Stream<UserData> get userData{
    return brewCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

}