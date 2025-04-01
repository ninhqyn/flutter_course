
import 'package:learning_app/src/data/services/skill_service.dart';
import 'package:learning_app/src/shared/models/skill.dart';

class SkillRepository{
  final SkillService skillService;
  SkillRepository({
    required this.skillService
  });
  Future<List<Skill>> getAllSkillByCourseId(int courseId) async{
    final results = await skillService.getAllSkillByCourseId(courseId);
    return results;
  }

}