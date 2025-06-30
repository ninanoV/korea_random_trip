import 'dart:math';
import '../entities/division.dart';

class SelectRandomDivision {
  final Random _random = Random();

  Division call(List<Division> divisions) {
    if (divisions.isEmpty) {
      throw Exception('Division list is empty');
    }
    return divisions[_random.nextInt(divisions.length)];
  }
}
