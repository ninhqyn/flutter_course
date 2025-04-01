import 'package:shared_preferences/shared_preferences.dart';
class AuthLocalDataSource{
  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refreshToken';
  final SharedPreferences sf;
  AuthLocalDataSource(this.sf);

  Future<void> saveAccessToken(String accessToken) async{

    await sf.setString(_accessToken, accessToken);
  }
  Future<String?> getAccessToken() async {
    return sf.getString(_accessToken);
  }
  Future<void> removeAccessToken() async {
    await sf.remove(_accessToken);
  }
  Future<void> saveRefreshToken(String refreshToken) async{

    await sf.setString(_refreshToken, refreshToken);
  }
  Future<String?> getRefreshToken() async {

    return sf.getString(_refreshToken);
  }
  Future<void> removeRefreshToken() async {
    await sf.remove(_accessToken);
  }

}