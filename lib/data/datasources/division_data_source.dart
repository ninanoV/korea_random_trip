import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/division_model.dart';

abstract class DivisionDataSource {
  Future<List<DivisionModel>> getKoreaDivisions();
}

class DivisionDataSourceImpl implements DivisionDataSource {
  @override
  Future<List<DivisionModel>> getKoreaDivisions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/korea_divisions.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((data) => DivisionModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to load Korea divisions: $e');
    }
  }
}
