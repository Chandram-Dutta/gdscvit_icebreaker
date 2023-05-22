import 'package:flutter/material.dart';
import 'package:gdscvit_icebreaker/main.dart';
import 'package:gdscvit_icebreaker/room/presentation/pages/choose_theme_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
