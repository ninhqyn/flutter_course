import 'package:learning_app/src/data/model/user.dart';
import 'package:learning_app/src/data/services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService
});
  Future<User?> getUserInfo() async{
    return await userService.getUserInfo();
  }
}