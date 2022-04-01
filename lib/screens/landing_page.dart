import 'package:dot_now/widgets/round_large_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:introduction_screen/introduction_screen.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  static final _pageDecoration = PageDecoration(
    footerPadding: EdgeInsets.only(left: 24, right: 24, top: 160),
    titleTextStyle:
        GoogleFonts.nunito(fontSize: 20, color: Colors.grey.shade700),
    bodyTextStyle: GoogleFonts.zillaSlab(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.grey.shade600,
    ),
  );
  final List<PageViewModel> _pages = [
    PageViewModel(
        title: 'SHOPPING FROM HOME',
        image: SvgPicture.asset('assets/svg/landing_page/Ilustration.svg'),
        decoration: _pageDecoration,
        body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
    PageViewModel(
        title: 'ORIGNAL PRODUCTS',
        image: SvgPicture.asset('assets/svg/landing_page/Ilustration-1.svg'),
        decoration: _pageDecoration,
        body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
    PageViewModel(
        footer: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              RoundLargeButton(color: Colors.deepOrange, text: 'Guest'),
              RoundLargeButton(color: Colors.blue, text: 'Sign In'),
            ],
          ),
        ),
        title: 'EXPRESS DELIVERY',
        image: SvgPicture.asset('assets/svg/landing_page/Illustration.svg'),
        decoration: _pageDecoration,
        body: 'asjdfkasjfkas askdjfklsladj askdjfd aksjd akkd akdsa'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IntroductionScreen(
        dotsDecorator: DotsDecorator(
            activeSize: const Size(25, 9),
            activeShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
        skipStyle: ButtonStyle(
          foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.grey),
        ),
        skip: const Text('SKIP'),
        showSkipButton: true,
        onDone: () {
          print('PP: OnDone');
        },
        done: const RoundLargeButton(
          color: Colors.transparent,
          text: 'Lakh di Lannat',
        ),
        next: const RoundLargeButton(
          color: Colors.blue,
          text: 'Next',
        ),
        pages: _pages,
      ),
    );
  }
}
