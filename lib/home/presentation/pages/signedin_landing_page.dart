import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/presentation/pages/landing_page.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';
import 'package:gdscvit_icebreaker/home/presentation/pages/home_page.dart';
import 'package:gdscvit_icebreaker/main.dart';

class SignedInLandingPage extends ConsumerWidget {
  const SignedInLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: AlignmentDirectional.topStart,
          //   end: AlignmentDirectional.bottomEnd,
          //   colors: [
          //     Theme.of(context).colorScheme.primary,
          //     Theme.of(context).colorScheme.secondary,
          //     Theme.of(context).colorScheme.tertiary,
          //   ],
          // ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "AISPY",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background,
                    shadows: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.75),
                        blurRadius: 20,
                      ),
                    ]),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 50,
                      child: Hero(
                        tag: 'first-box',
                        child: Container(
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
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 50,
                      child: Hero(
                        tag: 'second-box',
                        child: Container(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          createRoute(
                            page: const HomePage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onBackground,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.background,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text("Play"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: FilledButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.error,
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.onError,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await ref
                                    .watch(firebaseAuthRepositoryProvider)
                                    .signOut();
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    createRoute(
                                      page: const LandingPage(),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Logout"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: FilledButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.onBackground,
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.background,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Settings"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
