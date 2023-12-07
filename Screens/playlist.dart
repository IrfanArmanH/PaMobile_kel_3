import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_pa/Screens/musicScreen.dart';
import 'package:test_pa/Screens/uploadSong.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot qn = await FirebaseFirestore.instance
          .collection("playlist")
          .where('userId', isEqualTo: user.uid)
          .get();
      return qn.docs;
    }
    return []; // Jika tidak ada pengguna yang masuk, kembalikan list kosong
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: Text(
          'My Playlist',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffD2CEF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //upload song fab button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadSong()),
          );
        },
        backgroundColor: Color(0xffD2CEF6),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicScreen(
                          snapshot.data[index].data()['songName'],
                          snapshot.data[index].data()['songUrl'],
                        ),
                      ),
                    );
                  },
                  child: listPlaylist(
                    snapshot.data[index].data()['songName'],
                    snapshot.data[index].data()['artist'],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget listPlaylist(String songName, String artistName) {
    return ListTile(
      //tileColor: Color(0xffD9D9D9),
      leading: const CircleAvatar(
        backgroundColor: Color(0xffD9D9D9),
        child: Icon(Icons.music_note,
            size: 25, color: Color.fromARGB(255, 221, 46, 33)),
      ),
      title: Text(songName),
      subtitle: Text(artistName),
      trailing: const CircleAvatar(
        radius: 15,
        backgroundColor: Color.fromARGB(255, 221, 46, 33),
        child: Icon(Icons.play_arrow_rounded, color: Colors.white),
      ),
    );
  }
}
