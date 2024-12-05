import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // To hold the OTP input
  List<String> otp = ["", "", "", ""];
  bool isResendingOtp = false;
  bool isSubmittingOtp = false;
  int timeLeft = 30;

  @override
  void initState() {
    super.initState();
    // Start a timer to show countdown for OTP expiry
    startOtpTimer();
  }

  void startOtpTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
        startOtpTimer();
      }
    });
  }

  void onOtpChanged(String value, int index) {
    setState(() {
      otp[index] = value;
    });
  }

  void onSubmitOtp() {
    // Simulating OTP verification
    setState(() {
      isSubmittingOtp = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSubmittingOtp = false;
      });
      // Navigate to Home screen on success
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => BusOperatorHome()),
      );
    });
  }

  void onResendOtp() {
    setState(() {
      isResendingOtp = true;
      timeLeft = 30;
    });
    startOtpTimer();

    // Simulating resend OTP
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isResendingOtp = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Resent!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusOperatorHome(),
              ),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Icon(Icons.lock, size: 40, color: Colors.deepPurple),
                  const SizedBox(height: 20),
                  const Text(
                    "OTP",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please enter the code sent to your mobile number. Kindly check!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          onChanged: (value) {
                            onOtpChanged(value, index);
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "00:${timeLeft.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive?",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: isResendingOtp ? null : onResendOtp,
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepOrange,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    onPressed: isSubmittingOtp ? null : onSubmitOtp,
                    text: isSubmittingOtp ? "Loading..." : "Continue",
                    width: null, onTap: () {}, // Remove infinity width
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Need help?",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Contact support",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepOrange,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
