import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userDataStream;

  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _userDataStream = _firestore.collection('users').doc(_user.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
        style: TextStyle(color:Color(0xFFFDF4F5) )),
        backgroundColor: Color(0xFF2A2F4F),
      ),
      body: Container(
        color:Color(0xFF917FB3),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _userDataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Tampilkan loading indicator jika data masih dimuat
              }
      
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text(
                    'User data not found!'); // Tampilkan pesan jika data pengguna tidak ditemukan
              }
      
              var userData = snapshot.data!;
      
              _displayNameController.text = userData.get('displayName');
              _cityController.text = userData.get('city');
              _tanggalLahirController.text = userData.get('tanggal_lahir');
      
              return Column(
                children: <Widget>[
                  TextField(
                    controller: _displayNameController,
                    decoration: InputDecoration(labelText: 'Display Name'),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'City'),
                  ),
                  TextField(
                    controller: _tanggalLahirController,
                    decoration: InputDecoration(labelText: 'Birthdate'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Panggil fungsi untuk update data pengguna di Firestore
                      await _updateUserData();
      
                      // Kembali ke halaman profil setelah perubahan disimpan
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF917FB3)),),
                    child: Text('Save',
                    style: TextStyle(color: Color(0xFFFDF4F5)),),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    // Update data pengguna di Firestore
    await _firestore.collection('users').doc(_user.uid).update({
      'displayName': _displayNameController.text,
      'city': _cityController.text,
      'tanggal_lahir': _tanggalLahirController.text,
    });
  }
}
