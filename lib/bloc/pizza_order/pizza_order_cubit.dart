import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'package:lab02/bloc/pizza_order/pizza_order_state.dart';

class PizzaOrderCubit extends Cubit<bool> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  PizzaOrderCubit() : super(true) {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      emit(
        result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
