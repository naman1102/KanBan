import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class KanbanFirebaseUser {
  KanbanFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

KanbanFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<KanbanFirebaseUser> kanbanFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<KanbanFirebaseUser>(
      (user) {
        currentUser = KanbanFirebaseUser(user);
        return currentUser!;
      },
    );
