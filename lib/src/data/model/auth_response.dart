
import 'package:learning_app/src/data/model/token_model.dart';


import '../services/auth_api_client.dart';

class AuthResponse {
  final AuthStatus status;
  final String? message;
  final TokenModel? tokenModel;

  AuthResponse({
    required this.status,
    this.message,
    this.tokenModel
  });
}