// ─── Bank Details State ───────────────────────────────────────

import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class BankDetailsState {
  final String accountNumber;
  final String reEnterAccountNumber;
  final String name;
  final String ifscCode;
  final String bankName;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  // UPI data returned from API
  final String? upiId;
  final String? qrCodeUrl;
  final String? holderName;
  final String? bankNameDisplay;
  final String? accountNumberDisplay;

  const BankDetailsState({
    this.accountNumber = '',
    this.reEnterAccountNumber = '',
    this.name = '',
    this.ifscCode = '',
    this.bankName = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
    this.upiId,
    this.qrCodeUrl,
    this.holderName,
    this.bankNameDisplay,
    this.accountNumberDisplay,
  });

  BankDetailsState copyWith({
    String? accountNumber,
    String? reEnterAccountNumber,
    String? name,
    String? ifscCode,
    String? bankName,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
    String? upiId,
    String? qrCodeUrl,
    String? holderName,
    String? bankNameDisplay,
    String? accountNumberDisplay,
  }) {
    return BankDetailsState(
      accountNumber: accountNumber ?? this.accountNumber,
      reEnterAccountNumber: reEnterAccountNumber ?? this.reEnterAccountNumber,
      name: name ?? this.name,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      upiId: upiId ?? this.upiId,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      holderName: holderName ?? this.holderName,
      bankNameDisplay: bankNameDisplay ?? this.bankNameDisplay,
      accountNumberDisplay: accountNumberDisplay ?? this.accountNumberDisplay,
    );
  }

  bool get isValid =>
      accountNumber.isNotEmpty &&
      accountNumber == reEnterAccountNumber &&
      name.isNotEmpty &&
      ifscCode.length >= 11 &&
      bankName.isNotEmpty;
}

// ─── Bank list item ───────────────────────────────────────────
class BankItem {
  final String name;
  final String logo;

  const BankItem({required this.name, required this.logo});
}

const kBankList = [
  BankItem(name: 'State Bank of India', logo: 'SBI'),
  BankItem(name: 'HDFC Bank', logo: 'HDFC'),
  BankItem(name: 'ICICI Bank', logo: 'ICICI'),
  BankItem(name: 'Axis Bank', logo: 'AXIS'),
  BankItem(name: 'Kotak Mahindra Bank', logo: 'KMB'),
  BankItem(name: 'Punjab National Bank', logo: 'PNB'),
  BankItem(name: 'Bank of Baroda', logo: 'BOB'),
  BankItem(name: 'Canara Bank', logo: 'CNR'),
];

class BankDetailsNotifier extends StateNotifier<BankDetailsState> {
  final Ref ref;
  BankDetailsNotifier({required this.ref}) : super(const BankDetailsState());

  // ── Field setters ────────────────────────────────────────────
  void setAccountNumber(String v) =>
      state = state.copyWith(accountNumber: v, clearError: true);

  void setReEnterAccountNumber(String v) =>
      state = state.copyWith(reEnterAccountNumber: v, clearError: true);

  void setName(String v) => state = state.copyWith(name: v, clearError: true);

  void setIfscCode(String v) =>
      state = state.copyWith(ifscCode: v.toUpperCase(), clearError: true);

  void setBankName(String v) =>
      state = state.copyWith(bankName: v, clearError: true);

  // ── Validation ───────────────────────────────────────────────
  String? validate() {
    if (state.accountNumber.isEmpty) return 'Enter account number';
    if (state.accountNumber != state.reEnterAccountNumber) {
      return 'Account numbers do not match';
    }
    if (state.name.isEmpty) return 'Enter account holder name';
    if (state.ifscCode.length < 11) return 'Enter valid IFSC code (11 chars)';
    if (state.bankName.isEmpty) return 'Select a bank';
    return null;
  }

  // ── API: Submit bank details → get UPI QR ───────────────────
  Future<bool> submitBankDetails() async {
    final error = validate();
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final token = await SecureStorageService.getToken();
      final response = await ref
          .read(dioClientProvider)
          .post(
            APIEndpoints.bankdetails,
            data: {
              'account_number': state.accountNumber,
              'account_holder_name': state.name,
              'ifsc_code': state.ifscCode,
              'bank_name': state.bankName,
            },
            options: Options(
              validateStatus: (s) => s != null && s < 500,
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        state = state.copyWith(
          isSubmitting: false,
          upiId: data['upi_id'] ?? 'manojyadav483',
          qrCodeUrl: data['qr_code_url'],
          holderName: data['holder_name'] ?? state.name,
          bankNameDisplay: data['bank_name'] ?? state.bankName,
          accountNumberDisplay: data['account_number'] ?? state.accountNumber,
        );
        return true;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Submission failed. Please try again.',
        );
        return false;
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage:
            e.response?.data?['message'] ??
            e.message ??
            'Network error. Please try again.',
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }

  // ── API: Confirm UPI / complete onboarding ───────────────────
  Future<bool> confirmAndComplete() async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final token = await SecureStorageService.getToken();
      final response = await ref
          .read(dioClientProvider)
          .post(
            '/bank-details/confirm',
            data: {'upi_id': state.upiId},
            options: Options(
              validateStatus: (s) => s != null && s < 500,
              headers: {'Authorization': 'Bearer $token'},
            ),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(isSubmitting: false, isSuccess: true);
        return true;
      }
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Confirmation failed.',
      );
      return false;
    } on DioException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.message ?? 'Network error.',
      );
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, errorMessage: 'Error.');
      return false;
    }
  }

  // ── API: Fetch IFSC bank details (autofill bank name) ────────
  Future<void> fetchIfscDetails(String ifsc) async {
    if (ifsc.length < 11) return;
    try {
      // Uses public IFSC API — replace with your internal API if needed
      final res = await Dio().get('https://ifsc.razorpay.com/$ifsc');
      if (res.statusCode == 200) {
        state = state.copyWith(bankName: res.data['BANK'] ?? state.bankName);
      }
    } catch (_) {
      // Silent fail — user can still pick manually
    }
  }
}
