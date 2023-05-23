import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/home/presentation/controller/join_room_controller.dart';
import 'package:gdscvit_icebreaker/main.dart';
import 'package:gdscvit_icebreaker/room/presentation/pages/choose_theme_page.dart';

import '../../../room/presentation/pages/wait_room_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool fade = true;
  final TextEditingController _roomIDController = TextEditingController();
  void delay() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        fade = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    delay();
  }

  @override
  void dispose() {
    _roomIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String> state = ref.watch(joinRoomControllerProvider);
    ref.listen<AsyncValue>(
      joinRoomControllerProvider,
      (_, state) {
        if (!state.isRefreshing && state.hasError) {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text("Error"),
              content: const Text("An error occured. Please try again later."),
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else if (!state.isLoading && state.hasValue) {
          Navigator.pushReplacement(
            context,
            createRoute(
              page: WillPopScope(
                onWillPop: () async => false,
                child: WaitRoomPage(
                  isOwner: false,
                  hero: 0,
                  roomID: state.value,
                ),
              ),
            ),
          );
        }
      },
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'first-box',
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Enter room ID"),
                            content: TextField(
                              decoration: const InputDecoration(
                                hintText: "Room ID",
                              ),
                              controller: _roomIDController,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => ref
                                    .read(joinRoomControllerProvider.notifier)
                                    .joinRoom(
                                      roomId: _roomIDController.text,
                                    ),
                                child: const Text("Join"),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.75),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 50),
                      crossFadeState: fade
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: const SizedBox(
                        height: 200,
                        width: 200,
                      ),
                      secondChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Join",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const Text("a room"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Hero(
                tag: 'second-box',
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        page: const ChooseThemePage(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.75),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500),
                      crossFadeState: fade
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: const SizedBox(
                        height: 200,
                        width: 200,
                      ),
                      secondChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const Text("a room"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
