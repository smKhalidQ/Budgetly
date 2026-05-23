// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
//
// import '../cubit/transaction_cubit.dart';
// import '../cubit/transaction_states.dart';
// import '../../data/models/transaction_model.dart';
// import '../../domain/entities/transaction_entity.dart';
// import 'color_icon_picker_dialog.dart';
//
// class CategoryCreationSheet {
//   final TransactionEntity item;
//
//   CategoryCreationSheet({required this.item});
//   static void show(BuildContext context, {required bool isSetting,required TransactionEntity item}) {
//     final categoryCubit = BlocProvider.of<TransactionCubit>(context);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) =>
//           BlocProvider.value(
//             value: categoryCubit,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Theme
//                     .of(context)
//                     .scaffoldBackgroundColor,
//                 borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(28)),
//               ),
//               child: CategoryCreationForm(isSettingUp: isSetting,item:item),
//             ),
//           ),
//     );
//   }
// }
//
// class CategoryCreationForm extends StatefulWidget {
//   const CategoryCreationForm({Key? key, required this.isSettingUp, required this.item}) : super(key: key);
//   final bool isSettingUp;
//   final TransactionEntity item;
//
//   @override
//   State<CategoryCreationForm> createState() => _CategoryCreationFormState();
// }
//
// class _CategoryCreationFormState extends State<CategoryCreationForm> {
//   late TextEditingController nameController;
//   late TextEditingController budgetSliceController;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController();
//     budgetSliceController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     budgetSliceController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//            onWillPop: () async {
//         FocusScope.of(context).unfocus();
//         return true;
//       },
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Create Category",
//                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Gap(24),
//                     BlocBuilder<TransactionCubit, TransactionStates>(
//                       builder: (context, state) {
//                         TransactionCubit categoryCubit = TransactionCubit.get(context);
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _buildPickerButton(
//                               context: context,
//                               onTap: () => ColorPickerDialog.show(context, categoryCubit,widget.item),
//                               child: Container(
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: categoryCubit.categoryColor,
//                                   border: Border.all(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     width: 2,
//                                   ),
//                                 ),
//                               ),
//                               label: "Color",
//                             ),
//                             _buildPickerButton(
//                               context: context,
//                               onTap: () => IconPickerDialog.show(context, categoryCubit,widget.item),
//                               child: Container(
//                                 height: 60,
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Image.asset(
//                                   categoryCubit.categoryIcon ?? "assets/category.png",
//                                   width: 32,
//                                 ),
//                               ),
//                               label: "Icon",
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                     const Gap(24),
//                     _buildTextField(
//                       controller: nameController,
//                       label: "Category Name",
//                       hintText: "e.g., Groceries",
//                     ),
//                     const Gap(16),
//                     if (!widget.isSettingUp) _buildTextField(
//                       controller: budgetSliceController,
//                       label: "Budget Amount",
//                       hintText: "Enter amount",
//                       keyboardType: TextInputType.number,
//                     ),
//                     const Gap(32),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             child: const Text("Cancel"),
//                           ),
//                         ),
//                         const Gap(16),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () => _createCategory(context),
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               backgroundColor: Theme.of(context).primaryColor,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text("Create"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPickerButton({
//     required BuildContext context,
//     required VoidCallback onTap,
//     required Widget child,
//     required String label,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.grey.withOpacity(0.1),
//             ),
//             padding: const EdgeInsets.all(16),
//             child: child,
//           ),
//           const Gap(8),
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     TextInputType? keyboardType,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 16,
//           ),
//         ),
//         const Gap(8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             filled: true,
//             fillColor: Colors.grey.withOpacity(0.1),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _createCategory(BuildContext context) {
//     final categoryCubit = TransactionCubit.get(context);
//     if (widget.isSettingUp) {
//       if (nameController.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Please fill in all fields"),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         return;
//       }
//       TransactionEntity newCategory = TransactionModel(
//         name: nameController.text,
//         allocatedAmount: 0.0,
//         storedSpentAmount: 0.0,
//         color: categoryCubit.categoryColor.toString(),
//         icon: categoryCubit.categoryIcon,
//       );
//       categoryCubit.addNewSettingUpCategory(newCategory);
//       Navigator.pop(context);
//     } else {
//       if (nameController.text.isEmpty || budgetSliceController.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Please fill in all fields"),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         return;
//       }
//       TransactionEntity newCategory = TransactionModel(
//         name: nameController.text,
//         allocatedAmount: double.parse(budgetSliceController.text),
//         color: categoryCubit.categoryColor.toString(),
//         icon: categoryCubit.categoryIcon,
//       );
//       categoryCubit.insertNewCategory(newCategory);
//       Navigator.pop(context);
//     }
//   }
// }