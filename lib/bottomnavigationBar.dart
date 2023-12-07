import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_pa/Screens/musicList.dart';
import 'package:test_pa/Screens/playlist.dart';
import 'package:test_pa/user_profile.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;
  List<Widget> screens = [MusicList(), PlaylistScreen(), UserProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2A2F4F),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          //saya menggati tab bar menjadi cuppertino tab bar
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.double_music_note),
              label: "list music",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_albums),
              label: "playlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: "Pengaturan",
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return Center(
                child: screens.elementAt(currentIndex),
              );
            },
          );
        },
      ),
    );
  }
}
