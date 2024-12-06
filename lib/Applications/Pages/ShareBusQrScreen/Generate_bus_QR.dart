// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:flutter_application_evdeai/Applications/core/colors.dart';
// import 'package:gap/gap.dart';
// import 'package:icons_plus/icons_plus.dart';

// class BusQrPage extends StatefulWidget {
//   final String busData; 
//   const BusQrPage({super.key, required this.busData});

//   @override
//   State<BusQrPage> createState() => _BusQrPageState();
// }

// class _BusQrPageState extends State<BusQrPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backGroundColor,
//       body: Padding(padding: EdgeInsets.all(30),
//       child: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
// Row(
//   children: [
//     IconButton(onPressed: (){
//       Navigator.pop(context);
//     }, icon: Icon(Icons.arrow_back)),
//     Gap(10),
//     Text('Share Your Bus',style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.bold),)
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     IconButton(onPressed: (){
//       Navigator.pushNamed(context, '/scanthebus');
//     }, icon: Icon(BoxIcons.bx_scan,size: 28,)),
//     Gap(20),
//     CircleAvatar(
//       child: IconButton(onPressed: (){}, icon: Icon(IonIcons.share_social,size: 24,)),
//     )
//   ],
// ),
// Gap(40),
// // Center(child: QrCodeWidget()),
//  QrImageView(
//    data: widget.busData, 
//    version: QrVersions.auto,
//    size: 200.0,
//    gapless: false,
//  )
//         ],
//       ),),
//     );
//   }
// }