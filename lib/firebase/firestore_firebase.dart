import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model_firebase/firebase/model_out_message.dart';

class FireStoreFirebase {
  FirebaseFirestore instance = FirebaseFirestore.instance;


  /*insert Data*/
  Future<OutMessage> insertData(
      String collectionName, Map<String, dynamic> map) async {
    try {
      await instance.collection(collectionName).add(map);
      return OutMessage(
        message: 'success added value',
        status: true,
      );
    } catch (e) {
      return OutMessage(
        message: 'failed added value : $e',
        status: false,
      );
    }
  }

  /*update Data*/
  Future<OutMessage> upDateData(
      String collectionName, Map<String, dynamic> map , String id) async {
    try {
      await instance.collection(collectionName).doc(id).update(map);
      return OutMessage(message: 'success update', status: true);
    } catch (e) {
      return OutMessage(message: 'failed update', status: false);
    }
  }
  /*delete Data*/
Future<OutMessage> deleteData( String collectionName , String id)async{
  try{
    await instance.collection(collectionName).doc(id).delete();
    return OutMessage(message: 'success deleted');
  }catch(e){
    return OutMessage(message: 'failed deleted : $e');
  }
}

  /*read data*/
   readData(String collectionName  ) async {
       instance.collection(collectionName).snapshots();
  }
}
