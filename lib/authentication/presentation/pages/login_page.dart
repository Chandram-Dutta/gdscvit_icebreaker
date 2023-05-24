import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/presentation/controllers/login_page_controller.dart';
import 'package:gdscvit_icebreaker/home/presentation/pages/signedin_landing_page.dart';
import 'package:gdscvit_icebreaker/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool fade = true;
  void delay() {
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
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(loginPageControllerProvider);
    ref.listen<AsyncValue>(
      loginPageControllerProvider,
      (_, state) {
        if (!state.isRefreshing && state.hasError) {
          print(state.error.toString());
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text("Error"),
              content: Text(state.error.toString()),
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else if (!state.isLoading && state.hasValue) {
          Navigator.pushAndRemoveUntil(
            context,
            createRoute(
              page: const SignedInLandingPage(),
            ),
            (route) => false,
          );
        }
      },
    );
    return Scaffold(
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
          padding: const EdgeInsets.only(
            top: 200,
            left: 20,
            right: 20,
          ),
          child: Hero(
            tag: 'second-box',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  crossFadeState: fade
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: const SizedBox(),
                  secondChild: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        Text(
                          "Hi There,",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const Text("Access your account"),
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  width: 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  width: 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  width: 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 50,
                                    child: FilledButton(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => ref
                                              .read(loginPageControllerProvider
                                                  .notifier)
                                              .signInWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: state.isLoading
                                          ? const CupertinoActivityIndicator()
                                          : const Text("Login"),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: FilledButton(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => ref
                                              .read(loginPageControllerProvider
                                                  .notifier)
                                              .signUpWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                name: _nameController.text,
                                              ),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: state.isLoading
                                          ? const CupertinoActivityIndicator()
                                          : const Text("Sign Up"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text("Or"),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: FilledButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.onBackground,
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.background,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text("Login With GitHub"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: FilledButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.onBackground,
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.background,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text("Login With Apple"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
