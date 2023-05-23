import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/game/repository/game_repository.dart';

class FirebaseGameRepository extends GameRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _roomCollection;

  FirebaseGameRepository() {
    _roomCollection = _firestore.collection('rooms');
  }

  @override
  Future<void> changeJoinable({
    required String roomId,
    required bool joinable,
  }) async {
    await _roomCollection.doc(roomId).update({
      'joinable': joinable,
    });
  }

  @override
  Future changeNextChoosable({
    required String roomId,
  }) async {
    final List<Map<String, dynamic>> listOfUsers =
        await _roomCollection.doc(roomId).collection('users').get().then(
              (value) =>
                  value.docs.map((e) => e.data() as Map<String, bool>).toList(),
            );
    final int index = listOfUsers.indexWhere((element) => element['choose']);
    try {
      final String userId = listOfUsers[index]['id'];
      final String newUserId = listOfUsers[index + 1]['id'];
      await _roomCollection
          .doc(roomId)
          .collection('users')
          .doc(newUserId)
          .update({
        'choose': true,
      });
      await _roomCollection.doc(roomId).collection('users').doc(userId).update({
        'choose': false,
      });
    } catch (e) {
      return Exception('No more users left');
    }
  }

  @override
  Future<void> changePrompt({
    required String roomId,
    required String prompt,
  }) async {
    await _roomCollection.doc(roomId).update({
      'prompt': prompt,
    });
  }
}

final firebaseGameRepositoyProvider = Provider<GameRepository>((ref) {
  return FirebaseGameRepository();
});
