import 'package:dot_now/screens/main_screen.dart';
import 'package:dot_now/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:vxstate/vxstate.dart';

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
  bool _otpClicked = false;
  bool _codeTimeOut = false;
  bool _showCountDown = false;
  bool _isOTPVerified = false;
  bool _isSignButtonPressed = false;
  String _verificationId = '';

  final fToast = FToast();
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

  @override
  void initState() {
    super.initState();
    fToast.init(context);

    _phoneNumber.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumber.removeListener(() {});
    _phoneNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _otpCompleted() async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pin.text);
    try {
      await _auth.signInWithCredential(_credential);
      await FirebaseAuth.instance.signOut();
      setState(() {
        _isOTPVerified = true;
        _isWaitingForOTP = false;
      });
    } on FirebaseAuthException catch (e) {
      fToast.showToast(
        child: Text(e.code),
      );
    }
  }

  void _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    setState(() {
      _otpClicked = false;
    });
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
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          if (kDebugMode) {
            print('PP: In provider-already linked exception');
          }
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        _isOTPVerified = true;
        _isWaitingForOTP = false;
      });
    }
  }

  void _onVerificationFailed(FirebaseAuthException exception) {
    setState(() {
      _otpClicked = false;
    });
    if (exception.code == 'invalid-phone-number') {
      if (kDebugMode) {
        print('Invalid Phone Number');
      }
    }
  }

  void _onCodeSent(String verificationId, int? forceResendingToken) {
    setState(() {
      _otpClicked = false;
      _showCountDown = true;
      _isWaitingForOTP = true;
      _verificationId = verificationId;
    });
  }

  _onCodeTimeout(String timeout) {
    setState(() {
      _codeTimeOut = true;
      _showCountDown = false;
    });
    return null;
  }

  void _getOTP() async {
    setState(() {
      _otpClicked = true;
    });
    final String a = '+92' + _phoneNumber.text.substring(1);
    await _phoneSignIn(phoneNumber: a);
  }

  Future<void> _signButton() async {
    setState(() {
      _isSignButtonPressed = true;
    });
    final _authStore = (VxState.store as MyStore).auth;
    final String a = '+92' + _phoneNumber.text.substring(1);
    if (_isOTPVerified &&
        _password.text == _confirmPassword.text &&
        _authType == Auth.signUp) {
      await _authStore.signUpWithPhonePassword(a, _password.text);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }

    if (a.length == 14 &&
        _password.text.isNotEmpty &&
        _authType == Auth.signIn) {
      await _authStore.signInWithPhonePassword(a, _password.text);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
    setState(() {
      _isSignButtonPressed = false;
    });
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
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      return 'Error occured';
    }
    return null;
  }

  Future<void> _signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(loginBehavior: LoginBehavior.nativeWithFallback);

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Phone Number',
                            controller: _phoneNumber,
                          ),
                        ),
                        if (_authType == Auth.signIn ||
                            _phoneNumber.text.length != 12)
                          Container()
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _otpClicked
                                ? const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.pink,
                                    ),
                                  )
                                : _isOTPVerified
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.pink,
                                      )
                                    : _showCountDown
                                        ? CountdownTimer(
                                            widgetBuilder: (_,
                                                    CurrentRemainingTime?
                                                        time) =>
                                                time == null
                                                    ? const Text('Time is null')
                                                    : Text(
                                                        '00:${time.sec}',
                                                        style: const TextStyle(
                                                            color: Colors.pink),
                                                      ),
                                            textStyle: const TextStyle(
                                                color: Colors.pink),
                                            endTime: DateTime.now()
                                                    .microsecondsSinceEpoch +
                                                1000 * 30,
                                          )
                                        : TextButton(
                                            style: const ButtonStyle(
                                                splashFactory:
                                                    NoSplash.splashFactory),
                                            onPressed: _getOTP,
                                            child: Text(
                                              _codeTimeOut
                                                  ? 'Get OTP Again'
                                                  : 'Get OTP',
                                              style: const TextStyle(
                                                  color: Colors.pink),
                                            ),
                                          ),
                          ),
                      ],
                    ),
                    if (_isWaitingForOTP)
                      const SizedBox(
                        height: 10,
                      ),
                    SlidingAnimation(
                        child: Pinput(
                          length: 6,
                          controller: _pin,
                          onSubmitted: (s) {},
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
                    InkWell(
                      onTap: _isSignButtonPressed ? () {} : _signButton,
                      child: LargeRoundButton(
                          fullLength: true,
                          color: const Color(0xFF126881),
                          text: _isSignButtonPressed
                              ? 'Processing...'
                              : (_authType == Auth.signUp)
                                  ? 'Sign Up'
                                  : 'Sign In'),
                    ),
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
