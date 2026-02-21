// import 'package:flutter/material.dart';
// import 'deepLinkHandler.dart';
//
// /// 📱 مثال على كيفية استخدام Deep Link Handler في Main App
// ///
// /// ⚠️ هذا مثال توضيحي - عدل الكود حسب بنية التطبيق الخاص بك
//
// class MainAppExample extends StatefulWidget {
//   const MainAppExample({super.key});
//
//   @override
//   State<MainAppExample> createState() => _MainAppExampleState();
// }
//
// class _MainAppExampleState extends State<MainAppExample> {
//   final _deepLinkHandler = DeepLinkHandler();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeDeepLinks();
//   }
//
//   Future<void> _initializeDeepLinks() async {
//     // 🔗 تهيئة معالج الروابط العميقة
//     await _deepLinkHandler.initialize(
//       context: context,
//       onReelDeepLink: _handleReelDeepLink,
//     );
//   }
//
//   /// 🎬 معالجة الرابط العميق للريل
//   void _handleReelDeepLink(String reelId) {
//     debugPrint('🎬 Navigation to Reel ID: $reelId');
//
//     // 🔥 هنا عدل الكود حسب بنية التطبيق:
//
//     // مثال 1: لو عندك navigation service
//     // navigationService.navigateToReel(reelId);
//
//     // مثال 2: لو بتستخدم named routes
//     Navigator.pushNamed(context, '/reel', arguments: {'reelId': reelId});
//
//     // مثال 3: لو عندك bloc/cubit
//     // context.read<RealsCubit>().navigateToReel(reelId);
//
//     // مثال 4: لو بتستخدم GetX
//     // Get.toNamed('/reel/$reelId');
//
//     // 🔥 الحل الأبسط (بافتراض عندك RealsScreen widget):
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => RealsScreenWithId(
//           reelId: reelId,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _deepLinkHandler.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // ... your app configuration
//       home: HomeScreen(),
//     );
//   }
// }
//
// /// 🎬 Widget example للانتقال لريل معين
// class RealsScreenWithId extends StatefulWidget {
//   final String reelId;
//
//   const RealsScreenWithId({
//     super.key,
//     required this.reelId,
//   });
//
//   @override
//   State<RealsScreenWithId> createState() => _RealsScreenWithIdState();
// }
//
// class _RealsScreenWithIdState extends State<RealsScreenWithId> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToReel();
//   }
//
//   Future<void> _navigateToReel() async {
//     // 🔥 هنا تضيف الكود اللي يوصلك للريل المطلوب
//
//     // مثال 1: لو عندك cubit
//     // final cubit = context.read<RealsCubit>();
//     // await cubit.emitreals(playerId: 'current_player_id');
//     // final reelIndex = cubit.realsVide.indexWhere((r) => r.id.toString() == widget.reelId);
//     // if (reelIndex != -1) {
//     //   // انتقل للصفحة المطلوبة
//     // }
//
//     // مثال 2: لو عندك API call مباشر
//     final reel = await _fetchReelById(widget.reelId);
//     if (reel != null) {
//       // اعرض الريل
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// /// 🔥 Example Home Screen
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Falcon')),
//       body: Center(
//         child: Text('Home'),
//       ),
//     );
//   }
// }