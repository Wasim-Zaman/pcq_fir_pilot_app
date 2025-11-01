// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
// import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

// /// Scan section widget for item verification
// class ScanSection extends StatefulWidget {
//   final VoidCallback onTap;

//   const ScanSection({super.key, required this.onTap});

//   @override
//   State<ScanSection> createState() => _ScanSectionState();
// }

// class _ScanSectionState extends State<ScanSection>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.onTap,
//       borderRadius: BorderRadius.circular(24),
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppColors.kPrimaryColor.withValues(alpha: 0.12),
//                   AppColors.kPrimaryColor.withValues(alpha: 0.08),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(
//                 color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Animated icon with pulsing rings
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Outer pulse ring
//                     Transform.scale(
//                       scale: 1.0 + (_pulseAnimation.value * 0.3),
//                       child: Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: AppColors.kPrimaryColor.withValues(
//                               alpha: 0.2 * (1 - _pulseAnimation.value),
//                             ),
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Main icon container
//                     Transform.scale(
//                       scale: _scaleAnimation.value,
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Colors.white,
//                               Colors.white.withValues(alpha: 0.95),
//                             ],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.kPrimaryColor.withValues(
//                                 alpha: 0.3,
//                               ),
//                               blurRadius: 15,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Iconsax.scan_barcode,
//                           size: 40,
//                           color: AppColors.kPrimaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 20.widthBox,
//                 // Text content
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Scan Item/QR Code',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.kPrimaryColor,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                       6.heightBox,
//                       Text(
//                         'Tap to scan or enter item ID',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: AppColors.kTextSecondaryColor,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
