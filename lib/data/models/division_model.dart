import '../../domain/entities/division.dart';

class DivisionModel extends Division {
  const DivisionModel({
    required super.name,
    super.children = const [],
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      name: json['name'] ?? '',
      children: (json['children'] as List<dynamic>?)?.map((child) => DivisionModel.fromJson(child)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'children': children.map((child) => (child as DivisionModel).toJson()).toList(),
    };
  }

  Division toEntity() {
    return Division(
      name: name,
      children: children,
    );
  }
}
