import 'dart:async';

import '../model/auth_response.dart';
import '../services/auth_api_client.dart';
import '../data_scources/auth_local_data_source.dart';

import '../model/token_model.dart';



class AuthRepository {
  final AuthService _authService;
  final AuthLocalDataSource _authLocalDataSource;
  final _authStatusController = StreamController<AuthStatus>.broadcast();

  // Getter cho stream
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  AuthRepository({
    required AuthService authService,
    required AuthLocalDataSource authLocalDataSource,
  }) : _authService = authService,
        _authLocalDataSource = authLocalDataSource;
  void _updateAuthStatus(AuthStatus status) {
    _authStatusController.add(status);
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse authResponse = await _authService.signInWithEmail(email, password);

      if (authResponse.status == AuthStatus.authenticated && authResponse.tokenModel != null) {
        await _authLocalDataSource.saveAccessToken(authResponse.tokenModel!.accessToken);
        await _authLocalDataSource.saveRefreshToken(authResponse.tokenModel!.refreshToken);
        _updateAuthStatus(AuthStatus.authenticated); // Cập nhật stream
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        status: AuthStatus.unknown,
        message: 'Đăng nhập thất bại: $e',
      );
    }
  }

  Future<bool> verifyToken(String accessToken) async {
    try {
      return await _authService.verifyToken(accessToken);
    } catch (e) {
      print('Lỗi khi xác thực token: $e');
      return false;
    }
  }

  Future<TokenModel?> refreshToken() async {
    try {
      final refreshToken = await _authLocalDataSource.getRefreshToken();
      final accessToken = await _authLocalDataSource.getAccessToken();
      final newToken = await _authService.refreshToken(TokenModel(accessToken: accessToken!, refreshToken: refreshToken!));
      if (newToken != null) {
        await _authLocalDataSource.saveAccessToken(newToken.accessToken);
        await _authLocalDataSource.saveRefreshToken(newToken.refreshToken);
        _updateAuthStatus(AuthStatus.authenticated); // Cập nhật stream
        return newToken;
      }
      return null;
    } catch (e) {
      print('Lỗi khi làm mới token: $e');
      return null;
    }
  }

  Future<AuthStatus> checkAuthStatus() async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null) {
        _updateAuthStatus(AuthStatus.unauthenticated); // Cập nhật stream
        return AuthStatus.unauthenticated;
      }

      if (await verifyToken(accessToken)) {
        _updateAuthStatus(AuthStatus.authenticated); // Cập nhật stream
        return AuthStatus.authenticated;
      }

      print('Đang làm mới token...');
      final newToken = await this.refreshToken();

      if (newToken != null) {
        _updateAuthStatus(AuthStatus.authenticated); // Cập nhật stream
        return AuthStatus.authenticated;
      }

      await clearTokens();
      _updateAuthStatus(AuthStatus.unauthenticated); // Cập nhật stream
      return AuthStatus.unauthenticated;

    } catch (e) {
      print('Lỗi khi kiểm tra trạng thái xác thực: $e');
      _updateAuthStatus(AuthStatus.unknown); // Cập nhật stream
      return AuthStatus.unknown;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _authLocalDataSource.getAccessToken();
    } catch (e) {
      print('Lỗi khi lấy access token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _authLocalDataSource.getRefreshToken();
    } catch (e) {
      print('Lỗi khi lấy refresh token: $e');
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _authLocalDataSource.removeAccessToken();
      await _authLocalDataSource.removeRefreshToken();
      _updateAuthStatus(AuthStatus.unauthenticated); // Cập nhật stream khi đăng xuất
    } catch (e) {
      print('Lỗi khi xóa tokens: $e');
    }
  }

  // Quan trọng: đóng stream controller khi repository không còn được sử dụng
  void dispose() {
    _authStatusController.close();
  }

  // Phương thức để kích hoạt kiểm tra trạng thái xác thực thủ công
  Future<void> checkAndUpdateAuthStatus() async {
    final status = await checkAuthStatus();
    _updateAuthStatus(status);
  }
}