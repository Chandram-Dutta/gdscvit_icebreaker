import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/presentation/controllers/landing_page_controller.dart';
import 'package:gdscvit_icebreaker/authentication/presentation/pages/login_page.dart';
import 'package:gdscvit_icebreaker/home/presentation/pages/signedin_landing_page.dart';
import 'package:gdscvit_icebreaker/main.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> state = ref.watch(landingPageControllerProvider);
    ref.listen<AsyncValue>(
      landingPageControllerProvider,
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
              page: const SignedInLandingPage(),
            ),
          );
        }
      },
    );
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
                "Get Started",
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
                  ],
                ),
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
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: FilledButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              ref
                                  .read(landingPageControllerProvider.notifier)
                                  .signInWithGoogle();
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
                      child: state.isLoading
                          ? CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onBackground,
                            )
                          : const Text(
                              "Login With Google",
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: state.isLoading
                        ? null
                        : () => Navigator.push(
                              context,
                              createRoute(
                                page: const LoginPage(),
                              ),
                            ),
                    child: Text(
                      "Other Options to Login",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
