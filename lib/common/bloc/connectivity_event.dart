part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {}

final class ConnectivityStarted extends ConnectivityEvent {
  ConnectivityStarted();

  @override
  List<Object> get props => [];
}
