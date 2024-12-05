import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timeschedulepage_event.dart';
part 'timeschedulepage_state.dart';

class TimeschedulepageBloc extends Bloc<TimeschedulepageEvent, TimeschedulepageState> {
  TimeschedulepageBloc() : super(TimeschedulepageInitial()) {
    on<TimeschedulepageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
