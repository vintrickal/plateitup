// MVP mode: email sign-in is a no-op. Callers in AuthCubit.signInWithEmail /
// createAccountWithEmail get a non-null sentinel back so the UI flow proceeds
// as if sign-in succeeded.

Future<Object?> emailSignInFunc(String email, String password) async =>
    const Object();

Future<Object?> emailCreateAccountFunc(String email, String password) async =>
    const Object();
