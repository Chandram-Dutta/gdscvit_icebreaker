import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitRoomPage extends StatefulWidget {
  const WaitRoomPage({
    super.key,
    required this.roomID,
    required this.hero,
  });

  final String roomID;
  final int hero;

  @override
  State<WaitRoomPage> createState() => _WaitRoomPageState();
}

class _WaitRoomPageState extends State<WaitRoomPage> {
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
              onPressed: () {},
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
                            secondChild: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Hello"),
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
