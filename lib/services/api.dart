import 'dart:async';

import 'package:agridex/models/sheep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// TODO: Pull out auth / make singleton.
class SheepApi {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseUser firebaseUser;

  SheepApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<SheepApi> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return new SheepApi(user);
  }

  Sheep _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    // TODO: Firestore field name changes:
    // TODO: id -> external_id, image_url -> avatar_url, adopted -> is_adopted.
    return new Sheep(
        documentId: snapshot.documentID,
        eid: data['eid'],
        sex: data['sex'],
        birth: data['birth'],
        visualNum: data['visualNum'],
        fleece: new List<Object>.from(data['fleece']),
        pregnancies: new List<Object>.from(data['pregnancies']),
        weights: new List<Object>.from(data['weights'])
        );
  }

  Future<List<Sheep>> getAllSheep() async {
    return (await Firestore.instance.collection('sheep').getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(Sheep sheep, void onChange(Sheep sheep)) {
    return Firestore.instance
        .collection('sheep')
        .document(sheep.documentId)
        .snapshots
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }
}
