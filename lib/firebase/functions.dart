import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  List<dynamic> top10 = [];

  Firestore() {
    listenTop10();
  }

  // best가 업데이트 될 때마다 firestore에 write
  Future<void> writeScore(int newValue) async {
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('scores')
        .doc('NdIKPY56cwzROpA7RFYN');

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

    //await updateBest();
  }

  // list 정리
  List<dynamic> sortAndTrim(List<dynamic> inputArray) {
    inputArray.sort();
    inputArray = inputArray.reversed.toList();

    if (inputArray.length > 10) {
      inputArray.removeRange(10, inputArray.length);
    }

    return inputArray;
  }

  // sortAndTrim을 이용하여 firestore에서 best array를 업데이트
  Future<void> updateBest() async {
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('scores')
        .doc('NdIKPY56cwzROpA7RFYN');

    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final best = data['best'] as List<dynamic>;
      final newBest = sortAndTrim(best);
      await docRef.update({
        'best': newBest,
      });
    }
  }

  // best에 변경이 있다면 firestore에서 read
  void listenBest(int best) {
    final docRef = FirebaseFirestore.instance
        .collection('scores')
        .doc('NdIKPY56cwzROpA7RFYN');

    docRef.snapshots().listen((event) {
      final data = event.data() as Map<String, dynamic>;
      best = data['best'][0];
    });
  }

  // firestore에서 best를 read
  Future<int> getBest() async {
    final docRef = FirebaseFirestore.instance
        .collection('scores')
        .doc('NdIKPY56cwzROpA7RFYN');

    return await docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      final best = data['best'] as List<dynamic>;
      top10 = sortAndTrim(best);
      return top10[0];
    });
  }

  // top10에 변경이 있다면 firestore에서 read
  void listenTop10() {
    final docRef = FirebaseFirestore.instance
        .collection('scores')
        .doc('NdIKPY56cwzROpA7RFYN');

    docRef.snapshots().listen((event) {
      final data = event.data() as Map<String, dynamic>;
      final best = data['best'] as List<dynamic>;
      top10 = sortAndTrim(best);
      print(top10);
    });
  }

// // game record를 firestore에 write
// Future<void> addGameRecord(int score) async {
//   final CollectionReference bestScoresCollection =
//       FirebaseFirestore.instance.collection('player_scores');

//   await bestScoresCollection.add({
//     'score': score,
//     'timestamp': FieldValue.serverTimestamp(),
//   });
// }
}
