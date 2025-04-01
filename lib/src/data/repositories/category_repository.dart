import 'package:learning_app/src/data/services/category_api_client.dart';

import 'package:learning_app/src/shared/models/category.dart';


class CategoryRepository {
  final CategoryApiClient categoryApiClient;

  CategoryRepository({
    required this.categoryApiClient,
  });

  // Sử dụng CategoryApiClient thay vì CategoryService
  Future<List<Category>> getAllCategory() async {
    final results = await categoryApiClient.getAllCategories();
    return results;
  }
}
