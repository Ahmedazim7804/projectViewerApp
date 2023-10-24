import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final _firebase = FirebaseAuth.instance;
final _googleSignIn = GoogleSignIn( );

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? _enteredEmail;
  String? _enteredPassword;

  String? emailValidator(String? value) {
    if (value == null || !value.contains('@')) {
      return "Please Enter a valid email Address";
    } 
    if (value.substring(value.length - 4) != '.com' && value.substring(value.length - 4) != '.net' && value.substring(value.length - 6) != '.ac.in') {
      return "Only '.com', '.net' & '.ac.in' email addresses are allowed";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be 8 or more than 8 characters long.";
    }
    return null;
  }

  void submitForm() async {
    final bool dataIsValid = formkey.currentState!.validate();

    if (dataIsValid) {
      formkey.currentState!.save();
    }

    if (_isLoginMode) {
      loginWithEmailAndPassword();
    } else {
      signupWithEmailAndPassword();
    }
  }

  void loginWithEmailAndPassword() async {
    final auth = await _firebase.signInWithEmailAndPassword(email: _enteredEmail!, password: _enteredPassword!);
    print(auth);
  }

  void signupWithEmailAndPassword() async {
    final auth = await _firebase.createUserWithEmailAndPassword(email: _enteredEmail!, password: _enteredEmail!);
    print(auth);
  }

  void signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
    await _firebase.signInWithCredential(credential);
  }

  @override
  void dispose() {
    super.dispose();
    _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextFormField(
                            validator: emailValidator,
                            onSaved: (value) {_enteredEmail = value;},
                            decoration: const InputDecoration(prefixIcon: Icon(Icons.email), labelText: "Email")
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextFormField(
                            validator: passwordValidator,
                            onSaved: (value) {_enteredPassword = value;},
                            decoration: const InputDecoration(prefixIcon: Icon(Icons.password), labelText: "Password"), obscureText: true),
                        ),
                        const SizedBox(height: 16,),
                        ElevatedButton(onPressed: submitForm, child: Text(_isLoginMode ? "Login" : "Signup")),
                        TextButton(
                          onPressed: () {setState(() { _isLoginMode = !_isLoginMode;});}, 
                          child: Text(_isLoginMode ? "Create an account..." : "I already have an account...")),
                        const SizedBox(height: 50,),
                        ElevatedButton.icon(
                          onPressed: signInWithGoogle,
                          icon: const Icon(Icons.g_translate),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                          label: const Text("Sign in with Google")
                          )
                    ],
                  ))
                ),
              ),
            ],
        ),
      ),
    );
  }
}