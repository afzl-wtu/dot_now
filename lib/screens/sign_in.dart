import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';

import '../widgets/sliding_animation.dart';
import '../widgets/large_round_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_header.dart';

enum Auth { signIn, signUp, passwordReset }

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  static const _style = TextStyle(color: Colors.white);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  Auth _authType = Auth.signIn;
  bool _isWaitingForOTP = false;
  String _verificationId = '';

  final _phoneNumber = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _pin = TextEditingController();

  Future<void> _phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  void _otpCompleted() async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pin.text);
    await _auth.signInWithCredential(_credential);
    print('PP:Phone verification Completed');
  }

  void _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    if (kDebugMode) {
      print("verification completed ${authCredential.smsCode}");
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (authCredential.smsCode != null) {
      try {
        if (user != null) {
          await user.linkWithCredential(authCredential);
        } else {
          await _auth.signInWithCredential(authCredential);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          if (kDebugMode) {
            print('PP: In provider-already linked exception');
          }
          await _auth.signInWithCredential(authCredential);
        }
      }
    }
  }

  void _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      if (kDebugMode) {
        print('Invalid Phone Number');
      }
    }
  }

  void _onCodeSent(String verificationId, int? forceResendingToken) {
    _isWaitingForOTP = true;
    _verificationId = verificationId;
    setState(() {});
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void _getOTP() async {
    final String a = '+92' + _phoneNumber.text.substring(1);
    await _phoneSignIn(phoneNumber: a);
  }

  Future<String?>? _signWithGoogle() async {
    final GoogleSignInAccount googleUser =
        (await GoogleSignIn(scopes: <String>["email"]).signIn())!;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      return 'Error occured';
    }
  }

  Future<String?>? _signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    try {
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      return 'Error Ocured';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoginHeader(
              button: TextButton(
                onPressed: () => setState(() {
                  _authType == Auth.signIn
                      ? _authType = Auth.signUp
                      : _authType = Auth.signIn;
                }),
                child: Text(
                  _authType == Auth.signIn ? 'Sign Up' : 'Sign In',
                  style: _style,
                ),
              ),
              heading: _authType == Auth.signIn
                  ? 'Sign In'
                  : _authType == Auth.signUp
                      ? 'Sign Up'
                      : 'Reset Password',
              body: _authType == Auth.signIn
                  ? 'Welcome back, we are glad to see you back.'
                  : _authType == Auth.signUp
                      ? 'Welcome on-board. Please fill required info.'
                      : 'Finally resetting your Password!',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 75, horizontal: 20),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Phone Number',
                      controller: _phoneNumber,
                      suffix: _authType == Auth.signIn
                          ? null
                          : TextButton(
                              onPressed: _getOTP,
                              child: const Text(
                                'Get OTP',
                                style: TextStyle(color: Colors.pink),
                              ),
                            ),
                    ),
                    if (_isWaitingForOTP)
                      const SizedBox(
                        height: 10,
                      ),
                    SlidingAnimation(
                        child: Pinput(
                          length: 6,
                          controller: _pin,
                          onSubmitted: (s) {
                            print('PP: onSubmitted, $s');
                          },
                          onCompleted: (s) {
                            _otpCompleted();
                          },
                        ),
                        active: _isWaitingForOTP),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: _password,
                      label: 'Password',
                      isPassword: true,
                    ),
                    if (_authType == Auth.signUp)
                      const SizedBox(
                        height: 10,
                      ),
                    SlidingAnimation(
                        active: _authType != Auth.signIn,
                        child: CustomTextField(
                          controller: _confirmPassword,
                          label: 'Confirm Password',
                          isPassword: true,
                        )),
                    if (_authType == Auth.signIn)
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.pink),
                                ))
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    LargeRoundButton(
                        fullLength: true,
                        color: const Color(0xFF126881),
                        text:
                            (_authType == Auth.signUp) ? 'Sign Up' : 'Sign In'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Or Sign in with social media',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SignInButton(
                      Buttons.Google,
                      elevation: 0,
                      onPressed: _signWithGoogle,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      elevation: 0,
                      onPressed: _signInWithFacebook,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
