// import 'package:flutter/material.dart';
// import 'package:percent_indicator/percent_indicator.dart';
//
// class UploadProgressWidget extends StatelessWidget {
//   final int progress;
//   final bool isCompressing;
//   final int uploadedBytes;
//   final int totalBytes;
//   final VoidCallback? onCancel;
//
//   const UploadProgressWidget({
//     super.key,
//     required this.progress,
//     required this.isCompressing,
//     required this.uploadedBytes,
//     required this.totalBytes,
//     this.onCancel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     final isComplete = progress >= 100;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: EdgeInsets.all(30),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // العنوان
//             Text(
//               isCompressing ? 'ضغط الفيديو' : 'نشر الفيديو',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: primaryColor,
//               ),
//             ),
//
//             SizedBox(height: 30),
//
//             // دائرة التقدم
//             CircularPercentIndicator(
//               radius: 80.0,
//               lineWidth: 12.0,
//               percent: progress / 100,
//               center: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '$progress%',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.w700,
//                       color: primaryColor,
//                     ),
//                   ),
//
//                   SizedBox(height: 8),
//
//                   if (!isComplete)
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                       ),
//                     ),
//                 ],
//               ),
//               circularStrokeCap: CircularStrokeCap.round,
//               backgroundColor: Colors.grey.shade200,
//               progressColor: isComplete ? Colors.green : primaryColor,
//               animation: true,
//               animateFromLastPercent: true,
//             ),
//
//             SizedBox(height: 30),
//
//             // نص الحالة
//             Text(
//               _getStatusText(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isComplete ? Colors.green : Colors.grey.withOpacity(0.8),
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             SizedBox(height: 10),
//
//             // رسالة تفصيلية
//             if (!isComplete)
//               Text(
//                 _getDetailMessage(),
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//
//             // حجم البيانات
//             if (!isCompressing && totalBytes > 0 && !isComplete)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Text(
//                   '${_formatBytes(uploadedBytes)} / ${_formatBytes(totalBytes)}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ),
//
//             // زر الإلغاء
//             if (onCancel != null && !isComplete) ...[
//               SizedBox(height: 20),
//               TextButton.icon(
//                 onPressed: onCancel,
//                 icon: Icon(Icons.close, size: 18),
//                 label: Text('إلغاء'),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   // نص الحالة حسب التقدم
//   String _getStatusText() {
//     if (progress >= 100) {
//       return 'تم النشر بنجاح! 🎉';
//     }
//
//     if (isCompressing) {
//       if (progress < 30) return 'جاري ضغط الفيديو...';
//       if (progress < 70) return 'الحين نخلص الضغط...';
//       return 'باقي شوي وينتهي الضغط...';
//     }
//
//     if (progress < 30) return 'جاري رفع الفيديو...';
//     if (progress < 70) return 'الحين ننزله لك...';
//     return 'باقي شوي ويخلص...';
//   }
//
//   // رسالة تفصيلية
//   String _getDetailMessage() {
//     if (isCompressing) {
//       return 'جاري تحسين جودة الفيديو...';
//     }
//     return 'يلا شوي وينزل فيديوك';
//   }
//
//   // تحويل البايتات لصيغة قابلة للقراءة
//   String _formatBytes(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1024 * 1024) {
//       return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     }
//     if (bytes < 1024 * 1024 * 1024) {
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
//     }
//     return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
//   }
// }
//
// // ========================================
// // تصميم بديل - أكثر عصرية مع Animations
// // ========================================
// class ModernUploadProgressWidget extends StatefulWidget {
//   final int progress;
//   final bool isCompressing;
//   final int uploadedBytes;
//   final int totalBytes;
//   final VoidCallback? onCancel;
//
//   const ModernUploadProgressWidget({
//     Key? key,
//     required this.progress,
//     required this.isCompressing,
//     required this.uploadedBytes,
//     required this.totalBytes,
//     this.onCancel,
//   }) : super(key: key);
//
//   @override
//   State<ModernUploadProgressWidget> createState() =>
//       _ModernUploadProgressWidgetState();
// }
//
// class _ModernUploadProgressWidgetState extends State<ModernUploadProgressWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     final isComplete = widget.progress >= 100;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.white, Colors.grey.shade50],
//           ),
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: primaryColor.withOpacity(0.1),
//               blurRadius: 20,
//               offset: Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // أيقونة متحركة
//             if (!isComplete)
//               ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     widget.isCompressing
//                         ? Icons.compress
//                         : Icons.cloud_upload_rounded,
//                     size: 40,
//                     color: primaryColor,
//                   ),
//                 ),
//               ),
//
//             if (isComplete)
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.check_circle_rounded,
//                   size: 50,
//                   color: Colors.green,
//                 ),
//               ),
//
//             SizedBox(height: 24),
//
//             // العنوان
//             Text(
//               widget.isCompressing ? 'ضغط الفيديو' : 'نشر الفيديو',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//
//             SizedBox(height: 24),
//
//             // دائرة التقدم مع تأثير مميز
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // ظل خلفي
//                 Container(
//                   width: 170,
//                   height: 170,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: primaryColor.withOpacity(0.2),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // الدائرة الأساسية
//                 CircularPercentIndicator(
//                   radius: 85.0,
//                   lineWidth: 14.0,
//                   percent: widget.progress / 100,
//                   center: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '${widget.progress}%',
//                         style: TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor,
//                         ),
//                       ),
//
//                       if (!isComplete) ...[
//                         SizedBox(height: 8),
//                         SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.5,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               primaryColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   circularStrokeCap: CircularStrokeCap.round,
//                   backgroundColor: Colors.grey.shade200,
//                   progressColor: isComplete ? Colors.green : primaryColor,
//                   animation: true,
//                   animateFromLastPercent: true,
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 24),
//
//             // نص الحالة مع أيقونة
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (!isComplete)
//                   Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
//                 if (!isComplete) SizedBox(width: 8),
//                 Flexible(
//                   child: Text(
//                     _getStatusText(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isComplete ? Colors.green : Colors.grey[700],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 12),
//
//             // رسالة تشجيعية
//             if (!isComplete)
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   _getDetailMessage(),
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//
//             // حجم البيانات
//             if (!widget.isCompressing && widget.totalBytes > 0 && !isComplete)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Text(
//                   '${_formatBytes(widget.uploadedBytes)} / ${_formatBytes(widget.totalBytes)}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ),
//
//             // زر الإلغاء
//             if (widget.onCancel != null && !isComplete) ...[
//               SizedBox(height: 20),
//               OutlinedButton.icon(
//                 onPressed: widget.onCancel,
//                 icon: Icon(Icons.close, size: 18),
//                 label: Text('إلغاء'),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.red,
//                   side: BorderSide(color: Colors.red.withOpacity(0.5)),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getStatusText() {
//     if (widget.progress >= 100) return 'تم النشر بنجاح! 🎉';
//     if (widget.isCompressing) {
//       if (widget.progress < 30) return 'جاري ضغط الفيديو...';
//       if (widget.progress < 70) return 'الحين نخلص الضغط...';
//       return 'باقي شوي وينتهي الضغط...';
//     }
//     if (widget.progress < 30) return 'جاري رفع الفيديو...';
//     if (widget.progress < 70) return 'الحين ننزله لك...';
//     return 'باقي شوي ويخلص...';
//   }
//
//   String _getDetailMessage() {
//     if (widget.isCompressing) return 'جاري تحسين جودة الفيديو...';
//     return 'يلا شوي وينزل فيديوك';
//   }
//
//   String _formatBytes(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     if (bytes < 1024 * 1024 * 1024) {
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
//     }
//     return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
//   }
// }
