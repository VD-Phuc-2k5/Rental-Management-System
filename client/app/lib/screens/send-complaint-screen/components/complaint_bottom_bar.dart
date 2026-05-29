import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class ComplaintBottomBar extends StatelessWidget {
  const ComplaintBottomBar({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray100, width: 1)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red500,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Gửi',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../../core/constants.dart';
// class ComplaintBottomBar extends StatelessWidget {
//   const ComplaintBottomBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.white,
//         border: Border(top: BorderSide(color: AppColors.gray100, width: 1)),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Color(0x14000000),
//         //     blurRadius: 10,
//         //     offset: Offset(0, -2),
//         //   ),
//         // ],
//       ),
//       child: SafeArea(
//         top: false,
//         minimum: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//         child: SizedBox(
//           height: 54,
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.red500,
//               foregroundColor: AppColors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//               elevation: 0,
//             ),
//             child: const Text(
//               'Gửi',
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }