import 'dart:ui';

import 'package:delivary_partner/dashobord/d_history/presentation/history_page.dart';

class HistoryTransaction {
  final String id;
  final String name;
  final String date;      // e.g. "20th Feb - 04:00 pm"
  final double amount;
  final String avatarLabel;
  final Color  avatarColor;
  final PaymentFilter paymentMethod;

  const HistoryTransaction({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.avatarLabel,
    required this.avatarColor,
    required this.paymentMethod,
  });
}

class HistoryGroup {
  final String year;
  final String month;
  final double totalAmount;
  final List<HistoryTransaction> transactions;

  const HistoryGroup({
    required this.year,
    required this.month,
    required this.totalAmount,
    required this.transactions,
  });
}

//


class ActiveFilters {
  final DateFilter?    date;
  final PaymentFilter? payment;
  final AmountFilter?  amount;

  const ActiveFilters({this.date, this.payment, this.amount});

  ActiveFilters copyWith({
    DateFilter?    date,
    PaymentFilter? payment,
    AmountFilter?  amount,
    bool clearDate    = false,
    bool clearPayment = false,
    bool clearAmount  = false,
  }) {
    return ActiveFilters(
      date:    clearDate    ? null : (date    ?? this.date),
      payment: clearPayment ? null : (payment ?? this.payment),
      amount:  clearAmount  ? null : (amount  ?? this.amount),
    );
  }

  bool get hasDate    => date    != null;
  bool get hasPayment => payment != null;
  bool get hasAmount  => amount  != null;
}