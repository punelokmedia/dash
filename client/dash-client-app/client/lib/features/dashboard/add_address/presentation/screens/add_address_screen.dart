import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/dashboard/add_address/infra/add_address_controller.dart';
import 'package:dash_logistics/features/dashboard/add_address/presentation/widget/form_fields.dart';
import 'package:dash_logistics/features/dashboard/add_address/presentation/widget/label_selector.dart';
import 'package:dash_logistics/features/dashboard/add_address/presentation/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddAddressScreen extends HookConsumerWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressControllerProvider);
    final controller = ref.read(addressControllerProvider.notifier);

    // Text controllers
    final nameCtrl = useTextEditingController(keys: const []);
    final phoneCtrl = useTextEditingController();
    final houseCtrl = useTextEditingController(keys: const []);
    final addressCtrl = useTextEditingController(keys: const []);
    final pincodeCtrl = useTextEditingController(keys: const []);
    final latCtrl = useTextEditingController(keys: const []);
    final lngCtrl = useTextEditingController(keys: const []);
    final selectedLabel = useState('Home');

    useEffect(() {
      if (state.savedPhone.isNotEmpty && phoneCtrl.text.isEmpty) {
        phoneCtrl.text = state.savedPhone;
        phoneCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneCtrl.text.length),
        );
      }
      return null;
    }, [state.savedPhone]); // ← only fires when savedPhone changes

    // Listen for success / error
    ref.listen(addressControllerProvider, (_, next) {
      if (next.error != null) {
        SnackbarHelper.showError(context,next.error!);
        controller.clearMessages();
      }
      if (next.isSuccess) {
        SnackbarHelper.showSuccess(context,'✅ Address saved successfully!');
        controller.clearMessages();
        context.pop();
      }
    });


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16.w,
          20.h,
          16.w,
          MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label chips: Home / Work / Other ────────────────────────
            FormSection('Save As'),
            LabelSelector(
              selected: selectedLabel.value,
              onSelect: (l) => selectedLabel.value = l,
            ),

            SizedBox(height: 20.h),

            // ── Personal Info ────────────────────────────────────────────
            FormSection('Personal Info'),
            AddressField(ctrl: nameCtrl, hint: 'Full Name'),
            SizedBox(height: 12.h),
            AddressField(
              ctrl: phoneCtrl,
              hint: 'Mobile Number',
              keyboardType: TextInputType.phone,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),

            SizedBox(height: 20.h),

            // ── Address Details ──────────────────────────────────────────
            FormSection('Address Details'),
            AddressField(
              ctrl: houseCtrl,
              hint: 'House / Flat / Shop',
              optional: true,
            ),
            SizedBox(height: 12.h),
            AddressField(ctrl: addressCtrl, hint: 'Street / Area / Locality'),
            SizedBox(height: 12.h),
            AddressField(
              ctrl: pincodeCtrl,
              hint: 'Pincode',
              keyboardType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),

            SizedBox(height: 20.h),

            // ── Coordinates ──────────────────────────────────────────────
            FormSection('Coordinates'),
            LatLngRow(latCtrl: latCtrl, lngCtrl: lngCtrl),

            SizedBox(height: 20.h),

            // ── Payload preview ──────────────────────────────────────────
            // PayloadPreview(payload: payload),

            SizedBox(height: 20.h),

            // ── Save button ──────────────────────────────────────────────
            SaveButton(
              isSaving: state.isSaving,
              onTap: () => _onSave(
                context: context,
                controller: controller,
                label: selectedLabel.value,
                nameCtrl: nameCtrl,
                phoneCtrl: phoneCtrl,
                houseCtrl: houseCtrl,
                addressCtrl: addressCtrl,
                pincodeCtrl: pincodeCtrl,
                latCtrl: latCtrl,
                lngCtrl: lngCtrl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: AppColors.lemon,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      'Add Address',
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: AppTextStyles.fontFamilyRoboto,
      ),
    ),
  );

  void _onSave({
    required BuildContext context,
    required AddressController controller,
    required String label,
    required TextEditingController nameCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController houseCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController pincodeCtrl,
    required TextEditingController latCtrl,
    required TextEditingController lngCtrl,
  }) {
    // Validation
    if (nameCtrl.text.trim().isEmpty) {
      _snack(context, 'Name is required.');
      return;
    }
    if (phoneCtrl.text.trim().length < 10) {
      _snack(context, 'Enter a valid 10-digit number.');
      return;
    }
    if (addressCtrl.text.trim().isEmpty) {
      _snack(context, 'Address is required.');
      return;
    }

    controller.save(
      label: label,
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      house: houseCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      pincode: pincodeCtrl.text.trim(),
      latitude: double.tryParse(latCtrl.text.trim()) ?? 0.0,
      longitude: double.tryParse(lngCtrl.text.trim()) ?? 0.0,
    );
  }

  void _snack(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
      );
}
