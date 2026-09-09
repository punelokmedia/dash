import 'dart:developer';

import 'package:dash_logistics/features/dashboard/locationpages/domain/contact_formstate.dart';
import 'package:dash_logistics/features/dashboard/locationpages/domain/contact_model.dart';
import 'package:dash_logistics/features/dashboard/locationpages/infra/contact_repo.dart';

import 'package:hooks_riverpod/legacy.dart';

class ContactController extends StateNotifier<ContactState> {
  final ContactRepository repository;

  ContactController(this.repository) : super(const ContactState());

  void updateName(String v)    => state = state.copyWith(name: v);
  void updatePhone(String v)   => state = state.copyWith(phone: v);
  void updateaddress(String v) => state = state.copyWith(address: v);
  void updatePincode(String v) => state = state.copyWith(pincode: v);
  void updateSaveAs(String v)  => state = state.copyWith(saveAs: v);
  void toggleMobile(bool v)    => state = state.copyWith(useMobile: v);
  void clearError()            => state = state.copyWith(errorMessage: null);
  void clearSuccess()          => state = state.copyWith(successMessage: null);

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final model = ContactModel(
        name:      state.name,
        phone:     state.phone,
        address:   state.address,
        pincode:   state.pincode,
        useMobile: state.useMobile,
        saveAs:    state.saveAs,
      );

      await repository.submitContact(model);

      log('Contact submitted: ${model.toJson()}');

      state = state.copyWith(
        isLoading:      false,
        successMessage: 'Contact details saved successfully!',
      );
    } catch (e) {
      log('Contact submit error: $e');
      state = state.copyWith(
        isLoading:    false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final contactControllerProvider =
    StateNotifierProvider<ContactController, ContactState>(
  (ref) => ContactController(ref.read(contactRepositoryProvider)),
);