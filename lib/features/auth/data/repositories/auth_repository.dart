import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    String? namaKucing,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        if (namaKucing != null && namaKucing.isNotEmpty) 'nama_kucing': namaKucing,
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
