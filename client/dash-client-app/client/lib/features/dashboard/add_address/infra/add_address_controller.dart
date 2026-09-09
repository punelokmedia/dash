// lib/features/dashboard/add_address/application/address_controller.dart

import 'package:dash_logistics/features/dashboard/add_address/infra/add_address_repository.dart';
import 'package:hooks_riverpod/legacy.dart';

class AddressState {
  final bool    isSaving;
  final bool    isSuccess;
  final String  savedPhone;
  final String? error;

  const AddressState({
    this.isSaving   = false,
    this.isSuccess  = false,
    this.savedPhone = '',
    this.error,
  });

  AddressState copyWith({
    bool?   isSaving,
    bool?   isSuccess,
    String? savedPhone,
    String? error,
    bool    clear = false,
  }) =>
      AddressState(
        isSaving:   isSaving   ?? this.isSaving,
        isSuccess:  isSuccess  ?? this.isSuccess,
        savedPhone: savedPhone ?? this.savedPhone,
        error:      clear ? null : (error ?? this.error),
      );
}

class AddressController extends StateNotifier<AddressState> {
  final AddressRepository _repo;

  AddressController(this._repo) : super(const AddressState()) {
    _loadPhone(); // pre-fill phone on init
  }

  Future<void> _loadPhone() async {
    final phone = await _repo.getSavedPhone();
    if (phone.isNotEmpty) state = state.copyWith(savedPhone: phone);
  }

  Future<bool> save({
    required String label,
    required String name,
    required String phone,
    required String house,
    required String address,
    required String pincode,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isSaving: true, clear: true);
    try {
      await _repo.saveAddress(
        label: label, name: name, phone: phone,
        house: house, address: address, pincode: pincode,
        latitude: latitude, longitude: longitude,
      );
      state = state.copyWith(isSaving: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  void clearMessages() => state = state.copyWith(clear: true, isSuccess: false);
}

final addressControllerProvider =
    StateNotifierProvider.autoDispose<AddressController, AddressState>((ref) {
  return AddressController(ref.read(addressRepositoryProvider));
});