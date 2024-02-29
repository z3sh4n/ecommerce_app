import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController(
      {required this.authRepository,
      required EmailPasswordSignInFormType formType})
      : super(EmailPasswordSignInState(formType: formType));

  final FakeAuthRepository authRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());

    final value = await AsyncValue.guard(() => _authenticate(email, password));

    state = state.copyWith(value: value);

    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType type){
    state = state.copyWith(formType: type);
  }
}

final EmailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, fT) {
  final auth = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInController(formType: fT, authRepository: auth);
});
