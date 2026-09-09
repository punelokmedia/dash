// ignore_for_file: depend_on_referenced_packages, file_names

// ignore: unused_import
import 'package:dash_logistics/features/dashboard/add_gst/domain/models/gstIn_state.dart';
import 'package:dash_logistics/features/dashboard/add_gst/infra/gstRepository.dart';
import 'package:hooks_riverpod/legacy.dart';


class GstinController extends StateNotifier<GstinState> {
  final GstinRepository _repository;

  GstinController(this._repository) : super(const GstinState());

  Future<void> submitGstin(String gstin) async {
    if (gstin.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter your GSTIN.',
        isSuccess: false,
      );
      return;
    }

    // Clear previous errors and set loading
    state = GstinState(isLoading: true);

    try {
      final result = await _repository.submitGstin(gstin.trim());
      state = GstinState(
        isLoading: false,
        gstinData: result,
        isSuccess: true,
      );
    } catch (e) {
      state = GstinState(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  void clearError() {
    state = state.clearError();
  }

  void reset() {
    state = const GstinState();
  }
}