import 'package:equatable/equatable.dart';
import 'package:virgo/models/friend.dart';

// abstract class to represent bday bloc states
abstract class BdayState extends Equatable {
  const BdayState();

  @override
  List<Object> get props => [];
}

// State for when loading bdays is pending
class BdayLoadingSt extends BdayState {}

// State for when loading bdays is successful
class BdayLoadSuccessSt extends BdayState {
  final List<Friend> bdays;

  const BdayLoadSuccessSt([this.bdays = const []]);

  @override
  List<Object> get props => [bdays];

  @override
  String toString() => 'BdayLoadSuccessSt: { bdays: $bdays }';
}

// State for when loading bdays is unsuccessful
class BdayLoadFailureSt extends BdayState {}
