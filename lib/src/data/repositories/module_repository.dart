
import 'package:learning_app/src/data/model/user_module.dart';
import 'package:learning_app/src/shared/models/module.dart';

import '../services/module_service.dart';

class ModuleRepository{
  final ModuleService moduleService;
  ModuleRepository({
    required this.moduleService
  });
  Future<List<Module>> getAllModuleByCourseId(int courseId) async{
    final results = await moduleService.getAllModuleByCourseId(courseId);
    return results;
  }
  Future<List<UserModule>> getAllUserModuleByCourseId(int courseId) async{
    final results = await moduleService.getAllUserModuleByCourseId(courseId);
    return results;
  }

}