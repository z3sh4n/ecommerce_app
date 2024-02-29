import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController(this.authRepository)
      : super(const AsyncValue<void>.data(null));

  final FakeAuthRepository authRepository;

  Future<bool> signOut() async {
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.hasError == false;
  }
}

final accoutnScreenControllerProvider =
    StateNotifierProvider<AccountScreenController, AsyncValue<void>>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return AccountScreenController(auth);
});
