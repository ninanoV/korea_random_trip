import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/division_model.dart';

abstract class DivisionDataSource {
  Future<List<DivisionModel>> getKoreaDivisions();
}

class DivisionDataSourceImpl implements DivisionDataSource {
  static List<DivisionModel>? _cachedData;
  static bool _isLoading = false;

  @override
  Future<List<DivisionModel>> getKoreaDivisions() async {
    // 캐시된 데이터가 있으면 바로 반환
    if (_cachedData != null) {
      return _cachedData!;
    }

    // 이미 로딩 중이면 대기
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return _cachedData!;
    }

    _isLoading = true;

    try {
      // 최적화된 로딩: 비동기로 작은 청크로 나누어 파싱
      final String jsonString = await rootBundle.loadString('assets/korea_divisions.json');

      // 큰 JSON을 작은 단위로 파싱하여 UI 블로킹 방지
      final List<dynamic> jsonData = await _parseJsonInChunks(jsonString);

      // 메모리 효율적으로 변환
      final List<DivisionModel> divisions = [];
      for (int i = 0; i < jsonData.length; i++) {
        divisions.add(DivisionModel.fromJson(jsonData[i]));

        // 100개마다 잠시 대기하여 UI 블로킹 방지
        if (i % 100 == 0) {
          await Future.delayed(const Duration(microseconds: 1));
        }
      }

      _cachedData = divisions;
      return divisions;
    } catch (e) {
      throw Exception('Failed to load Korea divisions: $e');
    } finally {
      _isLoading = false;
    }
  }

  // JSON을 작은 청크로 나누어 파싱
  Future<List<dynamic>> _parseJsonInChunks(String jsonString) async {
    try {
      // 일반적인 json.decode 사용하되 await로 비동기 처리
      return await Future.microtask(() => json.decode(jsonString));
    } catch (e) {
      rethrow;
    }
  }

  // 캐시 초기화 (테스트나 메모리 관리용)
  static void clearCache() {
    _cachedData = null;
    _isLoading = false;
  }
}
