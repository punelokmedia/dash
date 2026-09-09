import 'dart:developer';
import 'dart:io';

import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart'
    show StateNotifier; // ✅ NOT legacy.dart

enum VehicleCategory { twoWheeler, threeWheeler, fourWheeler }

enum VehicleType { bike, scooter, auto, miniTruck, truck }

enum BodyType { open, close }

enum FuelType { petrol, cng, ev, diesel }

enum SubmissionStep {
  idle,
  uploadingDetails,
  uploadingImage,
  uploadingDocument,
}

class VehicleRegistrationState {
  final VehicleCategory? selectedCategory;
  final VehicleType? selectedVehicleType;
  final BodyType? selectedBodyType;
  final FuelType? selectedFuelType;
  final String? vehicleCompanyModel;
  final String vehicleNumber;
  final String registrationNumber;
  final String dateOfManufacture;
  final String documentType;
  final File? vehicleImage;
  final File? vehicleDocument;
  final bool isSubmitting;
  final SubmissionStep submissionStep;
  final String? errorMessage;
  final bool isSuccess;

  const VehicleRegistrationState({
    this.selectedCategory,
    this.selectedVehicleType,
    this.selectedBodyType,
    this.selectedFuelType,
    this.vehicleCompanyModel,
    this.vehicleNumber = '',
    this.registrationNumber = '',
    this.dateOfManufacture = '',
    this.documentType = 'Vehicle RC',
    this.vehicleImage,
    this.vehicleDocument,
    this.isSubmitting = false,
    this.submissionStep = SubmissionStep.idle,
    this.errorMessage,
    this.isSuccess = false,
  });

  VehicleRegistrationState copyWith({
    bool clearCategory = false,
    VehicleCategory? selectedCategory,
    bool clearVehicleType = false,
    VehicleType? selectedVehicleType,
    bool clearBodyType = false,
    BodyType? selectedBodyType,
    bool clearFuelType = false,
    FuelType? selectedFuelType,
    bool clearCompanyModel = false,
    String? vehicleCompanyModel,
    String? vehicleNumber,
    String? registrationNumber,
    String? dateOfManufacture,
    String? documentType,
    bool clearVehicleImage = false,
    File? vehicleImage,
    bool clearVehicleDocument = false,
    File? vehicleDocument,
    bool? isSubmitting,
    SubmissionStep? submissionStep,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return VehicleRegistrationState(
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedVehicleType: clearVehicleType
          ? null
          : (selectedVehicleType ?? this.selectedVehicleType),
      selectedBodyType: clearBodyType
          ? null
          : (selectedBodyType ?? this.selectedBodyType),
      selectedFuelType: clearFuelType
          ? null
          : (selectedFuelType ?? this.selectedFuelType),
      vehicleCompanyModel: clearCompanyModel
          ? null
          : (vehicleCompanyModel ?? this.vehicleCompanyModel),
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      dateOfManufacture: dateOfManufacture ?? this.dateOfManufacture,
      documentType: documentType ?? this.documentType,
      vehicleImage: clearVehicleImage
          ? null
          : (vehicleImage ?? this.vehicleImage),
      vehicleDocument: clearVehicleDocument
          ? null
          : (vehicleDocument ?? this.vehicleDocument),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionStep: submissionStep ?? this.submissionStep,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// ─────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────
class VehicleRegistrationNotifier
    extends StateNotifier<VehicleRegistrationState> {
  final Ref _ref; // ✅ Ref injected via constructor

  VehicleRegistrationNotifier(this._ref) : super(VehicleRegistrationState());

  // ── Selection ────────────────────────────────────────────────────────────
  void selectCategory(VehicleCategory category) =>
      state = state.copyWith(selectedCategory: category);
  void clearCategory() => state = state.copyWith(clearCategory: true);
  void selectVehicleType(VehicleType type) =>
      state = state.copyWith(selectedVehicleType: type);
  void clearVehicleType() => state = state.copyWith(clearVehicleType: true);
  void selectBodyType(BodyType body) =>
      state = state.copyWith(selectedBodyType: body);
  void clearBodyType() => state = state.copyWith(clearBodyType: true);
  void selectFuelType(FuelType fuel) =>
      state = state.copyWith(selectedFuelType: fuel);
  void clearFuelType() => state = state.copyWith(clearFuelType: true);

  // ── Text fields ──────────────────────────────────────────────────────────
  void setCompanyModel(String value) =>
      state = state.copyWith(vehicleCompanyModel: value);
  void clearCompanyModel() => state = state.copyWith(clearCompanyModel: true);
  void setVehicleNumber(String value) =>
      state = state.copyWith(vehicleNumber: value);
  void setRegistrationNumber(String value) =>
      state = state.copyWith(registrationNumber: value);
  void setDateOfManufacture(String value) =>
      state = state.copyWith(dateOfManufacture: value);
  void setDocumentType(String value) =>
      state = state.copyWith(documentType: value);

  // ── Files ────────────────────────────────────────────────────────────────
  void setVehicleImage(File file) => state = state.copyWith(vehicleImage: file);
  void clearVehicleImage() => state = state.copyWith(clearVehicleImage: true);
  void setVehicleDocument(File file) =>
      state = state.copyWith(vehicleDocument: file);
  void clearVehicleDocument() =>
      state = state.copyWith(clearVehicleDocument: true);

  // ─── API ─────────────────────────────────────────────────────────────────
  Future<bool> submitRegistration() async {
    if (state.vehicleImage == null) {
      state = state.copyWith(errorMessage: 'Please upload a vehicle photo.');
      return false;
    }
    if (state.vehicleDocument == null) {
      state = state.copyWith(
        errorMessage: 'Please upload the vehicle RC document.',
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      submissionStep: SubmissionStep.uploadingDetails,
    );

    try {
      final dio = _ref.read(dioClientProvider);
      final token = await SecureStorageService.getToken();

      // ✅ validateStatus: never throw — handle status codes manually
      final baseOptions = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        validateStatus: (status) => true, // ✅ stops Dio throwing on 400/500
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      );

      // ── STEP 1: Details — send as JSON, NOT FormData ───────────────────────
      state = state.copyWith(submissionStep: SubmissionStep.uploadingDetails);

      final detailsRes = await dio.post(
        APIEndpoints.vehicle,
        // ✅ JSON body — most REST APIs expect this for text fields
        data: {
          'vehicle_type': state.selectedVehicleType?.name ?? '',
          'vehicle_body_type': state.selectedBodyType?.name ?? '',
          'vehicle_fuel_type': state.selectedFuelType?.name ?? '',
          'vehicle_brand_name': state.vehicleCompanyModel ?? '',
          'vehicle_number': state.vehicleNumber,
          'vehicle_registration_number': state.registrationNumber,
          'manufacture_in': state.dateOfManufacture,
        },
        options: baseOptions.copyWith(
          // ✅ Explicitly tell server we're sending JSON
          headers: {
            ...?baseOptions.headers,
            'Content-Type': 'application/json',
          },
        ),
      );

      // ✅ Now we can actually check status codes
      log('Step 1 status: ${detailsRes.statusCode}');
      log('Step 1 body: ${detailsRes.data}'); // ← shows exact server error

      if (!_isSuccess(detailsRes.statusCode)) {
        final msg =
            _extractError(detailsRes.data) ??
            'Failed to submit vehicle details (${detailsRes.statusCode})';
        state = state.copyWith(
          isSubmitting: false,
          submissionStep: SubmissionStep.idle,
          errorMessage: msg,
        );
        return false;
      }
      log('✅ Step 1 done');

      // ── STEP 2: Vehicle image — FormData is correct here ──────────────────
      state = state.copyWith(submissionStep: SubmissionStep.uploadingImage);

      final imageRes = await dio.post(
        APIEndpoints.uploadvehiclephoto,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            state.vehicleImage!.path,
            filename: 'vehicle_image.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
        }),
        options: baseOptions,
      );

      log('Step 2 status: ${imageRes.statusCode}');
      log('Step 2 body: ${imageRes.data}');

      if (!_isSuccess(imageRes.statusCode)) {
        final msg =
            _extractError(imageRes.data) ??
            'Failed to upload vehicle image (${imageRes.statusCode})';
        state = state.copyWith(
          isSubmitting: false,
          submissionStep: SubmissionStep.idle,
          errorMessage: msg,
        );
        return false;
      }
      log('✅ Step 2 done');

      // ── STEP 3: Vehicle document ───────────────────────────────────────────
      state = state.copyWith(submissionStep: SubmissionStep.uploadingDocument);

      final docRes = await dio.post(
        APIEndpoints.uploadvehicledocument,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            state.vehicleDocument!.path,
            filename: 'vehicle_rc.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
          'documentType': state.documentType,
        }),
        options: baseOptions,
      );

      log('Step 3 status: ${docRes.statusCode}');
      log('Step 3 body: ${docRes.data}');

      if (!_isSuccess(docRes.statusCode)) {
        final msg =
            _extractError(docRes.data) ??
            'Failed to upload RC document (${docRes.statusCode})';
        state = state.copyWith(
          isSubmitting: false,
          submissionStep: SubmissionStep.idle,
          errorMessage: msg,
        );
        return false;
      }
      log('✅ Step 3 done');

      state = state.copyWith(
        isSubmitting: false,
        submissionStep: SubmissionStep.idle,
        isSuccess: true,
      );
      return true;
    } on DioException catch (e) {
      log('DioException: ${e.message} | response: ${e.response?.data}');
      state = state.copyWith(
        isSubmitting: false,
        submissionStep: SubmissionStep.idle,
        errorMessage: e.message ?? 'Network error. Please try again.',
      );
      return false;
    } catch (e) {
      log('Unknown error: $e');
      state = state.copyWith(
        isSubmitting: false,
        submissionStep: SubmissionStep.idle,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  bool _isSuccess(int? code) => code != null && code >= 200 && code < 300;

  // ✅ Extracts server error message from common response shapes
  String? _extractError(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return (data['message'] ?? data['error'] ?? data['msg'])?.toString();
    }
    return data.toString();
  }
}
