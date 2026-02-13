import 'package:json_annotation/json_annotation.dart';
import 'package:smart_book_access/features/category/domain/entities/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;

  CategoryApiModel({
    this.id,
    required this.name,
  });

  // From JSON
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // To Entity - Mapping 'id' to 'categoryId' and 'name' to 'categoryName'
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id,
      categoryName: name,
    );
  }

  // From Entity - Mapping 'categoryId' back to 'id'
  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.categoryId,
      name: entity.categoryName,
    );
  }

  // Helper for Lists
  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}