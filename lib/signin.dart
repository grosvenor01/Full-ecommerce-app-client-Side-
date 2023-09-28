import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});
  @override
  State<Signin> createState() => _SignupState();
}
late String email;
late String password;
class _SignupState extends State<Signin> {
  final auth = FirebaseAuth.instance;
  final googlesignin = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    final googleUser = await googlesignin.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 14, top: 18),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Metropolis-medium"),
                )),
            const SizedBox(
              height: 100,
            ),
            inputcont("Email"),
            inputcont("*********"),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width - 230, top: 10),
              child: Row(children: [
                const Text(
                  "You don't have an account",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Metropolis-medium"),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/signup");
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors. transparent,
                    backgroundColor: Colors.transparent,

                    elevation: 0
                  ),
                  child: const Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xFFDB3022),
                  )
                )
              ]),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var user = await auth.signInWithEmailAndPassword(email: email, password: password);
                      Navigator.pushNamed(context, "/nav");
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                        left: 150, right: 150, top: 20, bottom: 20),
                    backgroundColor: Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                const Text("Or sign up with social account"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        googleLogin().then((_) {
                          Navigator.pushNamed(context, "/nav");
                          // You can also check if the user is already signed in using FirebaseAuth.instance.currentUser.
                        }).catchError((error) {
                          // Handle any errors that occur during the Google Sign-In process.
                          print("Google Sign-In Error: $error");
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, elevation: 0,
                          shadowColor: Colors.transparent),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/google.png"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Spacer(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget inputcont(String label) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
    padding: EdgeInsets.only(left: 20),
    height: 64,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(4)),
    child: Center(
      child: TextField(
        onChanged: (value) {
          if (label == "Email") {
            email = value;
          } else {
            password = value;
          }
        },
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            fillColor: Colors.white),
      ),
    ),
  );
}
