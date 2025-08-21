import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  Category toEntity() => Category(id: id, name: name, description: description);

  @override
  List<Object?> get props => [id, name, description];
}
