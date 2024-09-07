import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_7_buddyup/controllers/services/user_controller.dart';
import 'package:task_7_buddyup/models/message_model.dart';
import 'package:task_7_buddyup/models/user_model.dart';

class MessageController {
  final fireStore = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  Future<String> getChatRoomID(String? otherUserID) async {
    String? user = auth.currentUser?.uid;

    if (otherUserID == null) {
      return 'the value provided was null';
    }

    final fireStore1 = fireStore.collection('chats');
    final query1 = await fireStore1.where('users', arrayContains: user).get();

    String? chatRoomID;

    for (var doc in query1.docs) {
      final users = doc.data()['users'];
      if (users.contains(otherUserID)) {
        chatRoomID = doc.data()['chatRoomID'];
        break;
      }
    }

    if (chatRoomID == null) {
      final query2 = fireStore1.doc();
      chatRoomID = query2.id;

      await query2.set({
        'chatRoomID': chatRoomID,
        'users': [user, otherUserID],
      });
    }

    return chatRoomID;
  }

  Future<bool> addMessage(String chatID, Message message) async {
    try {
      await fireStore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add(message.toJson());
      return true;
    } catch (e) {
      print('error occured');
      return false;
    }
  }

  Stream<List<Message>> getMessages(String chatID) {
    try {
      final query = fireStore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots();

      final result = query.map((item) {
        return (item.docs as List).map((item1) {
          return Message.fromJson(item1.data());
        }).toList();
      });

      return result;
    } catch (e) {
      print('error occured while fetching messages');
      return Stream.value([]);
    }
  }

  Stream<List<UserModel>> getInboxUsers() {
    try {
      String uid = auth.currentUser!.uid;
      final query = fireStore
          .collection('chats')
          .where('users', arrayContains: uid)
          .snapshots();

      final users = query.asyncMap((snapshot) async {
        List<UserModel> users = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();
          data['users'].remove(uid);
          final otherUserID = data['users'][0];

          final otherUserData =
              await UserController().getOtherUserData(otherUserID);
          users.add(otherUserData);
        }

        return users;
      });

      return users;
    } catch (e) {
      print('error occured while fetching inbox users');
      return Stream.value([]);
    }
  }
}
