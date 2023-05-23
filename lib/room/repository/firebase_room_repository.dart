import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/room/repository/room_repository.dart';

class FirebaseRoomRepository extends RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _roomCollection;

  FirebaseRoomRepository() {
    _roomCollection = _firestore.collection('rooms');
  }

  @override
  Future<String> createRoom({
    required String roomType,
  }) async {
    String prompt = "";
    switch (roomType) {
      case 'Animals':
        prompt = sceneryPrompts[Random().nextInt(sceneryPrompts.length)];
        break;
      case 'Scenery':
        prompt = animalPrompts[Random().nextInt(animalPrompts.length)];
        break;
      case 'Food':
        prompt = foodPrompts[Random().nextInt(foodPrompts.length)];
        break;
      case 'Tech':
        prompt = techPrompts[Random().nextInt(techPrompts.length)];
        break;
      case 'Space':
        prompt = spacePrompts[Random().nextInt(spacePrompts.length)];
        break;
      case 'Nature':
        prompt = naturePrompts[Random().nextInt(naturePrompts.length)];
        break;
      default:
        prompt = "";
    }

    final id = Random().nextInt(9999999) + 1000000;
    await _roomCollection.doc(id.toString()).set({
      'id': id,
      'type': roomType,
      'createdAt': FieldValue.serverTimestamp(),
      'room_state': 'joinable',
      'original_prompt': prompt,
      'present_prompt': prompt,
      'choosable_id': '',
      'choosable_index': -1,
      'choosable_name': '',
    });
    return id.toString();
  }

  @override
  Future<void> joinRoom({
    required String roomId,
    required String userId,
    required bool roomOwner,
    required String name,
  }) async {
    final noOfUsers = await _roomCollection
        .doc(roomId)
        .collection('users')
        .get()
        .then((value) => value.docs.length);
    if (noOfUsers < 4) {
      _roomCollection.doc(roomId).collection('users').doc(userId).set({
        'id': userId,
        'joinedAt': FieldValue.serverTimestamp(),
        'roomOwner': roomOwner,
        'name': name,
      });
      if (noOfUsers == 3) {
        await _roomCollection.doc(roomId).update({
          'room_state': 'playing',
        });
      }
    } else {
      await _roomCollection.doc(roomId).update({
        'joinable': 'playing',
      });
    }
  }

  @override
  Future<void> leaveRoom({
    required String roomId,
    required String userId,
  }) async {
    if (await _roomCollection
            .doc(roomId)
            .collection('users')
            .get()
            .then((value) => value.docs.length) ==
        1) {
      await _roomCollection.doc(roomId).delete();
    } else {
      if (await _roomCollection
              .doc(roomId)
              .collection('users')
              .doc(userId)
              .get()
              .then((value) => value.data()!['roomOwner']) ==
          true) {
        final users = await _roomCollection
            .doc(roomId)
            .collection('users')
            .get()
            .then((value) => value.docs);
        if (users.length > 1) {
          await _roomCollection
              .doc(roomId)
              .collection('users')
              .doc(users[1].id)
              .update({
            'roomOwner': true,
          });
        }
      }
      await _roomCollection
          .doc(roomId)
          .collection('users')
          .doc(userId)
          .delete();
    }
  }

  @override
  Query<Map<String, dynamic>> getRoomUsers({required String roomId}) {
    return _roomCollection.doc(roomId).collection('users').orderBy('joinedAt');
  }

  @override
  Stream<String> getJoinable({required String roomId}) {
    return _roomCollection.doc(roomId).snapshots().map(
          (event) => event["room_state"],
        );
  }

  @override
  Stream<DocumentSnapshot<Object?>> getRoomState({required String roomId}) {
    return _roomCollection.doc(roomId).snapshots();
  }
}

final firebaseRoomRepositoryProvider = Provider<FirebaseRoomRepository>((ref) {
  return FirebaseRoomRepository();
});

final getJoinableProvider =
    StreamProvider.family<String, String>((ref, roomId) {
  return ref.watch(firebaseRoomRepositoryProvider).getJoinable(roomId: roomId);
});

List<String> animalPrompts = [
  "A smiling turtle wearing a top hat and holding a cup of tea.",
  "A giraffe riding a bicycle through a city.",
  "Playful kitten chasing its own tail.",
  "A pattern featuring various colorful birds perched on branches.",
  "A wise owl wearing glasses and reading a book.",
  "A mischievous monkey swinging from vine to vine in a jungle.",
  "A friendly dolphin jumping out of the water.",
  "A cute cartoon character of a fluffy bunny with a carrot.",
  "A regal lion sitting majestically on a rock.",
  "A group of happy penguins sliding on an icy slope."
];

List<String> sceneryPrompts = [
  "A picturesque sunset over a calm lake surrounded by mountains.",
  "A serene beach with palm trees and clear blue water.",
  "A picture of a peaceful countryside with rolling green hills and a farmhouse.",
  "A vibrant cityscape at night with illuminated skyscrapers and busy streets.",
  "A majestic waterfall cascading down a lush forest.",
  "A tranquil garden with blooming flowers and a peaceful stone pathway.",
  "A snow-covered mountain range against a clear blue sky.",
  "A cozy cabin in the woods with a warm fireplace and snowy landscape.",
  "A breathtaking desert with sand dunes and a vibrant sunset.",
  "A magical forest with tall trees, sparkling fairy lights, and mystical creatures."
];

List<String> spacePrompts = [
  "A space-themed disco party on the moon with dancing aliens and funky music.",
  "A mischievous Martian playing pranks on astronauts on a spaceship.",
  "A pizza planet where pizzas grow on trees and aliens have pizza parties.",
  "An intergalactic race between rocket-powered snails with colorful trails behind them.",
  "A image of a space zoo with extraterrestrial animals showcasing their unique features.",
  "A cosmic bakery on a distant planet with pastries that glow and sparkle.",
  "A galactic surfing competition with surfboards riding solar waves.",
  "A group of friendly planets having a celestial tea party with moon-shaped teacups.",
  "An astronaut discovering a planet made entirely of cheese.",
  "A space carnival with zero-gravity rides and gravity-defying circus performances."
];

List<String> techPrompts = [
  "A futuristic flying car that runs on renewable energy and has a built-in holographic display.",
  "A robot chef cooking a gourmet meal with precision and creativity.",
  "A smart home where everyday objects are interconnected and controlled by voice commands.",
  "An augmented reality glasses that overlay digital information onto the real world in a playful and interactive way.",
  "A high-tech cityscape with advanced transportation systems and smart infrastructure.",
  "A wearable device that tracks emotions and transforms them into colorful visual representations.",
  "A robotic pet companion with artificial intelligence that can learn and interact like a real pet.",
  "A futuristic space station with advanced life support systems and zero-gravity recreation areas.",
  "A virtual reality gaming experience that allows players to fully immerse themselves in a fantasy world.",
  "A drone delivery system that transports packages with precision and efficiency, avoiding obstacles along the way."
];

List<String> foodPrompts = [
  "A delicious-looking burger with all the toppings and a side of fries.",
  "A colorful bowl of fresh fruit with a variety of berries and sliced bananas.",
  "A mouth-watering slice of pizza with melted cheese and pepperoni.",
  "A stack of fluffy pancakes topped with butter and maple syrup.",
  "A plate of spaghetti and meatballs with a side of garlic bread.",
  "A bowl of creamy macaroni and cheese with a golden brown crust.",
  "A plate of sushi with a variety of rolls and sashimi.",
  "A bowl of ramen with noodles, broth, and toppings.",
  "A plate of tacos with a variety of fillings and toppings.",
  "A bowl of pho with noodles, broth, and fresh herbs."
];

List<String> naturePrompts = [
  "A majestic eagle soaring through the sky.",
  "A group of colorful butterflies fluttering around a flower garden.",
  "A beautiful rainbow over a field of wildflowers.",
  "A curious squirrel peeking out from behind a tree.",
  "A playful otter swimming in a river.",
  "A cute hedgehog curled up in a ball.",
  "A fluffy bunny hopping through a meadow.",
  "A family of ducks swimming in a pond.",
  "A friendly deer with a flower crown.",
  "A group of happy bees buzzing around a beehive."
];
