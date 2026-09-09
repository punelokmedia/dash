import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/dashboard/address/domain/address_model.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_repository.dart';
import 'package:dash_logistics/features/dashboard/address/shared/address_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressController extends AsyncNotifier<List<AddressModel>> {

  

  AddressRepository get _repo => ref.read(addressRepositoryProvider);

  @override
  Future<List<AddressModel>> build() async {
    ref.watch(tokenProvider);
    return _fetchAddresses();
  }

  Future<List<AddressModel>> _fetchAddresses() async {
    final repo = ref.read(addressRepositoryProvider); // ← no .future
    return repo.getAddresses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAddresses);
  }

  Future<void> deleteAddress(String id) async {
    final repo = ref.read(addressRepositoryProvider); // ← no .future
    await repo.deleteAddress(id);
    await refresh();
  }

  Future<void> editAddress({
    required String id,
    required String name,
    required String phone,
    required String house,
    required String pincode,
  }) async {
    final repo = ref.read(addressRepositoryProvider); // ← no .future
    await repo.editAddress(id: id, name: name, phone: phone, house: house, pincode: pincode);
    await refresh();
  }
}

final addressControllerProvider =
    AsyncNotifierProvider<AddressController, List<AddressModel>>(
  AddressController.new,
);