import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:budget_buddy/core/widgets/pickers/color_picker_widget.dart';
import 'package:budget_buddy/core/widgets/pickers/icon_picker_widget.dart';

class SubcategoriesListWidget extends StatelessWidget {
  final Function(Subcategory) onSubcategoryTap;
  final Category category;

  const SubcategoriesListWidget({
    super.key,
    required this.onSubcategoryTap,
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
              size: 48, color: Colors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            "No subcategories yet",
            style: GoogleFonts.roboto(
                fontSize: 15, color: AppColor.textSecondary),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => cubit.resetToDefaults(category),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text("Restore defaults",
                style: GoogleFonts.roboto(fontSize: 13)),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: double.infinity,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SUBCATEGORIES",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(
              isEditMode ? Icons.close : Icons.settings,
              color: Colors.blueGrey[700],
              size: 20,
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
      padding: const EdgeInsets.only(bottom: 16),
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

    return InkWell(
      onTap: () {
        if (!isEditMode) onSubcategoryTap(item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconData(int.parse(item.icon), fontFamily: 'MaterialIcons'),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Name + amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (spent > 0)
                    Text(
                      spent.toStringAsFixed(0),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            // Edit mode actions
            if (isEditMode) ...[
              _svgActionBtn(
                assetPath: 'assets/image/edit.svg',
                color: Colors.blueGrey,
                onTap: () => _showEditDialog(context, cubit, item),
              ),
              const SizedBox(width: 8),
              _svgActionBtn(
                assetPath: 'assets/image/trash-can.svg',
                color: Colors.redAccent,
                onTap: () => _confirmDelete(context, cubit, item),
              ),
            ],
          ],
        ),
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
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 18,
          height: 18,
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
            const SizedBox(height: 16),
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
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 10),
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
