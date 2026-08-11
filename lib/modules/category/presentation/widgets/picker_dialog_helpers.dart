import 'package:slice_pay/core/extensions/icon_extensions.dart';
import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/utilities/constants.dart';
import 'package:slice_pay/core/widgets/pickers/color_picker_widget.dart';
import 'package:slice_pay/core/widgets/pickers/icon_picker_widget.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_state.dart';
import 'package:slice_pay/modules/subcategory/domain/models/subcategory.dart';
import 'package:slice_pay/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:slice_pay/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PickerDialogHelpers {
  static Future<void> showCategoryPickerDialog({
    required BuildContext context,
    required String title,
    required bool isAdd,
    required Function(Category) pickerFunction,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: CategoryCubit.get(context),
        child: _CategoryPickerDialog(
          title: title,
          isAdd: isAdd,
          pickerFunction: pickerFunction,
        ),
      ),
    );
  }

  static Future<void> showSubcategoryPickerDialog({
    required BuildContext context,
    required String title,
    required bool isAdd,
    required int parentCategoryId,
    required Function(Subcategory) pickerFunction,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: SubcategoryCubit.get(context),
        child: _SubcategoryPickerDialog(
          title: title,
          isAdd: isAdd,
          parentCategoryId: parentCategoryId,
          pickerFunction: pickerFunction,
        ),
      ),
    );
  }
}

// â”€â”€â”€ Category Picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CategoryPickerDialog extends StatefulWidget {
  final String title;
  final bool isAdd;
  final Function(Category) pickerFunction;

  const _CategoryPickerDialog({
    required this.title,
    required this.isAdd,
    required this.pickerFunction,
  });

  @override
  State<_CategoryPickerDialog> createState() => _CategoryPickerDialogState();
}

class _CategoryPickerDialogState extends State<_CategoryPickerDialog> {
  late final TextEditingController _nameCtrl;
  late final PageController _pageCtrl;
  bool _hasError = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) =>
          prev.selectedIcon != curr.selectedIcon ||
          prev.selectedColor != curr.selectedColor,
      builder: (context, state) {
        final icon = state.selectedIcon.isEmpty
            ? Icons.category.codePoint.toString()
            : state.selectedIcon;
        final color = parseColorFromString(state.selectedColor);

        return _PickerDialogShell(
          title: widget.title,
          isAdd: widget.isAdd,
          nameCtrl: _nameCtrl,
          pageCtrl: _pageCtrl,
          hasError: _hasError,
          errorText: context.tr.nameIsRequired,
          page: _page,
          currentIcon: icon,
          currentColor: color,
          onIconSelected: (iconData) => context
              .read<CategoryCubit>()
              .updateCategoryIcon(iconData.codePoint.toString()),
          onColorSelected: (c) =>
              context.read<CategoryCubit>().updateCategoryColor(c),
          onPageChanged: (p) => setState(() => _page = p),
          onSave: () {
            if (_nameCtrl.text.trim().isEmpty) {
              setState(() => _hasError = true);
              return;
            }
            final maxId = state.categories.fold<int>(
              0, (m, c) => (c.id ?? 0) > m ? (c.id ?? 0) : m,
            );
            widget.pickerFunction(Category(
              id: maxId + 1,
              name: _nameCtrl.text.trim(),
              allocatedAmount: 0.0,
              color:
                  '0x${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
              icon: icon,
            ));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

// â”€â”€â”€ Subcategory Picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SubcategoryPickerDialog extends StatefulWidget {
  final String title;
  final bool isAdd;
  final int parentCategoryId;
  final Function(Subcategory) pickerFunction;

  const _SubcategoryPickerDialog({
    required this.title,
    required this.isAdd,
    required this.parentCategoryId,
    required this.pickerFunction,
  });

  @override
  State<_SubcategoryPickerDialog> createState() =>
      _SubcategoryPickerDialogState();
}

class _SubcategoryPickerDialogState extends State<_SubcategoryPickerDialog> {
  late final TextEditingController _nameCtrl;
  late final PageController _pageCtrl;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryCubit, SubcategoryState>(
      buildWhen: (prev, curr) =>
          prev.selectedIcon != curr.selectedIcon ||
          prev.selectedColor != curr.selectedColor,
      builder: (context, state) {
        final icon = state.selectedIcon.isEmpty
            ? Icons.category.codePoint.toString()
            : state.selectedIcon;
        final color = parseColorFromString(state.selectedColor);

        return _PickerDialogShell(
          title: widget.title,
          isAdd: widget.isAdd,
          nameCtrl: _nameCtrl,
          pageCtrl: _pageCtrl,
          hasError: false,
          page: _page,
          currentIcon: icon,
          currentColor: color,
          onIconSelected: (iconData) => context
              .read<SubcategoryCubit>()
              .updateSubcategoryIcon(iconData.codePoint.toString()),
          onColorSelected: (c) =>
              context.read<SubcategoryCubit>().updateSubcategoryColor(c),
          onPageChanged: (p) => setState(() => _page = p),
          onSave: () {
            if (_nameCtrl.text.trim().isEmpty) return;
            widget.pickerFunction(Subcategory(
              name: _nameCtrl.text.trim(),
              color:
                  '0x${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
              icon: icon,
              parentCategoryId: widget.parentCategoryId,
            ));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

// â”€â”€â”€ Shared Dialog Shell â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PickerDialogShell extends StatelessWidget {
  final String title;
  final bool isAdd;
  final TextEditingController nameCtrl;
  final PageController pageCtrl;
  final bool hasError;
  final String? errorText;
  final int page;
  final String currentIcon;
  final Color currentColor;
  final Function(IconData) onIconSelected;
  final Function(Color) onColorSelected;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSave;

  const _PickerDialogShell({
    required this.title,
    required this.isAdd,
    required this.nameCtrl,
    required this.pageCtrl,
    required this.hasError,
    this.errorText,
    required this.page,
    required this.currentIcon,
    required this.currentColor,
    required this.onIconSelected,
    required this.onColorSelected,
    required this.onPageChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return AlertDialog(
      title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: t.name,
                border: const OutlineInputBorder(),
                errorText: hasError ? errorText : null,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: PageView(
                controller: pageCtrl,
                onPageChanged: onPageChanged,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.selectIcon,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.h),
                        IconPickerWidget(
                          key: ValueKey(currentIcon),
                          currentIcon: currentIcon.toIconData(),
                          currentColor: currentColor,
                          onIconSelected: onIconSelected,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.selectColor,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.h),
                        ColorPickerWidget(
                          key: ValueKey(currentColor.toARGB32()),
                          currentColor: currentColor,
                          onColorSelected: onColorSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (i) => Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: page == i
                        ? AppColor.primaryColor
                        : AppColor.borderColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel,
              style: GoogleFonts.cairo(color: AppColor.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: onSave,
          child: Text(isAdd ? t.add : t.save),
        ),
      ],
    );
  }
}
