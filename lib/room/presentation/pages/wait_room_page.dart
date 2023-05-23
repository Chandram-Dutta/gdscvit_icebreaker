import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';
import 'package:gdscvit_icebreaker/constants.dart';
import 'package:gdscvit_icebreaker/game/repository/firebase_game_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/firebase_room_repository.dart';
import 'package:openai_dalle_wrapper/openai_dalle_wrapper.dart';

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
  final TextEditingController _controller = TextEditingController();

  void delay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    delay();
  }

  Future<String> getImage(String prompt) async {
    print('generating image');
    final openAi = OpenaiDalleWrapper(
      apiKey: openAIKey,
    );
    final imagePath = await openAi.generateImage(prompt);
    return imagePath;
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
      body: LayoutBuilder(builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        return Container(
          height: screenHeight,
          width: screenWidth,
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
                width: screenHeight,
                height: screenWidth,
                child: StreamBuilder(
                    stream: ref
                        .watch(firebaseRoomRepositoryProvider)
                        .getRoomState(roomId: widget.roomID),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (streamSnapshot.hasError) {
                        return const Center(
                          child:
                              Text("An error occured. Please try again later."),
                        );
                      }
                      return streamSnapshot.data!['room_state'] == 'ended'
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Original Prompt\n${streamSnapshot.data!['original_prompt']}",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Present Prompt:\n${streamSnapshot.data!['present_prompt']}",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                streamSnapshot.data!['room_state'] == "joinable"
                                    ? Card(
                                        child: ListTile(
                                          title: Text(widget.roomID),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.copy),
                                            onPressed: () async {
                                              Clipboard.setData(ClipboardData(
                                                      text: widget.roomID))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Copied to your clipboard !'),
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                          subtitle: const Text("Room ID"),
                                        ),
                                      )
                                    : const SizedBox(),
                                (streamSnapshot.data!['room_state'] ==
                                            "playing" &&
                                        streamSnapshot.data!['choosable_id'] ==
                                            ref
                                                .watch(
                                                    firebaseAuthRepositoryProvider)
                                                .currentUser!
                                                .uid)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground
                                                        .withOpacity(0.2),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: FutureBuilder(
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData
                                                        ? Image.network(snapshot
                                                            .data
                                                            .toString())
                                                        : const CircularProgressIndicator();
                                                  },
                                                  future: getImage(
                                                    streamSnapshot.data![
                                                        'present_prompt'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        "Guess The Image",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  controller: _controller,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await ref
                                                    .watch(
                                                        firebaseGameRepositoyProvider)
                                                    .changePrompt(
                                                      roomId: widget.roomID,
                                                      prompt: _controller.text,
                                                    );
                                                await ref
                                                    .watch(
                                                        firebaseGameRepositoyProvider)
                                                    .changeNextChoosable(
                                                      roomId: widget.roomID,
                                                    );
                                              },
                                              child: const Text(
                                                "Done Guessing?",
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                (streamSnapshot.data!['room_state'] ==
                                            "playing" &&
                                        streamSnapshot.data!['choosable_id'] !=
                                            ref
                                                .watch(
                                                    firebaseAuthRepositoryProvider)
                                                .currentUser!
                                                .uid)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 64.0,
                                        ),
                                        child: Text(
                                          "${streamSnapshot.data!['choosable_name']} is choosing. Wait for your turn.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : const SizedBox(),
                                streamSnapshot.data!['room_state'] ==
                                            "joinable" ||
                                        (streamSnapshot.data!['room_state'] ==
                                                "playing" &&
                                            streamSnapshot
                                                    .data!['choosable_id'] !=
                                                ref
                                                    .watch(
                                                        firebaseAuthRepositoryProvider)
                                                    .currentUser!
                                                    .uid)
                                    ? Expanded(
                                        child: Hero(
                                          tag: widget.hero,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Card(
                                              child: AnimatedCrossFade(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                crossFadeState: isVisible
                                                    ? CrossFadeState.showFirst
                                                    : CrossFadeState.showSecond,
                                                firstChild: const SizedBox(),
                                                secondChild: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FirestoreListView<
                                                      Map<String, dynamic>>(
                                                    shrinkWrap: true,
                                                    query: ref
                                                        .watch(
                                                            firebaseRoomRepositoryProvider)
                                                        .getRoomUsers(
                                                          roomId: widget.roomID,
                                                        ),
                                                    itemBuilder:
                                                        (context, snapshot) {
                                                      return ListTile(
                                                        leading: snapshot
                                                                    .data()[
                                                                'roomOwner']
                                                            ? const Icon(Icons
                                                                .diamond_rounded)
                                                            : null,
                                                        title: Text(snapshot
                                                            .data()['name']),
                                                        trailing: widget
                                                                    .isOwner &&
                                                                snapshot.data()[
                                                                        'id'] ==
                                                                    ref
                                                                        .watch(
                                                                            firebaseAuthRepositoryProvider)
                                                                        .currentUser!
                                                                        .uid &&
                                                                streamSnapshot
                                                                            .data![
                                                                        'room_state'] ==
                                                                    "joinable"
                                                            ? ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    await ref
                                                                        .watch(
                                                                          firebaseGameRepositoyProvider,
                                                                        )
                                                                        .changeNextChoosable(
                                                                          roomId:
                                                                              widget.roomID,
                                                                        );
                                                                    await ref
                                                                        .watch(
                                                                          firebaseGameRepositoyProvider,
                                                                        )
                                                                        .changeJoinable(
                                                                          roomId:
                                                                              widget.roomID,
                                                                          roomState:
                                                                              'playing',
                                                                        );
                                                                  } catch (e) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(e.toString()),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Start"),
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
                                      )
                                    : const SizedBox(),
                              ],
                            );
                    }),
              ),
            ),
          ),
        );
      }),
    );
  }
}
