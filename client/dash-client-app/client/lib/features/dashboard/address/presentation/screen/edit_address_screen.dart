import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_controller.dart';
import 'package:dash_logistics/features/dashboard/address/presentation/widgets/edit_address_form.dart';
import 'package:dash_logistics/features/dashboard/address/presentation/widgets/edit_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditAddressPage extends HookConsumerWidget {
  final AddressModel address;
  const EditAddressPage({super.key, required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl  = useTextEditingController(text: address.name);
    final phoneCtrl = useTextEditingController(text: address.phone);
    final houseCtrl = useTextEditingController(text: address.house);
    final pinCtrl   = useTextEditingController(text: address.pincode);
    final formKey   = useMemoized(() => GlobalKey<FormState>());
    final isLoading = ref.watch(addressControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.lemon,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
        ),
        title: Text('Edit', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Map section
          EditAddressMap(address: address),

          // Form section
          Expanded(
            child: EditAddressForm(
              formKey:   formKey,
              nameCtrl:  nameCtrl,
              phoneCtrl: phoneCtrl,
              houseCtrl: houseCtrl,
              pinCtrl:   pinCtrl,
              address:   address,
              isLoading: isLoading,
              onSave: () {
                if (formKey.currentState?.validate() == true) {
                  ref.read(addressControllerProvider.notifier).editAddress(
                    id:      address.id,
                    name:    nameCtrl.text.trim(),
                    phone:   phoneCtrl.text.trim(),
                    house:   houseCtrl.text.trim(),
                    pincode: pinCtrl.text.trim(),
                  );
                  context.pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}