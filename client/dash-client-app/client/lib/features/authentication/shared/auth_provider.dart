
import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/features/authentication/infra/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider=Provider<AuthRepository>((ref){
  final dio=ref.read(dioProvider);
  return AuthRepository(dio);
});