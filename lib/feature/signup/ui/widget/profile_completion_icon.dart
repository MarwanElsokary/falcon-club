// // في شاشة MainScreen أو حيث الـ BottomNavigationBar
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/helpers/constants.dart';
// import '../../../../core/helpers/shared_pref_helper.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   bool _showProfileAlert = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkProfileCompletion();
//   }
//
//   Future<void> _checkProfileCompletion() async {
//     final isCompleted = await SharedPrefHelper.getBool(
//       SharedPrefKeys.isCompleted,
//     ) ?? false;
//
//     if (!isCompleted) {
//       setState(() {
//         _showProfileAlert = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Falcon'),
//         actions: [
//           if (_showProfileAlert)
//             IconButton(
//               onPressed: () {
//                 _showFloatingProfileAlert(context);
//               },
//               icon: Stack(
//                 children: [
//                   Icon(Icons.person),
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 14,
//                       ),
//                       child: Text(
//                         '!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//       // ... باقي الشاشة ...
//     );
//   }
//
//   void _showFloatingProfileAlert(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.person_pin_circle,
//               size: 60,
//               color: Colors.orange[800],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'ملفك الشخصي غير مكتمل',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'إكمال بيانات الملف الشخصي يحسن تجربتك في التطبيق',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('لاحقاً'),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/complete-profile');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange[800],
//                     ),
//                     child: Text('إكمال الآن'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }