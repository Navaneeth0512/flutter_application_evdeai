// bus_repository.dart
import 'bus_model.dart';

class BusRepository {
  static final BusRepository _instance = BusRepository._internal();
  factory BusRepository() => _instance;

  final List<Bus> _buses = [];

  BusRepository._internal();

  List<Bus> get buses => _buses;

  void addBus(Bus bus) {
    _buses.add(bus);
  }
}
