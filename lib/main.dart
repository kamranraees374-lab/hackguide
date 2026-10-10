import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AdService.init();
  runApp(const HackGuideApp());
}

class HackGuideApp extends StatelessWidget {
  const HackGuideApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HackGuide',
      theme: ThemeData.dark(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == null) return const LoginPage();
        return const Shell();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool busy = false;
  String? error;
  Future<void> signIn() async {
    setState(() { busy = true; error = null; });
    try {
      final g = GoogleSignIn();
      final gu = await g.signIn();
      if (gu == null) { setState(() => busy = false); return; }
      final ga = await gu.authentication;
      final cred = GoogleAuthProvider.credential(accessToken: ga.accessToken, idToken: ga.idToken);
      final user = (await FirebaseAuth.instance.signInWithCredential(cred)).user!;
      final p = await SharedPreferences.getInstance();
      await p.setString('name', user.displayName ?? 'Learner');
      await p.setString('photo', user.photoURL ?? '');
    } catch (e) {
      setState(() => error = 'Login failed: $e');
    }
    setState(() => busy = false);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('HACKGUIDE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
      const SizedBox(height: 20),
      if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: busy ? null : signIn, child: Text(busy ? 'Please wait...' : 'Continue with Google')),
    ])),
  );
}
