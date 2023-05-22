import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitRoomPage extends StatelessWidget {
  const WaitRoomPage({
    super.key,
    required this.roomID,
    required this.hero,
  });

  final String roomID;
  final int hero;

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
                      title: Text(roomID),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          Clipboard.setData(ClipboardData(text: roomID))
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
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Hello"),
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
