import '../../domain/entities/division.dart';
import '../../domain/repositories/division_repository.dart';
import '../datasources/division_data_source.dart';

class DivisionRepositoryImpl implements DivisionRepository {
  final DivisionDataSource dataSource;

  DivisionRepositoryImpl(this.dataSource);

  @override
  Future<List<Division>> getKoreaDivisions() async {
    try {
      final models = await dataSource.getKoreaDivisions();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get Korea divisions: $e');
    }
  }
}
