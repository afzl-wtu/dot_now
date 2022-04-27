import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'main_screen.dart';
import '../widgets/large_round_button.dart';
import 'sign_in.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  static final _pageDecoration = PageDecoration(
    footerPadding: const EdgeInsets.only(left: 24, right: 24, top: 110),
    titleTextStyle:
        GoogleFonts.nunito(fontSize: 20, color: Colors.grey.shade700),
    bodyTextStyle: GoogleFonts.zillaSlab(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.grey.shade600,
    ),
  );

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<PageViewModel> _pages = [];
  @override
  void initState() {
    _pages = [
      PageViewModel(
          title: 'SHOPPING FROM HOME',
          image: SvgPicture.asset('assets/svg/landing_page/Ilustration.svg'),
          decoration: LandingPage._pageDecoration,
          body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
      PageViewModel(
          title: 'ORIGNAL PRODUCTS',
          image: SvgPicture.asset('assets/svg/landing_page/Ilustration-1.svg'),
          decoration: LandingPage._pageDecoration,
          body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
      PageViewModel(
          footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signInAnonymously();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(),
                      ),
                    );
                  },
                  child: const LargeRoundButton(
                      color: Colors.deepOrange, text: 'Guest'),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SignInPage(),
                    ),
                  ),
                  child: const LargeRoundButton(
                      color: Colors.blue, text: 'Sign In'),
                ),
              ],
            ),
          ),
          useScrollView: false,
          title: 'EXPRESS DELIVERY',
          image: SvgPicture.asset('assets/svg/landing_page/Illustration.svg'),
          decoration: LandingPage._pageDecoration,
          body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IntroductionScreen(
        dotsDecorator: DotsDecorator(
          activeSize: const Size(25, 9),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        skipStyle: ButtonStyle(
          foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.grey),
        ),
        skip: const Text('SKIP'),
        showSkipButton: true,
        onDone: () {},
        done: const LargeRoundButton(
          color: Colors.transparent,
          text: 'Lakh di Lannat',
        ),
        next: const LargeRoundButton(
          color: Colors.blue,
          text: 'Next',
        ),
        pages: _pages,
      ),
    );
  }
}
