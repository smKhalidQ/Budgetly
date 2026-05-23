//
// import 'package:flutter/material.dart';
//
// import '../constances.dart';
// import '../domain/entities/category_entity.dart';
// import '../../features/category_managment/presentation/cubit/category_cubit.dart';
// import '../../features/category_managment/presentation/cubit/category_states.dart';
// import '../../features/transaction/domain/entities/transaction_entity.dart';
// import '../../features/transaction/presentation/cubit/transaction_cubit.dart';
// import '../../features/transaction/presentation/cubit/transaction_states.dart';
//
// class StylePickerDialog extends StatelessWidget {
//   final Widget child;
//   final String title;
//   final VoidCallback? onConfirm;
//   final CategoryEntity item;
//   final CategoryCubit categoryCubit;
//
//   const StylePickerDialog({
//     Key? key,
//     required this.child,
//     required this.title,
//     this.onConfirm,
//     required this.item, required this.categoryCubit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(28),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                               categoryCubit.categoryIcon=item.icon;
//                               categoryCubit.categoryColor=parseColorFromString(item.color!);
//                               categoryCubit.emit(ChangeAppearanceState(items: categoryCubit.fetchedCategories));
//                               Navigator.pop(context);
//                   },
//                   style: IconButton.styleFrom(
//                     backgroundColor: Colors.grey.withOpacity(0.1),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             child,
//             const SizedBox(height: 24),
//             if (onConfirm != null)
//               ElevatedButton(
//                 onPressed: onConfirm,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text("Confirm"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }