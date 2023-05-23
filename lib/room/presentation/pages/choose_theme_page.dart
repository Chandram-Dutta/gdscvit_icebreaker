import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/main.dart';
import 'package:gdscvit_icebreaker/room/presentation/controllers/choose_theme_page_controller.dart';
import 'package:gdscvit_icebreaker/room/presentation/pages/wait_room_page.dart';

class ChooseThemePage extends ConsumerStatefulWidget {
  const ChooseThemePage({super.key});

  @override
  ConsumerState<ChooseThemePage> createState() => _ChooseThemePageState();
}

class _ChooseThemePageState extends ConsumerState<ChooseThemePage> {
  int hero = 0;
  @override
  Widget build(BuildContext context) {
    final AsyncValue<String> state =
        ref.watch(chooseThemePageControllerProvider);
    ref.listen<AsyncValue>(
      chooseThemePageControllerProvider,
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
                  isOwner: true,
                  hero: hero,
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
        title: const Text('Choose Theme'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
            ),
            children: [
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 1');
                        hero = 1;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 1',
                  hero: 1,
                ),
              ),
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 2');
                        hero = 2;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 2',
                  hero: 2,
                ),
              ),
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 3');
                        hero = 3;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 3',
                  hero: 3,
                ),
              ),
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 4');
                        hero = 4;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 4',
                  hero: 4,
                ),
              ),
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 5');
                        hero = 5;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 5',
                  hero: 5,
                ),
              ),
              GestureDetector(
                onTap: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(chooseThemePageControllerProvider.notifier)
                            .createRoomAndAddUser(roomType: 'Theme 6');
                        hero = 6;
                      },
                child: const ChooseThemeCard(
                  title: 'Theme 6',
                  hero: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseThemeCard extends StatelessWidget {
  const ChooseThemeCard({
    super.key,
    required this.title,
    required this.hero,
  });

  final String title;
  final int hero;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: hero,
      child: Container(
        alignment: Alignment.center,
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
              blurRadius: 20,
            ),
          ],
        ),
        child: Text(title),
      ),
    );
  }
}
