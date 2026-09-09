import 'dart:io';
import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/infra/vehicle_registration.dart';
import 'package:delivary_partner/authentication/registration/presentation/bank_details_screen.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:delivary_partner/authentication/registration/shared/vehicle_registration.dart';
import 'package:delivary_partner/core/constant/my_colors.dart' show AppColors;
import 'package:delivary_partner/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHARED BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class GreenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const GreenButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 51.h,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.commonColorgreen
              : AppColors.commonColorgreen,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 1 — Vehicle Category Selection
// ─────────────────────────────────────────────────────────────────────────────

class VehicleTypeSelectionScreen extends HookConsumerWidget {
  const VehicleTypeSelectionScreen({super.key});

  static final List<_CategoryItemData> _categories = [
    _CategoryItemData(
      label: '2 Wheeler',
      cat: VehicleCategory.twoWheeler,
      icon: Assets.svg.two_wheeler.path,
    ),
    _CategoryItemData(
      label: '3 Wheeler',
      cat: VehicleCategory.threeWheeler,
      icon: Assets.svg.scooter.path,
    ),
    _CategoryItemData(
      label: '4 Wheeler',
      cat: VehicleCategory.fourWheeler,
      icon: Assets.svg.mdi_truck.path,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleRegistrationProvider);
    final notifier = ref.read(vehicleRegistrationProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;

    final truckController = useAnimationController(
      duration: const Duration(seconds: 9),
    )..repeat();
    final truckAnim = useAnimation(
      Tween<double>(
        begin: -screenWidth,
        end: screenWidth * 0.9,
      ).animate(CurvedAnimation(parent: truckController, curve: Curves.linear)),
    );

    final scooterController = useAnimationController(
      duration: const Duration(seconds: 8),
    )..repeat();
    final scooterAnim = useAnimation(
      Tween<double>(begin: screenWidth * 0.9, end: -screenWidth * 0.9).animate(
        CurvedAnimation(parent: scooterController, curve: Curves.linear),
      ),
    );
    final planeController = useAnimationController(
      duration: const Duration(seconds: 10),
    )..repeat();

    // ✅ Phase 1 (0–40%): taxis on ground slow
    // ✅ Phase 2 (40–100%): accelerates across screen
    final planeX = useAnimation(
      TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: -100, end: screenWidth * 0.3),
          weight: 40, // slow taxi
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: screenWidth * 0.3,
            end: screenWidth + 200,
          ),
          weight: 60, // accelerate on takeoff
        ),
      ]).animate(
        CurvedAnimation(parent: planeController, curve: Curves.easeIn),
      ),
    );

    // ✅ Phase 1 (0–40%): stays on ground (road level)
    // ✅ Phase 2 (40–100%): lifts off and climbs into sky
    final planeY = useAnimation(
      TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 62.h, end: 62.h), // stays flat on road
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 120.h, end: 280.h), // lifts into sky
          weight: 60,
        ),
      ]).animate(
        CurvedAnimation(parent: planeController, curve: Curves.linear),
      ),
    );

    // ✅ Stays full size on ground, shrinks as it climbs away
    final planeScale = useAnimation(
      TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ), // grows slightly on throttle
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.25), // shrinks into sky
          weight: 60,
        ),
      ]).animate(
        CurvedAnimation(parent: planeController, curve: Curves.easeOut),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // ── App bar ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Navigator.maybePop(context),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Vehicle Registration',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.commonText,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 44.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Text(
                  'Submit your Vehicle Registration details to\n'
                  'ensure compliance and access essential \nservices'
                  'related to your vehicle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(113, 112, 114, 1),
                  ),
                ),
              ),
            ),

            SizedBox(height: 58.h),

            // ── Category list ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: _categories
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _CategoryItem(
                          data: item,
                          selectedCategory: state.selectedCategory,
                          onTap: (cat) {
                            notifier.selectCategory(cat);
                            // context.goNamed(AppRoutesName.vehicleDetailPageName);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VehicleDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // ── Road animation ─────────────────────────────────────────────
            Expanded(
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 52.h,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/png/skyline.png',
                        height: 289.h,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // ✅ Plane — flies diagonally up into the sky
                    Positioned(
                      bottom: planeY,
                      left: planeX,
                      child: Transform.scale(
                        scale: planeScale,
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/png/aeroplane.png',
                          height: 50.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 105.h,
                        color: const Color(0xFF2C2C2C),
                        child: CustomPaint(painter: _DashedLinePainter()),
                      ),
                    ),
                    Positioned(
                      bottom: 56.h,
                      left: truckAnim,
                      child: Image.asset(
                        'assets/images/png/truckb.png',
                        height: 60.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 15.h,
                      left: scooterAnim,
                      child: Image.asset(
                        'assets/images/png/Frame.png',
                        height: 40.h,

                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    const dashWidth = 20.0;
    const dashSpace = 14.0;
    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CategoryItemData {
  final String label;
  final VehicleCategory cat;
  final String icon;
  const _CategoryItemData({
    required this.label,
    required this.cat,
    required this.icon,
  });
}

class _CategoryItem extends StatelessWidget {
  final _CategoryItemData data;
  final VehicleCategory? selectedCategory;
  final void Function(VehicleCategory) onTap;

  const _CategoryItem({
    required this.data,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedCategory == data.cat;
    return GestureDetector(
      onTap: () => onTap(data.cat),
      child: Container(
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 243, 243, 1),
          borderRadius: BorderRadius.circular(30.r),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(data.icon, width: 32.w, height: 32.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip data models
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleTypeItem {
  final String label;
  final IconData icon;
  final VehicleType type;
  const _VehicleTypeItem(this.label, this.icon, this.type);
}

class _BodyTypeItem {
  final String label;
  final IconData icon;
  final BodyType type;
  const _BodyTypeItem(this.label, this.icon, this.type);
}

class _FuelTypeItem {
  final String label;
  final IconData icon;
  final FuelType type;
  const _FuelTypeItem(this.label, this.icon, this.type);
}

const _truckTabVehicleTypes = [
  _VehicleTypeItem(
    '4 Wheeler',
    Icons.local_shipping_rounded,
    VehicleType.miniTruck,
  ),
  _VehicleTypeItem(
    '3 Wheeler',
    Icons.electric_rickshaw_rounded,
    VehicleType.auto,
  ),
];
const _twoWheelerTabVehicleTypes = [
  _VehicleTypeItem('2 Wheeler', Icons.two_wheeler_rounded, VehicleType.bike),
];

const _twoWheelerBodyTypes = [
  _BodyTypeItem('Bike', Icons.two_wheeler, BodyType.open),
  _BodyTypeItem('Scooter', Icons.electric_scooter, BodyType.close),
];
const _otherBodyTypes = [
  _BodyTypeItem('Open', Icons.local_shipping_outlined, BodyType.open),
  _BodyTypeItem('Close', Icons.inventory_2_outlined, BodyType.close),
];

const _twoWheelerFuelTypes = [
  _FuelTypeItem('Petrol', Icons.local_gas_station_rounded, FuelType.petrol),
  _FuelTypeItem('CNG', Icons.gas_meter_rounded, FuelType.cng),
  _FuelTypeItem('EV', Icons.electric_bolt_rounded, FuelType.ev),
];
const _truckFuelTypes = [
  _FuelTypeItem('Petrol', Icons.local_gas_station_rounded, FuelType.petrol),
  _FuelTypeItem('CNG', Icons.gas_meter_rounded, FuelType.cng),
  _FuelTypeItem('Diesel', Icons.oil_barrel_rounded, FuelType.diesel),
];

enum _DetailsTab { truck, twoWheeler }

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 2 — Vehicle Details
// ─────────────────────────────────────────────────────────────────────────────

class VehicleDetailsScreen extends HookConsumerWidget {
  const VehicleDetailsScreen({super.key});

  static String? _validate(VehicleRegistrationState s) {
    if (s.selectedVehicleType == null) return 'Please select a vehicle type.';
    if (s.selectedBodyType == null) return 'Please select a body type.';
    if (s.selectedFuelType == null) return 'Please select a fuel type.';
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleRegistrationProvider);
    final notifier = ref.read(vehicleRegistrationProvider.notifier);

    final activeTab = useState<_DetailsTab>(
      state.selectedCategory == VehicleCategory.twoWheeler
          ? _DetailsTab.twoWheeler
          : _DetailsTab.truck,
    );
    final validationError = useState<String?>(null);

    void switchTab(_DetailsTab tab) {
      activeTab.value = tab;
      validationError.value = null;
      notifier.clearVehicleType();
      notifier.clearBodyType();
      notifier.clearFuelType();
      notifier.clearCompanyModel();
      notifier.selectCategory(
        tab == _DetailsTab.twoWheeler
            ? VehicleCategory.twoWheeler
            : VehicleCategory.fourWheeler,
      );
    }

    final isTwoWheeler = activeTab.value == _DetailsTab.twoWheeler;
    final vehicleTypes = isTwoWheeler
        ? _twoWheelerTabVehicleTypes
        : _truckTabVehicleTypes;
    final bodyTypes = isTwoWheeler ? _twoWheelerBodyTypes : _otherBodyTypes;
    final fuelTypes = isTwoWheeler ? _twoWheelerFuelTypes : _truckFuelTypes;

    return Scaffold(
      backgroundColor: const Color(0xFF8DC63F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 4.h),
            child: Center(
              child: Image.asset(
                'assets/images/png/dash_logo.png',
                height: 80.h,
                width: 140.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Vehicle Details',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8DC63F),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),

                        _SectionLabel('Vehicle Type'),
                        SizedBox(height: 10.h),
                        _TwoTabBar(
                          active: activeTab.value,
                          onSwitch: switchTab,
                        ),
                        SizedBox(height: 18.h),

                        _SectionLabel('Select Vehicle Type'),
                        SizedBox(height: 10.h),
                        ...vehicleTypes.map(
                          (item) => _VehicleTypeCard(
                            item: item,
                            isSelected: state.selectedVehicleType == item.type,
                            onTap: () {
                              notifier.selectVehicleType(item.type);
                              notifier.clearBodyType();
                              notifier.clearFuelType();
                              validationError.value = null;
                            },
                          ),
                        ),
                        SizedBox(height: 18.h),

                        if (state.selectedVehicleType != null) ...[
                          _SectionLabel('Select Body Type'),
                          SizedBox(height: 10.h),
                          _BodyTypeRow(
                            items: bodyTypes,
                            selected: state.selectedBodyType,
                            onSelect: (b) {
                              notifier.selectBodyType(b);
                              validationError.value = null;
                            },
                          ),
                          SizedBox(height: 18.h),
                        ],

                        if (state.selectedBodyType != null) ...[
                          _SectionLabel('Vehicle company Brand & model'),
                          SizedBox(height: 10.h),
                          _BrandModelDropdown(
                            value: state.vehicleCompanyModel,
                            onChanged: (val) =>
                                notifier.setCompanyModel(val ?? ''),
                          ),
                          SizedBox(height: 18.h),
                        ],

                        _SectionLabel('Select the vehicle fuel type'),
                        SizedBox(height: 10.h),
                        _FuelTypeRow(
                          items: fuelTypes,
                          selected: state.selectedFuelType,
                          onSelect: (f) {
                            notifier.selectFuelType(f);
                            validationError.value = null;
                          },
                        ),
                        SizedBox(height: 30.h),

                        if (validationError.value != null) ...[
                          _InlineError(message: validationError.value!),
                          SizedBox(height: 12.h),
                        ],

                        GreenButton(
                          label: 'Next',
                          onTap: () {
                            final err = _validate(state);
                            if (err != null) {
                              validationError.value = err;
                              return;
                            }
                            validationError.value = null;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VehicleDocumentScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 3 — Vehicle Document Upload + Final Submit
// ─────────────────────────────────────────────────────────────────────────────

class VehicleDocumentScreen extends HookConsumerWidget {
  const VehicleDocumentScreen({super.key});

  static String? _validate(VehicleRegistrationState s) {
    if (s.vehicleDocument == null) {
      return 'Please upload your vehicle RC document.';
    }
    if (s.registrationNumber.trim().isEmpty) {
      return 'Please enter the registration number.';
    }
    if (s.dateOfManufacture.trim().isEmpty) {
      return 'Please select the date of manufacture.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleRegistrationProvider);
    final notifier = ref.read(vehicleRegistrationProvider.notifier);

    final regController = useTextEditingController(
      text: state.registrationNumber,
    );
    final vehicleController = useTextEditingController(
      text: state.vehicleNumber,
    );
    final dateController = useTextEditingController(
      text: state.dateOfManufacture,
    );

    final picker = useMemoized(() => ImagePicker());
    final isPickerActive = useState(false);
    final validationError = useState<String?>(null);

    // ── Safe image picker ──────────────────────────────────────────────────
    Future<void> safePick({
      required ImageSource source,
      required void Function(File file) onPicked,
    }) async {
      if (isPickerActive.value) return;
      isPickerActive.value = true;
      try {
        final xFile = await picker.pickImage(source: source, imageQuality: 80);
        if (xFile != null) onPicked(File(xFile.path));
      } catch (e) {
        debugPrint('Image picker error: $e');
      } finally {
        isPickerActive.value = false;
      }
    }

    //
    String? validate(VehicleRegistrationState s) {
      if (s.vehicleImage == null) return 'Please upload a vehicle photo.';
      if (s.vehicleDocument == null) {
        return 'Please upload your vehicle RC document.';
      }
      if (s.vehicleNumber.trim().isEmpty) {
        return 'Please enter the vehicle number.';
      }
      if (s.registrationNumber.trim().isEmpty) {
        return 'Please enter the registration number.';
      }
      if (s.dateOfManufacture.trim().isEmpty) {
        return 'Please select the date of manufacture.';
      }
      return null;
    }

    Future<void> pickVehicleImageGallery() => safePick(
      source: ImageSource.gallery,
      onPicked: notifier.setVehicleImage,
    );
    Future<void> pickVehicleImageCamera() => safePick(
      source: ImageSource.camera,
      onPicked: notifier.setVehicleImage,
    );
    Future<void> pickDocument() => safePick(
      source: ImageSource.gallery,
      onPicked: notifier.setVehicleDocument,
    );

    // ── Submit — advance step on success ──────────────────────────────────
    // Future<void> handleSubmit() async {
    //   final err = _validate(state);
    //   if (err != null) {
    //     validationError.value = err;
    //     return;
    //   }
    //   validationError.value = null;

    //   final ok = await notifier.submitRegistration();
    //   if (!context.mounted) return;

    //   if (ok) {
    //     await ref
    //         .read(registrationProgressProvider.notifier)
    //         .advance(RegistrationStep.bankDetails);
    //   }
    // }
    Future<void> handleSubmit() async {
      final err = validate(state);
      if (err != null) {
        validationError.value = err;
        return;
      }
      validationError.value = null;

      final ok = await notifier.submitRegistration();
      if (!context.mounted) return;

      if (ok) {
        await ref
            .read(registrationProgressProvider.notifier)
            .advance(RegistrationStep.bankDetails);

        // ✅ Add navigation here
        // context.go(AppRoutesName.bankDetailPageName); // if using GoRouter named route
        // OR
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BankDetailsScreen()),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8DC63F),
      body: Column(
        children: [
          SizedBox(height: 30.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Vehicle Registration',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8DC63F),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // ── Vehicle image ──────────────────────────────────
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: pickVehicleImageGallery,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textMedium,
                                      ),
                                    ),
                                  ),
                                  if (state.vehicleImage != null)
                                    TextButton(
                                      onPressed: notifier.clearVehicleImage,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: pickVehicleImageGallery,
                                    child: Container(
                                      width: 280.w,
                                      height: 209.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBg,
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                            129,
                                            196,
                                            93,
                                            1,
                                          ),
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                      ),
                                      child: state.vehicleImage != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(13.r),
                                              child: Image.file(
                                                state.vehicleImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/png/green_scooter.png',
                                                  fit: BoxFit.cover,
                                                  height: 168.h,
                                                  width: 226.w,
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  'Tap to upload vehicle photo',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: AppColors.textLight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 130.w,
                                    bottom: 20.h,
                                    child: GestureDetector(
                                      onTap: pickVehicleImageCamera,
                                      child: Container(
                                        padding: EdgeInsets.all(6.w),
                                        child: SvgPicture.asset(
                                          'assets/svg/camera.svg',
                                          fit: BoxFit.contain,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // ── RC document ────────────────────────────────────
                        _fieldLabel('Select Vehicle Document'),
                        GestureDetector(
                          onTap: pickDocument,
                          child: _fieldBox(
                            hasError:
                                state.vehicleDocument == null &&
                                validationError.value != null,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.vehicleDocument != null
                                        ? 'Document uploaded ✓'
                                        : 'Vehicle RC *',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: state.vehicleDocument != null
                                          ? AppColors.primary
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 23.sp,
                                  color: AppColors.textLight,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        _fieldLabel('Vehicle Number'),
                        _textField(
                          controller: vehicleController,
                          hint: 'Enter No (1HGBH41JXMN109186)',
                          onChanged: (v) {
                            notifier.setVehicleNumber(v);
                            if (validationError.value != null) {
                              validationError.value = null;
                            }
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ── Registration number ────────────────────────────
                        _fieldLabel('Vehicle Register Number'),
                        _textField(
                          controller: regController,
                          hint: 'Enter the Number (MH 00 SR 1234)',
                          onChanged: (v) {
                            notifier.setRegistrationNumber(v);
                            if (validationError.value != null) {
                              validationError.value = null;
                            }
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ── Date of manufacture ────────────────────────────
                        _fieldLabel('Date of Manufacture'),
                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2020),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              builder: (ctx, child) => Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (date != null) {
                              final formatted =
                                  '${date.day.toString().padLeft(2, '0')}/'
                                  '${date.month.toString().padLeft(2, '0')}/'
                                  '${date.year}';
                              dateController.text = formatted;
                              notifier.setDateOfManufacture(formatted);
                              validationError.value = null;
                            }
                          },
                          child: AbsorbPointer(
                            child: _textField(
                              controller: dateController,
                              hint: 'Select Date',
                              suffix: const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Fuel type (read-only summary) ──────────────────
                        _fieldLabel('Fuel Type'),
                        _fieldBox(
                          child: Text(
                            state.selectedFuelType?.name.capitalize() ??
                                'Not selected',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: state.selectedFuelType != null
                                  ? AppColors.textDark
                                  : const Color.fromRGBO(169, 169, 169, 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // ── Validation error ───────────────────────────────
                        if (validationError.value != null) ...[
                          _InlineError(message: validationError.value!),
                          SizedBox(height: 12.h),
                        ],

                        // ── API error (from notifier) ──────────────────────
                        if (state.errorMessage != null) ...[
                          _InlineError(message: state.errorMessage!),
                          SizedBox(height: 12.h),
                        ],

                        // ── Submit ─────────────────────────────────────────
                        // Replace the submit GreenButton with this:
                        Consumer(
                          builder: (context, ref, _) {
                            final step = ref.watch(
                              vehicleRegistrationProvider.select(
                                (s) => s.submissionStep,
                              ),
                            );

                            final stepLabel = switch (step) {
                              SubmissionStep.uploadingDetails =>
                                'Saving details...',
                              SubmissionStep.uploadingImage =>
                                'Uploading image...',
                              SubmissionStep.uploadingDocument =>
                                'Uploading document...',
                              SubmissionStep.idle => 'Submit',
                            };

                            return GreenButton(
                              label: stepLabel,
                              isLoading: state.isSubmitting,
                              onTap: handleSubmit,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Field helpers ──────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 18.sp,
        color: const Color.fromRGBO(138, 138, 138, 1),
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _fieldBox({required Widget child, bool hasError = false}) => Container(
    height: 53.h,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(20.r),
      border: hasError
          ? Border.all(color: Colors.red.shade300)
          : Border.all(color: Colors.transparent),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    Function(String)? onChanged,
    Widget? suffix,
  }) => Container(
    height: 53.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 10,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: 13.sp, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: const Color.fromRGBO(169, 169, 169, 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: InputBorder.none,
        suffixIcon: suffix,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: 2.w),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(138, 138, 138, 1),
      ),
    ),
  );
}

class _InlineError extends StatelessWidget {
  final String message;
  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.red.shade200),
    ),
    child: Row(
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 18.sp,
          color: Colors.red.shade600,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 13.sp, color: Colors.red.shade700),
          ),
        ),
      ],
    ),
  );
}

class _TwoTabBar extends StatelessWidget {
  final _DetailsTab active;
  final ValueChanged<_DetailsTab> onSwitch;
  const _TwoTabBar({required this.active, required this.onSwitch});

  @override
  Widget build(BuildContext context) => Container(
    height: 52.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        _TabItem(
          icon: Icons.local_shipping_rounded,
          label: 'Truck',
          isActive: active == _DetailsTab.truck,
          isFirst: true,
          isLast: false,
          onTap: () => onSwitch(_DetailsTab.truck),
        ),
        _TabItem(
          icon: Icons.electric_scooter_rounded,
          label: '2 Wheeler',
          isActive: active == _DetailsTab.twoWheeler,
          isFirst: false,
          isLast: true,
          onTap: () => onSwitch(_DetailsTab.twoWheeler),
        ),
      ],
    ),
  );
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isFirst
        ? BorderRadius.only(
            topLeft: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
          )
        : isLast
        ? BorderRadius.only(
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          )
        : BorderRadius.zero;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          curve: Curves.easeOut,
          height: double.infinity,
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.commonColorgreen,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8DC63F).withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                )
              : BoxDecoration(color: Colors.white, borderRadius: radius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isActive ? Colors.white : const Color(0xFFBBBBBB),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive ? Colors.white : const Color(0xFFAAAAAA),
                ),
              ),
              if (isActive) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleTypeCard extends StatelessWidget {
  final _VehicleTypeItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _VehicleTypeCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 60.h,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.commonColorgreen : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: isSelected
            ? Border.all(color: const Color(0xFF8DC63F), width: 1.5)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 22.sp,
            color: isSelected
                ? Colors.white
                : const Color.fromRGBO(169, 169, 169, 1),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : const Color.fromRGBO(169, 169, 169, 1),
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_rounded, size: 18, color: Colors.white),
        ],
      ),
    ),
  );
}

class _BodyTypeRow extends StatelessWidget {
  final List<_BodyTypeItem> items;
  final BodyType? selected;
  final ValueChanged<BodyType> onSelect;
  const _BodyTypeRow({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: items.asMap().entries.map((e) {
      final idx = e.key;
      final item = e.value;
      final isSel = selected == item.type;
      return Expanded(
        child: GestureDetector(
          onTap: () => onSelect(item.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52.h,
            margin: EdgeInsets.only(right: idx < items.length - 1 ? 10.w : 0),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSel ? AppColors.commonColorgreen : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: isSel
                  ? Border.all(color: const Color(0xFF8DC63F), width: 1.5)
                  : Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20.sp,
                  color: isSel
                      ? Colors.white
                      : const Color.fromRGBO(169, 169, 169, 1),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: isSel
                          ? Colors.white
                          : const Color.fromRGBO(169, 169, 169, 1),
                    ),
                  ),
                ),
                if (isSel)
                  const Icon(
                    Icons.check_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}

class _BrandModelDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  static const _brands = [
    'Hero',
    'Honda',
    'Bajaj',
    'TVS',
    'Yamaha',
    'Suzuki',
    'Mahindra',
    'Tata',
    'Ashok Leyland',
    'Maruti',
    'Ape (Piaggio)',
    'Other',
  ];

  const _BrandModelDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // ✅ Derive selection state from value directly
    final bool isSelected = value != null;

    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        // ✅ Switches color when a brand is picked
        color: isSelected ? AppColors.commonColorgreen : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Select brand & model',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color.fromRGBO(169, 169, 169, 1),
            ),
          ),

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22.sp,
            // ✅ White icon on green, dark icon on white
            color: isSelected ? Colors.white : AppColors.textLight,
          ),

          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          items: _brands
              .map(
                (b) => DropdownMenuItem(
                  value: b,
                  child: Text(
                    b,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      // ✅ White only when selected, dark when placeholder shown
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _FuelTypeRow extends StatelessWidget {
  final List<_FuelTypeItem> items;
  final FuelType? selected;
  final ValueChanged<FuelType> onSelect;
  const _FuelTypeRow({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: items.asMap().entries.map((e) {
      final idx = e.key;
      final item = e.value;
      final isSel = selected == item.type;
      return Expanded(
        child: GestureDetector(
          onTap: () => onSelect(item.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 44.h,
            margin: EdgeInsets.only(right: idx < items.length - 1 ? 8.w : 0),
            decoration: BoxDecoration(
              color: isSel ? AppColors.commonColorgreen : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 15.sp,
                  color: isSel ? Colors.white : AppColors.textLight,
                ),
                SizedBox(width: 5.w),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isSel ? Colors.white : AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
