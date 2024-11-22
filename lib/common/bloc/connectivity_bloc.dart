import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityStarted>(_connectivityStarted);
  }

  Future<void> _connectivityStarted(
    ConnectivityStarted event,
    Emitter<ConnectivityState> emit,
  ) async {
    await emit.forEach(
      Connectivity().onConnectivityChanged,
      onData: (result) {
        final hasConnection = result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi);

        print(hasConnection);

        return ConnectivitySuccess(
          isConnectedToInternet: hasConnection,
        );
      },
    );
  }
}
