// ignore_for_file: file_names

import 'package:dash_logistics/features/dashboard/add_gst/domain/models/gstIn_model.dart';




class GstinState {
  final bool isLoading;
  final GstinModel? gstinData;
  final String? errorMessage;
  final bool isSuccess;

  const GstinState({
    this.isLoading = false,
    this.gstinData,
    this.errorMessage,
    this.isSuccess = false,
  });

  GstinState copyWith({
    bool? isLoading,
    GstinModel? gstinData,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return GstinState(
      isLoading: isLoading ?? this.isLoading,
      gstinData: gstinData ?? this.gstinData,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  GstinState clearError() {
    return GstinState(
      isLoading: isLoading,
      gstinData: gstinData,
      errorMessage: null,
      isSuccess: isSuccess,
    );
  }

  @override
  String toString() {
    return 'GstinState(isLoading: $isLoading, isSuccess: $isSuccess, error: $errorMessage)';
  }
}