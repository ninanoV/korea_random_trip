import '../entities/division.dart';
import '../repositories/division_repository.dart';

class GetKoreaDivisions {
  final DivisionRepository repository;

  GetKoreaDivisions(this.repository);

  Future<List<Division>> call() async {
    return await repository.getKoreaDivisions();
  }
}
