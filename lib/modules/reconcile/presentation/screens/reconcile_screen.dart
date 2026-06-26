import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/reconcile/presentation/cubits/reconcile_cubit.dart';
import 'package:budget_buddy/modules/reconcile/presentation/cubits/reconcile_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class ReconcileScreen extends StatelessWidget {
  const ReconcileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ReconcileCubit>()..initialize(),
      child: const _ReconcileView(),
    );
  }
}

class _ReconcileView extends StatefulWidget {
  const _ReconcileView();

  @override
  State<_ReconcileView> createState() => _ReconcileViewState();
}

class _ReconcileViewState extends State<_ReconcileView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDone(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    context.read<CategoryCubit>().fetchCategories();
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Balance reconciled',
            style: GoogleFonts.cairo(fontSize: 12.sp)),
      ),
    );
  }

  void _confirmFreshStart(BuildContext context, String symbol, double actual) {
    final cubit = context.read<ReconcileCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Start fresh?',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          'Spending resets and $symbol${actual.toStringAsFixed(0)} is re-spread '
          'across your envelopes by their current ratios.',
          style: GoogleFonts.cairo(
              fontSize: 13.sp, color: AppColor.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel',
                style: GoogleFonts.cairo(color: AppColor.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.freshStart();
            },
            child: const Text('Start fresh'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Reconcile balance',
          style: GoogleFonts.cairo(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: BlocConsumer<ReconcileCubit, ReconcileState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status && curr.status == ReconcileStatus.done,
        listener: (context, _) => _onDone(context),
        builder: (context, state) {
          final cubit = context.read<ReconcileCubit>();

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              _InfoCard(
                label: 'Your envelopes hold',
                value: '$symbol${state.expected.toStringAsFixed(0)}',
                color: AppColor.primaryColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'How much do you actually have now?',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyle.number(
                  size: 18.sp,
                  weight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
                onChanged: (t) => cubit.setActual(double.tryParse(t) ?? 0),
                decoration: InputDecoration(
                  prefixText: symbol,
                  filled: true,
                  fillColor: AppColor.cardBackground,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(
                        color: AppColor.accentColor, width: 1.5),
                  ),
                ),
              ),
              if (state.hasActual) ...[
                SizedBox(height: 16.h),
                _DiffBanner(state: state, symbol: symbol),
                if (state.isUnloggedSpending) ...[
                  SizedBox(height: 16.h),
                  Text(
                    'Where did the $symbol${state.diff.abs().toStringAsFixed(0)} go? '
                    'Enter what you spent from each.',
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _Distributor(
                    key: ValueKey('spend-${state.diff.toStringAsFixed(2)}'),
                    categories: state.categories,
                    total: state.diff,
                    isIncome: false,
                    symbol: symbol,
                    isLoading: state.isLoading,
                    onConfirm: cubit.applySpending,
                  ),
                ],
                if (state.isExtra) ...[
                  SizedBox(height: 16.h),
                  Text(
                    'Where did the extra $symbol${state.diff.abs().toStringAsFixed(0)} go? '
                    'Add it as income to the envelopes that got it.',
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _Distributor(
                    key: ValueKey('income-${state.diff.toStringAsFixed(2)}'),
                    categories: state.categories,
                    total: -state.diff,
                    isIncome: true,
                    symbol: symbol,
                    isLoading: state.isLoading,
                    onConfirm: cubit.applyIncome,
                  ),
                ],
                SizedBox(height: 12.h),
                if (!state.isMatched)
                  Center(
                    child: TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () =>
                              _confirmFreshStart(context, symbol, state.actual),
                      child: Text(
                        'Lost track? Start fresh instead',
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Distributor extends StatefulWidget {
  final List<Category> categories;
  final double total;
  final bool isIncome;
  final String symbol;
  final bool isLoading;
  final ValueChanged<Map<int, double>> onConfirm;

  const _Distributor({
    super.key,
    required this.categories,
    required this.total,
    required this.isIncome,
    required this.symbol,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  State<_Distributor> createState() => _DistributorState();
}

class _DistributorState extends State<_Distributor> {
  late final List<Category> _candidates;
  final Map<int, double> _amounts = {};
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _candidates = widget.categories
        .where((c) =>
            c.id != null && (widget.isIncome || _remaining(c) > 0))
        .toList();
    for (final c in _candidates) {
      _amounts[c.id!] = 0;
      _controllers[c.id!] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _remaining(Category c) {
    final r = c.allocatedAmount - c.spentAmount;
    return r > 0 ? r : 0;
  }

  String _fmt(double v) => v <= 0
      ? ''
      : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2));

  double get _sum => _amounts.values.fold(0.0, (a, b) => a + b);
  double get _left => widget.total - _sum;
  bool get _balanced => _left.abs() < 0.01;

  void _onChanged(Category c, String text) {
    var value = double.tryParse(text) ?? 0;
    if (value < 0) value = 0;
    final others = _sum - (_amounts[c.id!] ?? 0);
    var cap = widget.total - others;
    if (cap < 0) cap = 0;
    if (!widget.isIncome) {
      final remaining = _remaining(c);
      if (remaining < cap) cap = remaining;
    }
    if (value > cap) {
      value = cap;
      final clamped = _fmt(value);
      _controllers[c.id!]!.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }
    setState(() => _amounts[c.id!] = value);
  }

  @override
  Widget build(BuildContext context) {
    final leftColor =
        _balanced ? AppColor.incomeColor : AppColor.accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: leftColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
          ),
          child: Row(
            children: [
              Icon(
                _balanced
                    ? Icons.check_circle_rounded
                    : Icons.account_balance_wallet_rounded,
                color: leftColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                _balanced
                    ? 'All assigned'
                    : 'Left to assign: ${widget.symbol}${_left.toStringAsFixed(0)}',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: leftColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        for (final c in _candidates) _row(c),
        SizedBox(height: 6.h),
        _PrimaryButton(
          label: 'Confirm',
          onTap: (_balanced && !widget.isLoading)
              ? () => widget.onConfirm(Map<int, double>.from(_amounts))
              : null,
        ),
      ],
    );
  }

  Widget _row(Category c) {
    final color = parseColorFromString(c.color);

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(int.parse(c.icon), fontFamily: 'MaterialIcons'),
              color: color,
              size: 15.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
                Text(
                  widget.isIncome
                      ? 'Now: ${widget.symbol}${(_remaining(c) + (_amounts[c.id!] ?? 0)).toStringAsFixed(0)}'
                      : 'Available: ${widget.symbol}${(_remaining(c) - (_amounts[c.id!] ?? 0)).toStringAsFixed(0)}',
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 72.w,
            child: TextField(
              controller: _controllers[c.id!],
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: AppTextStyle.number(
                size: 13.sp,
                weight: FontWeight.bold,
                color: color,
              ),
              onChanged: (text) => _onChanged(c, text),
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: const BorderSide(color: AppColor.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: BorderSide(color: color, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.number(
              size: 18.sp,
              weight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiffBanner extends StatelessWidget {
  final ReconcileState state;
  final String symbol;

  const _DiffBanner({required this.state, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final matched = state.isMatched;
    final color = matched
        ? AppColor.incomeColor
        : (state.isUnloggedSpending
            ? AppColor.expenseColor
            : AppColor.incomeColor);
    final label = matched
        ? 'Everything matches'
        : (state.isUnloggedSpending
            ? 'Unlogged spending: $symbol${state.diff.abs().toStringAsFixed(0)}'
            : 'Extra money: $symbol${state.diff.abs().toStringAsFixed(0)}');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Row(
        children: [
          Icon(
            matched ? Icons.check_circle_rounded : Icons.info_rounded,
            color: color,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        decoration: BoxDecoration(
          color: enabled
              ? AppColor.primaryColor
              : AppColor.primaryColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.md.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
