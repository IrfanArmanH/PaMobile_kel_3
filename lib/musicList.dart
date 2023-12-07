import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_pa/Screens/musicScreen.dart';
import 'package:test_pa/Screens/uploadSong.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  // int currentIndex = 0;

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future getData() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("songs").get();
    return qn.docs;
  }

  Future<void> addPlaylist(
      String artist, String songName, String url, String userId) async {
    try {
      // Mendapatkan referensi ke koleksi "playlists" di Firestore
      CollectionReference playlistCollection =
          _firestore.collection('playlist');

      // Menambahkan lagu ke playlist
      await playlistCollection.add({
        'artist': artist,
        'songName': songName,
        'songUrl': url,
        'userId': userId
      });

      // Menampilkan pesan sukses (opsional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Song added to playlist!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding song to playlist: $e');
      // Menampilkan pesan error (opsional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding song to playlist. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title: Text(
            'Music List',
            style: TextStyle(
              color: Color(0xFFFDF4F5),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF2A2F4F),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      //upload song fab button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadSong()),
          );
        },
        backgroundColor: Color(0xFF917FB3),
        child: const Icon(Icons.add),
      ),
      
      body: Container(
        color: Color(0xFF917FB3),
        child: FutureBuilder(
          
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
                                    snapshot.data[index].data()['song_name'],
                                    snapshot.data[index].data()['url'])),
                          );
                        },
                        child: listSong(
                            snapshot.data[index].data()['artist'],
                            snapshot.data[index].data()['song_name'],
                            snapshot.data[index].data()['url']),
                      );
                    });
              }
            }),
      ),
    );
  }

  Widget listSong(String artistName, String songName, String url) {
    return ListTile(
      //tileColor: Color(0xffD9D9D9),
      leading: const CircleAvatar(
          backgroundColor: Color(0xFF2A2F4F),
          child: Icon(Icons.music_note,
              size: 25, color: Color(0xFF917FB3))),
      title: Text(songName),
      subtitle: Text(artistName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFF2A2F4F),
            child: Icon(Icons.play_arrow_rounded, color: Colors.white),
          ),
          const SizedBox(width: 8), // Spacer
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Mengganti userId dengan userId yang sesuai, bisa didapatkan dari FirebaseAuth
              String userId = _auth.currentUser?.uid ?? 'defaultUserId';

              // Menggunakan fungsi addPlaylist
              addPlaylist(artistName, songName, url, userId);
            },
          ),
        ],
      ),
    );
  }
}
