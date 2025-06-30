import '../data/datasources/division_data_source.dart';
import '../data/repositories/division_repository_impl.dart';
import '../domain/repositories/division_repository.dart';
import '../domain/usecases/get_korea_divisions.dart';
import '../domain/usecases/select_random_division.dart';
import '../presentation/notifiers/slot_machine_notifier.dart';

class DependencyInjection {
  static late DivisionRepository _divisionRepository;
  static late GetKoreaDivisions _getKoreaDivisions;
  static late SelectRandomDivision _selectRandomDivision;
  static late SlotMachineNotifier _slotMachineNotifier;

  static void setup() {
    // Data Layer
    final divisionDataSource = DivisionDataSourceImpl();
    _divisionRepository = DivisionRepositoryImpl(divisionDataSource);

    // Domain Layer
    _getKoreaDivisions = GetKoreaDivisions(_divisionRepository);
    _selectRandomDivision = SelectRandomDivision();

    // Presentation Layer
    _slotMachineNotifier = SlotMachineNotifier(_getKoreaDivisions, _selectRandomDivision);
  }

  static SlotMachineNotifier get slotMachineNotifier => _slotMachineNotifier;
}
