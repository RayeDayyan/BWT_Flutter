import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_7_buddyup/models/post_model.dart';

class PostController {
  int getRandomNumber() {
    var random = Random();
    int randomNumber = random.nextInt(10000);
    return randomNumber;
  }

  final store = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<String?> uploadImage(XFile image) async {
    int usage = getRandomNumber();

    final fireStore =
        FirebaseStorage.instance.ref().child('PostPictures/$usage');

    try {
      final file = File(image.path);

      await fireStore.putFile(file);

      String imageURL = await fireStore.getDownloadURL();

      return imageURL;
    } catch (e) {
      print('error occured : $e');
      return null;
    }
  }

  Future<bool> createPost(Post post) async {
    try {
      final query = await store.collection('Posts').doc();
      final docID = query.id;

      Map<String, dynamic> json = post.toJson();
      json['postID'] = docID;
      await store.collection('Posts').doc(docID).set(json);

      return true;
    } catch (e) {
      print('error occured : $e');
      return false;
    }
  }

  Future<List<Post>?> getAllPosts() async {
    try {
      var data = await store.collection('Posts').get();

      final list = (data.docs as List).map((item) {
        return Post.fromJson(item.data());
      }).toList();

      return list;
    } catch (e) {
      print('error occured : $e');
      return null;
    }
  }

  Future<List<Post>?> getMyPosts() async {
    try {
      final uid = auth.currentUser!.uid;
      var data = await store
          .collection('Posts')
          .where('creatorID', isEqualTo: uid)
          .get();

      final list = (data.docs as List).map((item) {
        return Post.fromJson(item.data());
      }).toList();

      return list;
    } catch (e) {
      print('error occured : $e');
      return null;
    }
  }

  Future<List<Post>?> getSearchResults(String searchWord) async {
    try {
      var lowerCaseSearch = searchWord.toLowerCase();

      var data = await store.collection('Posts').get();

      var filteredResults = data.docs.where((item) {
        var helper = item.data() as Map<String, dynamic>;
        var helper2 = helper['type'].toLowerCase();
        return helper2.contains(lowerCaseSearch);
      }).toList();

      var finalResults = filteredResults.map((item) {
        return Post.fromJson(item.data());
      }).toList();

      return finalResults;
    } catch (e) {
      print('error occured : $e');
      return null;
    }
  }

  Future<void> setMembers(int participants, String postID) async {
    try {
      if (postID != null) {
        await store.collection('Posts').doc(postID).set({
          'currentParticipants': participants,
        }, SetOptions(merge: true));
      }
      return;
    } catch (e) {
      print('error occured');
      return;
    }
  }
}
