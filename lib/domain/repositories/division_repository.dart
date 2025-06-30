import '../entities/division.dart';

abstract class DivisionRepository {
  Future<List<Division>> getKoreaDivisions();
}
