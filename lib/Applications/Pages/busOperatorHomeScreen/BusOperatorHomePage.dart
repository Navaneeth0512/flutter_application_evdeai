// ignore: file_namesimport 'package:evde_ai/Application/Cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_button.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/core/icon_color.dart';
import 'package:gap/gap.dart';

class Busoperatorhomepage extends StatelessWidget {
  const Busoperatorhomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  height: 110,
                  width: 110,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.blue, Colors.purple]),
                      shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: backGroundColor),
                        child: const GradientIcon(
                          size: 50,
                        )),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'NO BUSES CONNECTED YET!',
              style: TextStyle(
                  color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Save your bus to have full access on your\nbus and enjoy our features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Tap the "Save your bus" button below\nto get started.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 200,
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/addbuspage');
                },
                text: 'Add your bus',
                boxDecoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.purple,
                    ], end: Alignment.centerRight, begin: Alignment.centerLeft),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 60,
                width: double.infinity,
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: backGroundColor)),
            Gap(5),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/buslistpage');
                },
                text: 'Garage',
                boxDecoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.purple,
                    ], end: Alignment.centerRight, begin: Alignment.centerLeft),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 60,
                width: double.infinity,
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: backGroundColor))
          ],
        ),
      ),
    );
  }
}
