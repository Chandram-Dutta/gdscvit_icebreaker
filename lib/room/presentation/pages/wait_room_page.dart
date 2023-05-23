import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/firebase_room_repository.dart';

class WaitRoomPage extends ConsumerStatefulWidget {
  const WaitRoomPage({
    super.key,
    required this.roomID,
    required this.hero,
    required this.isOwner,
  });

  final String roomID;
  final int hero;
  final bool isOwner;

  @override
  ConsumerState<WaitRoomPage> createState() => _WaitRoomPageState();
}

class _WaitRoomPageState extends ConsumerState<WaitRoomPage> {
  bool isVisible = true;

  void delay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isVisible = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: const Text('Room'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.error,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onError,
                ),
              ),
              onPressed: () async {
                ref.read(firebaseRoomRepositoryProvider).leaveRoom(
                      roomId: widget.roomID,
                      userId: ref
                          .watch(firebaseAuthRepositoryProvider)
                          .currentUser!
                          .uid,
                    );
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.call_end),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(widget.roomID),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          Clipboard.setData(ClipboardData(text: widget.roomID))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to your clipboard !'),
                              ),
                            );
                          });
                        },
                      ),
                      subtitle: const Text("Room ID"),
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: widget.hero,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 500),
                            crossFadeState: isVisible
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: const SizedBox(),
                            secondChild: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FirestoreListView<Map<String, dynamic>>(
                                shrinkWrap: true,
                                query: ref
                                    .watch(firebaseRoomRepositoryProvider)
                                    .getRoomUsers(
                                      roomId: widget.roomID,
                                    ),
                                itemBuilder: (context, snapshot) {
                                  return ListTile(
                                    leading: snapshot.data()['roomOwner']
                                        ? const Icon(Icons.diamond_rounded)
                                        : null,
                                    title: Text(snapshot.data()['name']),
                                    trailing: widget.isOwner &&
                                            snapshot.data()['id'] ==
                                                ref
                                                    .watch(
                                                        firebaseAuthRepositoryProvider)
                                                    .currentUser!
                                                    .uid
                                        ? ElevatedButton(
                                            onPressed: () {},
                                            child: const Text("Start"),
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
