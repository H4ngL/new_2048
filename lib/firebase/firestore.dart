import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:logger/logger.dart';
import 'package:new_2048/firebase/firebase_auth.dart';

class FirestoreManager {
  List<dynamic> top10 = [];
  Logger logger = Logger();

  FirestoreManager() {
    listenTop10();
  }

  // best가 업데이트 될 때마다 firestore에 write
  Future<void> writeBest(int newValue) async {
    final user = AuthManager().currentUser();
    if (user != null) {
      final uid = user.uid;
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('scores').doc(uid);

      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        await docRef.update({
          'best': FieldValue.arrayUnion([newValue]),
        });
      } else {
        await docRef.set({
          'best': [newValue],
        });
      }
    }
  }

  // list 정리
  // List<dynamic> sortAndTrim(List<dynamic> inputArray) {
  //   inputArray.sort();
  //   inputArray = inputArray.reversed.toList();
  //   if (inputArray.length > 10) {
  //     inputArray.removeRange(10, inputArray.length);
  //   }
  //   return inputArray;
  // }

  // cloud function을 이용하여 firestore에서 데이터 가져오기
  // Future<List<dynamic>> callGetData(String uid) async {
  //   final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //     'getData',
  //   );

  //   try {
  //     final result = await callable.call({
  //       'uid': uid,
  //     });

  //     final data = result.data['data'] as Map<String, dynamic>;
  //     final best = data['best'] as List<dynamic>;
  //     return best;
  //   } catch (e) {
  //     logger.e('오류 발생: $e');
  //     rethrow;
  //   }
  // }

  // cloud function을 이용하여 list 정리
  // Future<List<dynamic>> callSortAndTrim(List<dynamic> inputArray) async {
  //   final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //     'sortAndTrim',
  //   );

  //   try {
  //     final result = await callable.call({
  //       'text': inputArray,
  //     });

  //     final List<dynamic> ret = result.data['text'];
  //     return ret;
  //   } catch (e) {
  //     logger.e('오류 발생: $e');
  //     rethrow;
  //   }
  // }

  // cloud function을 이용하여 firestore에서 top10 가져오기
  Future<List<dynamic>> callGetTop10(String uid) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getTop10',
    );

    try {
      final result = await callable.call({
        'uid': uid,
      });

      final List<dynamic> ret = result.data['data'];
      return ret;
    } catch (e) {
      logger.e('오류 발생: $e');
      rethrow;
    }
  }

  // sortAndTrim을 이용하여 firestore에서 best array를 업데이트
  // Future<void> updateBest() async {
  //   final user = AuthManager().currentUser();
  //   if (user != null) {
  //     final uid = user.uid;
  //     final DocumentReference docRef =
  //         FirebaseFirestore.instance.collection('scores').doc(uid);
  //     DocumentSnapshot snapshot = await docRef.get();
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final best = data['best'] as List<dynamic>;
  //       final newBest = sortAndTrim(best);
  //       await docRef.update({
  //         'best': newBest,
  //       });
  //     }
  //   }
  // }

  // firestore에서 best를 read
  Future<int> getBest() async {
    final user = AuthManager().currentUser();
    if (user != null) {
      final uid = user.uid;
      final newBest = await callGetTop10(uid);
      return newBest[0];
    } else {
      return 0;
    }
  }

  // top10에 변경이 있다면 firestore에서 read
  void listenTop10() {
    final user = AuthManager().currentUser();
    if (user != null) {
      final uid = user.uid;
      final docRef = FirebaseFirestore.instance.collection('scores').doc(uid);

      docRef.snapshots().listen((event) async {
        top10 = await callGetTop10(uid);
      });
    }
  }
}
