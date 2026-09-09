// history_page.dart
// Dash Delivery Partner — History Screen
// Stack: hooks_riverpod + flutter_screenutil_plus

import 'package:delivary_partner/core/routes/app_routes_name.dart';
import 'package:delivary_partner/dashobord/d_history/domain/models.dart'
    show HistoryGroup, HistoryTransaction, ActiveFilters;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF8BBB22);
const _kGreenDark = Color(0xFF7AAD18);
const _kBg = Color(0xFFF5F5F5);
const _kCard = Colors.white;
const _kTextDark = Color(0xFF1A1A1A);
const _kTextMedium = Color(0xFF555555);
const _kTextLight = Color(0xFF999999);
const _kDivider = Color(0xFFEEEEEE);

// ── Filter enums ──────────────────────────────────────────────────────────────
enum DateFilter { thisMonth, last30, last90 }

enum PaymentFilter { upi, cash }

enum AmountFilter { upto500, upto1000, above1000 }

extension DateFilterLabel on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.thisMonth:
        return 'This month';
      case DateFilter.last30:
        return 'Last 30 Days';
      case DateFilter.last90:
        return 'Last 90 Days';
    }
  }
}

extension PaymentFilterLabel on PaymentFilter {
  String get label {
    switch (this) {
      case PaymentFilter.upi:
        return 'UPI Payments';
      case PaymentFilter.cash:
        return 'Cash Payments';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentFilter.upi:
        return Icons.account_balance_rounded;
      case PaymentFilter.cash:
        return Icons.payments_rounded;
    }
  }
}

extension AmountFilterLabel on AmountFilter {
  String get label {
    switch (this) {
      case AmountFilter.upto500:
        return 'Upto ₹100 to ₹500';
      case AmountFilter.upto1000:
        return 'Upto ₹500 to ₹1000';
      case AmountFilter.above1000:
        return 'Above ₹1000';
    }
  }
}

// ── Fake API ──────────────────────────────────────────────────────────────────
class HistoryApi {
  static final _avatarColors = [
    const Color(0xFFFF6B35),
    const Color(0xFF8BBB22),
    const Color(0xFF3B82F6),
    const Color(0xFFF59E0B),
    const Color(0xFF8B5CF6),
    const Color(0xFFEF4444),
  ];

  Future<List<HistoryGroup>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final txMarch = List.generate(6, (i) {
      final labels = ['N', 'A', 'D', 'P', 'R', 'M'];
      final methods = [
        PaymentFilter.upi,
        PaymentFilter.cash,
        PaymentFilter.upi,
        PaymentFilter.cash,
        PaymentFilter.upi,
        PaymentFilter.cash,
      ];
      return HistoryTransaction(
        id: 'mar_$i',
        name: 'Name',
        date: '${20 - i}th Feb - 0${4 + i}:00 pm',
        amount: 325,
        avatarLabel: labels[i],
        avatarColor: _avatarColors[i % _avatarColors.length],
        paymentMethod: methods[i],
      );
    });

    final txFeb = List.generate(4, (i) {
      final labels = ['S', 'K', 'V', 'T'];
      return HistoryTransaction(
        id: 'feb_$i',
        name: 'Name',
        date: '${15 - i}th Jan - 0${3 + i}:00 pm',
        amount: 200 + (i * 75).toDouble(),
        avatarLabel: labels[i],
        avatarColor: _avatarColors[(i + 2) % _avatarColors.length],
        paymentMethod: i.isEven ? PaymentFilter.upi : PaymentFilter.cash,
      );
    });

    return [
      HistoryGroup(
        year: '2026',
        month: 'March',
        totalAmount: 7483,
        transactions: txMarch,
      ),
      HistoryGroup(
        year: '2026',
        month: 'February',
        totalAmount: 3200,
        transactions: txFeb,
      ),
    ];
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────
final _historyApiProvider = Provider<HistoryApi>((_) => HistoryApi());

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<HistoryGroup>>(
      HistoryNotifier.new,
    );

class HistoryNotifier extends AsyncNotifier<List<HistoryGroup>> {
  @override
  Future<List<HistoryGroup>> build() =>
      ref.read(_historyApiProvider).fetchHistory();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(_historyApiProvider).fetchHistory(),
    );
  }
}

final _filterProvider = StateProvider<ActiveFilters>(
  (_) => const ActiveFilters(),
);

final _searchProvider = StateProvider<String>((_) => '');

// ── Filtered list (derived) ───────────────────────────────────────────────────
// FIX 1: .asData?.value ?? [] — asData returns AsyncData<T>?, not T
final filteredHistoryProvider = Provider<List<HistoryGroup>>((ref) {
  final groups = ref.watch(historyProvider).asData?.value ?? <HistoryGroup>[];
  final filters = ref.watch(_filterProvider);
  final search = ref.watch(_searchProvider).toLowerCase().trim();

  return groups
      .map((group) {
        var txs = group.transactions;

        if (search.isNotEmpty) {
          txs = txs
              .where((t) => t.name.toLowerCase().contains(search))
              .toList();
        }
        if (filters.payment != null) {
          txs = txs.where((t) => t.paymentMethod == filters.payment).toList();
        }
        if (filters.amount != null) {
          txs = txs.where((t) {
            switch (filters.amount!) {
              case AmountFilter.upto500:
                return t.amount >= 100 && t.amount <= 500;
              case AmountFilter.upto1000:
                return t.amount > 500 && t.amount <= 1000;
              case AmountFilter.above1000:
                return t.amount > 1000;
            }
          }).toList();
        }

        return HistoryGroup(
          year: group.year,
          month: group.month,
          totalAmount: txs.fold(0, (s, t) => s + t.amount),
          transactions: txs,
        );
      })
      .where((g) => g.transactions.isNotEmpty)
      .toList();
});

// ── Screen ────────────────────────────────────────────────────────────────────
class HistoryPage extends HookConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            _AppBar(),
            SizedBox(height: 25.h),

            Expanded(
              child: historyAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: _kGreen),
                ),
                error: (e, _) => _ErrorBody(
                  message: e.toString(),
                  onRetry: () => ref.read(historyProvider.notifier).refresh(),
                ),
                data: (_) => const _HistoryBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
   
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.goNamed(AppRoutesName.homePageName),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 38.sp,
              color: Color.fromRGBO(170, 170, 170, 1),
            ),
          ),
          Expanded(
            child: Text(
              'History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: _kGreen,
              ),
            ),
          ),
          SizedBox(width: 34.w),
        ],
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────
class _HistoryBody extends HookConsumerWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();

    return Column(
      children: [
        Container(
          // color: _kCard,
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Column(
            children: [
              _SearchBar(controller: searchCtrl),
              SizedBox(height: 15.h),
              _FilterChips(),
            ],
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (_, ref, _) {
              final groups = ref.watch(filteredHistoryProvider);
              if (groups.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 48.sp,
                        color: _kTextLight,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'No transactions found',
                        style: TextStyle(fontSize: 13.sp, color: _kTextLight),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 80.h),
                physics: const BouncingScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (_, gi) {
                  final group = groups[gi];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 8.h,
                          top: gi == 0 ? 0 : 16.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.year,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: _kTextLight,
                                  ),
                                ),
                                Text(
                                  group.month,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                    color: _kTextDark,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '+ ${group.totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: _kGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _kCard,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: group.transactions
                              .asMap()
                              .entries
                              .map(
                                (e) => _TransactionTile(
                                  tx: e.value,
                                  showDivider:
                                      e.key != group.transactions.length - 1,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends ConsumerWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 51.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: _kDivider),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 24.sp, color: _kTextLight),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (v) => ref.read(_searchProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 13.sp, color: _kTextLight),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 13.sp, color: _kTextDark),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Icon(Icons.mic_rounded, size: 18.sp, color: _kTextLight),
          ),
        ],
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────
class _FilterChips extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(_filterProvider);

    return Row(
      mainAxisAlignment: .center,
      children: [
        _FilterChip(
          label: filters.hasDate
              ? filters.date!.label.split(' ').first
              : 'Date',
          active: filters.hasDate,
          onTap: () => _show(
            context,
            title: 'Date',
            child: _DateFilterSheet(current: filters.date, ref: ref),
          ),
        ),
        SizedBox(width: 8.w),
        _FilterChip(
          label: filters.hasPayment ? 'Payment Method' : 'Payment Method',
          active: filters.hasPayment,
          onTap: () => _show(
            context,
            title: 'Payment Method',
            child: _PaymentFilterSheet(current: filters.payment, ref: ref),
          ),
        ),
        SizedBox(width: 8.w),
        _FilterChip(
          label: 'Amount',
          active: filters.hasAmount,
          onTap: () => _show(
            context,
            title: 'Amount',
            child: _AmountFilterSheet(current: filters.amount, ref: ref),
          ),
        ),
      ],
    );
  }

  void _show(BuildContext ctx, {required String title, required Widget child}) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(title: title, child: child),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 33.h,
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? _kGreen : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: active ? _kGreen : _kDivider),
           boxShadow: [ BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Color.fromRGBO(94, 103, 105, 1),
              ),
            ),
            SizedBox(width: 3.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 9.sp,
              color: active ? Colors.white : _kTextMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter sheet shell ────────────────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 0, 0.w, 0.h),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: _kDivider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: _kTextDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: _kBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.sp,
                      color: _kTextMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: _kDivider),
          child,
        ],
      ),
    );
  }
}

// ── Date filter ───────────────────────────────────────────────────────────────
// FIX 2: Changed HookConsumerWidget → HookWidget (ref passed in, no double-ref confusion)
// FIX 3: notifier.state = notifier.state.copyWith(...) instead of .update() to avoid
//        untyped Object lambda error
class _DateFilterSheet extends HookWidget {
  final DateFilter? current;
  final WidgetRef ref;
  const _DateFilterSheet({this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = useState<DateFilter?>(current);
    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          ...DateFilter.values.map(
            (f) => _RadioTile(
              label: f.label,
              selected: selected.value == f,
              onTap: () => selected.value = f,
            ),
          ),
          _ApplyButton(
            onApply: () {
              final n = ref.read(_filterProvider.notifier);
              n.state = n.state.copyWith(date: selected.value);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ── Payment filter ────────────────────────────────────────────────────────────
class _PaymentFilterSheet extends HookWidget {
  final PaymentFilter? current;
  final WidgetRef ref;
  const _PaymentFilterSheet({this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = useState<PaymentFilter?>(current);
    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          ...PaymentFilter.values.map(
            (f) => _RadioTile(
              label: f.label,
              leadingIcon: f.icon,
              selected: selected.value == f,
              onTap: () => selected.value = f,
            ),
          ),
          _ApplyButton(
            onApply: () {
              final n = ref.read(_filterProvider.notifier);
              n.state = n.state.copyWith(payment: selected.value);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ── Amount filter ─────────────────────────────────────────────────────────────
class _AmountFilterSheet extends HookWidget {
  final AmountFilter? current;
  final WidgetRef ref;
  const _AmountFilterSheet({this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = useState<AmountFilter?>(current);
    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          ...AmountFilter.values.map(
            (f) => _RadioTile(
              label: f.label,
              selected: selected.value == f,
              onTap: () => selected.value = f,
            ),
          ),
          _ApplyButton(
            onApply: () {
              final n = ref.read(_filterProvider.notifier);
              n.state = n.state.copyWith(amount: selected.value);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ── Radio tile ────────────────────────────────────────────────────────────────
class _RadioTile extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final bool selected;
  final VoidCallback onTap;
  const _RadioTile({
    required this.label,
    this.leadingIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(leadingIcon, size: 16.sp, color: _kTextMedium),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _kTextDark,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _kGreen : _kDivider,
                  width: 2.r,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kGreen,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Apply button ──────────────────────────────────────────────────────────────
class _ApplyButton extends StatelessWidget {
  final VoidCallback onApply;
  const _ApplyButton({required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: SizedBox(
        width: double.infinity,
        height: 46.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            elevation: 0,
          ),
          onPressed: onApply,
          child: Text(
            'Apply',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Transaction tile ──────────────────────────────────────────────────────────
class _TransactionTile extends StatelessWidget {
  final HistoryTransaction tx;
  final bool showDivider;
  const _TransactionTile({required this.tx, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: tx.avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    tx.avatarLabel,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _kTextDark,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      tx.date,
                      style: TextStyle(fontSize: 11.sp, color: _kTextLight),
                    ),
                  ],
                ),
              ),
              Text(
                '+${tx.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: _kGreen,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: _kDivider,
            indent: 66.w,
            endIndent: 14.w,
          ),
      ],
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────
class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: _kGreen),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: _kTextMedium),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
