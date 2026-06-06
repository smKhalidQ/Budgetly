import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:budget_buddy/core/widgets/pickers/color_picker_widget.dart';
import 'package:budget_buddy/core/widgets/pickers/icon_picker_widget.dart';

class SubcategoriesListWidget extends StatelessWidget {
  final Category category;

  const SubcategoriesListWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryCubit, SubcategoryState>(
      builder: (context, state) {
        final isEditMode = state.isEditMode;
        final items = state.subcategories
            .where((s) => s.parentCategoryId == category.id)
            .toList();

        final cubit = SubcategoryCubit.get(context);

        Widget body;
        if (state.isLoading || state.status == SubcategoryStatus.initial) {
          body = const Center(child: CircularProgressIndicator());
        } else if (items.isEmpty) {
          body = _buildEmptyState(context, cubit);
        } else {
          body = _buildList(isEditMode, cubit, items);
        }

        return Column(
          children: [
            _buildBar(context, isEditMode, cubit),
            Expanded(child: body),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, SubcategoryCubit cubit) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.category_outlined,
              size: 48.sp, color: Colors.grey.withValues(alpha: 0.4)),
          SizedBox(height: 12.h),
          Text(
            "No subcategories yet",
            style: GoogleFonts.roboto(
                fontSize: 15.sp, color: AppColor.textSecondary),
          ),
          SizedBox(height: 16.h),
          TextButton.icon(
            onPressed: () => cubit.resetToDefaults(category),
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text("Restore defaults",
                style: GoogleFonts.roboto(fontSize: 13.sp)),
            style: TextButton.styleFrom(
              foregroundColor: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
      BuildContext context, bool isEditMode, SubcategoryCubit cubit) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      width: double.infinity,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SUBCATEGORIES",
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(
              isEditMode ? Icons.close : Icons.settings,
              color: Colors.blueGrey[700],
              size: 20.sp,
            ),
            onPressed: cubit.toggleSubCategoryEditModeState,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      bool isEditMode, SubcategoryCubit cubit, List<Subcategory> items) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        color: Colors.grey[200],
        height: 1,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) =>
          _buildItem(context, isEditMode, cubit, items[index]),
    );
  }

  Widget _buildItem(BuildContext context, bool isEditMode,
      SubcategoryCubit cubit, Subcategory item) {
    final color = parseColorFromString(item.color);
    final spent = double.tryParse(item.spentAmount ?? '0') ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              IconData(int.parse(item.icon), fontFamily: 'MaterialIcons'),
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (spent > 0)
                  Text(
                    spent.toStringAsFixed(0),
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (isEditMode) ...[
            _svgActionBtn(
              assetPath: 'assets/image/edit.svg',
              color: Colors.blueGrey,
              onTap: () => _showEditDialog(context, cubit, item),
            ),
            SizedBox(width: 8.w),
            _svgActionBtn(
              assetPath: 'assets/image/trash-can.svg',
              color: Colors.redAccent,
              onTap: () => _confirmDelete(context, cubit, item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _svgActionBtn({
    required String assetPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 18.w,
          height: 18.w,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, SubcategoryCubit cubit, Subcategory item) {
    showDialog(
      context: context,
      builder: (_) => _EditSubcategoryDialog(item: item, cubit: cubit),
    );
  }

  void _confirmDelete(
      BuildContext context, SubcategoryCubit cubit, Subcategory item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete Subcategory",
            style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        content: Text('Delete "${item.name}"?',
            style: GoogleFonts.roboto()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              cubit.removeSubcategory(item.id!);
              Navigator.pop(dialogContext);
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Dialog ─────────────────────────────────────────────────────────────

class _EditSubcategoryDialog extends StatefulWidget {
  final Subcategory item;
  final SubcategoryCubit cubit;

  const _EditSubcategoryDialog({required this.item, required this.cubit});

  @override
  State<_EditSubcategoryDialog> createState() => _EditSubcategoryDialogState();
}

class _EditSubcategoryDialogState extends State<_EditSubcategoryDialog> {
  late final TextEditingController _nameCtrl;
  late final PageController _pageCtrl;
  late Color _color;
  late String _icon;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item.name);
    _pageCtrl = PageController();
    _color = parseColorFromString(widget.item.color);
    _icon = widget.item.icon;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Subcategory",
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Select Icon",
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.h),
                        IconPickerWidget(
                          key: ValueKey(_icon),
                          currentIcon: IconData(
                            int.tryParse(_icon) ?? Icons.category.codePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          currentColor: _color,
                          onIconSelected: (icon) =>
                              setState(() => _icon = icon.codePoint.toString()),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Select Color",
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.h),
                        ColorPickerWidget(
                          key: ValueKey(_color.toARGB32()),
                          currentColor: _color,
                          onColorSelected: (c) => setState(() => _color = c),
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
                    color: _page == i
                        ? AppColor.primaryColor
                        : Colors.grey.withValues(alpha: 0.5),
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
          child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_nameCtrl.text.trim().isEmpty) return;
            widget.cubit.updateSubcategoryData(
              widget.item.id!,
              widget.item.copyWith(
                name: _nameCtrl.text.trim(),
                icon: _icon,
                color: '0x${_color.toARGB32().toRadixString(16).padLeft(8, '0')}',
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
