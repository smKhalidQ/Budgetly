// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import '../../../../core/constances.dart';
// import '../../../../core/domain/entities/category_entity.dart';
//
// import '../../features/category_managment/presentation/cubit/category_cubit.dart';
// import '../../features/category_managment/presentation/cubit/category_states.dart';
// import 'style_picker_dialog.dart';
//
//
// class IconPickerDialog {
//   static void show(BuildContext context, CategoryCubit categoryCubit,CategoryEntity item) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return BlocProvider.value(
//           value: categoryCubit,
//           child: BlocBuilder<CategoryCubit, CategoryStates>(
//             builder: (context, state) {
//               return StylePickerDialog(
//                 categoryCubit: categoryCubit,
//
//                 item: item,
//                 title: "Choose an Icon",
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: const BouncingScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     childAspectRatio: 1,
//                   ),
//                   itemCount: iconImages.length,
//                   itemBuilder: (context, index) => IconItem(
//                     icon: iconImages[index],
//                     isSelected: categoryCubit.categoryIcon == iconImages[index],
//                     onTap: () {
//                       BlocProvider.of<CategoryCubit>(context)
//                           .updateCategoryIcon(index);
//                     },
//                   ),
//                 ),
//                 onConfirm: () {
//                   // isEditablePage? saveUpdatedCategory(categoryCubit)
//                   //     : null;
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
// class ColorPickerDialog {
//   static void show(BuildContext context, CategoryCubit categoryCubit,CategoryEntity item) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StylePickerDialog(
//            categoryCubit: categoryCubit,
//           item: item,
//           title: "Choose a Color",
//           child: SizedBox(
//             height: 400,
//             child: MaterialPicker(
//               pickerColor: categoryCubit.categoryColor,
//               onColorChanged: (color) {
//                 categoryCubit.updateCategoryColor(color);
//               },
//             ),
//           ),
//           onConfirm: () => Navigator.pop(context),
//         );
//       },
//     );
//   }
// }
// class IconItem extends StatelessWidget {
//   final String icon;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const IconItem({
//     Key? key,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? Theme.of(context).primaryColor
//                 : Colors.grey.withOpacity(0.3),
//             width: 2,
//           ),
//         ),
//         child: Image.asset(
//           icon,
//           color: isSelected ? Theme.of(context).primaryColor : null,
//         ),
//       ),
//     );
//   }
// }
//
//
