part of 'connectivity_bloc.dart';

sealed class ConnectivityState extends Equatable {}

final class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object?> get props => [];
}

final class ConnectivityInProgress extends ConnectivityState {
  @override
  List<Object?> get props => [];
}

final class ConnectivitySuccess extends ConnectivityState {
  final bool isConnectedToInternet;

  ConnectivitySuccess({
    required this.isConnectedToInternet,
  });

  @override
  List<Object?> get props => [isConnectedToInternet];
}

final class ConnectivityEnd extends ConnectivityState {
  @override
  List<Object?> get props => [];
}

final class ConnectivityFail extends ConnectivityState {
  @override
  List<Object?> get props => [];
}
