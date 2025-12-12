import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/questionnaire_result.dart';

class ResultsRepository {
  ResultsRepository._internal();

  static final ResultsRepository instance = ResultsRepository._internal();

  factory ResultsRepository() => instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuestionnaireResult> createAndSaveResult({
    required String uid,
    required double score,
    required Map<String, String> answers,
  }) async {
    final now = DateTime.now().toUtc();

    final collection = _firestore
        .collection('users')
        .doc(uid)
        .collection('results');

    final docRef = collection.doc();

    await docRef.set({
      'score': score,
      'answers': answers,
      'createdAt': now,
    });

    return QuestionnaireResult(
      id: docRef.id,
      score: score,
      answers: answers,
      createdAt: now,
    );
  }

  Stream<List<QuestionnaireResult>> watchResults(String uid) {
    final query = _firestore
        .collection('users')
        .doc(uid)
        .collection('results')
        .orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        final scoreValue = data['score'];
        final answersValue = data['answers'];
        final createdValue = data['createdAt'];

        double score = 0;
        if (scoreValue is num) {
          score = scoreValue.toDouble();
        }

        Map<String, String> answers = {};
        if (answersValue is Map) {
          answers = answersValue.map((key, value) {
            return MapEntry(key.toString(), value.toString());
          });
        }

        DateTime createdAt;
        if (createdValue is Timestamp) {
          createdAt = createdValue.toDate();
        } else if (createdValue is DateTime) {
          createdAt = createdValue;
        } else {
          createdAt = DateTime.now().toUtc();
        }

        return QuestionnaireResult(
          id: doc.id,
          score: score,
          answers: answers,
          createdAt: createdAt,
        );
      }).toList();
    });
  }
}
