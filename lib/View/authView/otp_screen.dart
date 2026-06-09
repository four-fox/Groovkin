import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerification extends StatefulWidget {
  OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final formKeySignIn = GlobalKey<FormState>();

  final otp = PinInputController();

  final AuthController _controller = Get.find();

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    var theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(Routes.loginScreen);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.loginScreen);
            },
            child: ImageIcon(
              const AssetImage('assets/backArrow.png'),
              size: 32,
              color: theme.primaryColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Verification",
            style: poppinsMediumStyle(
              fontSize: 16,
              color: DynamicColor.lightYellowClr,
              context: context,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formKeySignIn,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * .05,
                    ),
                    Image.asset("assets/logo.png"),
                    SizedBox(
                      height: h * .10,
                    ),
                    Text("We have sent a 4-digit OTP to your email.",
                        style: poppinsMediumStyle(
                            color: Colors.white,
                            fontSize: h * .018,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialPinField(
                      length: 4,
                      pinController: otp,
                      onCompleted: (v) async {
                        print("in on complete");
                        FocusScope.of(context).unfocus();
                      },
                      autoDismissKeyboard: true,
                      theme: MaterialPinTheme(
                        shape: MaterialPinShape.filled,
                        fillColor:
                            DynamicColor.yellowClr.withValues(alpha: 0.7),
                        filledFillColor:
                            DynamicColor.yellowClr.withValues(alpha: 0.7),
                        focusedFillColor:
                            DynamicColor.yellowClr.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                        borderColor: DynamicColor.whiteClr,
                        filledBorderColor: DynamicColor.whiteClr,
                        focusedBorderColor: DynamicColor.whiteClr,
                        borderWidth: 1,
                        errorBorderColor: Theme.of(context).colorScheme.error,
                        textStyle: TextStyle(
                            color: DynamicColor.whiteClr, fontSize: 15),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: "Verify",
                      onTap: () async {
                        if (otp.text.isEmpty || otp.text.length != 4) {
                          bottomToast(text: "Please enter the 4-digit OTP");
                        } else {
                          await _controller.verifyEmailOtp(otp.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _circularCountDownTimerWidget() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: CircleAvatar(
  //       // backgroundColor: Colors.transparent,
  //       backgroundColor: DynamicColor.yellowClr,
  //       radius: 0.15,
  //       child: CircularCountDownTimer(
  //         duration: _duration.inSeconds,
  //         initialDuration: 0,
  //         controller: _countDownController,
  //         width: 0.28,
  //         height: 0.28,
  //         ringColor: Colors.transparent,
  //         backgroundColor: DynamicColor.yellowClr,
  //         fillColor: DynamicColor.whiteClr,
  //         strokeWidth: 4.0,
  //         strokeCap: StrokeCap.round,
  //         textStyle: TextStyle(
  //           fontSize: 15.0,
  //           color: DynamicColor.whiteClr,
  //         ),
  //         textFormat: CountdownTextFormat.MM_SS,
  //         isReverse: true,
  //         isReverseAnimation: true,
  //         isTimerTextShown: true,
  //         autoStart: true,
  //         onStart: () {
  //           debugPrint('Countdown Started');
  //         },
  //         onComplete: () {
  //           setState(() {
  //             isTimeComplete = true;
  //           });
  //           debugPrint('Countdown Ended');
  //         },
  //       ),
  //     ),
  //   );
  // }
}
