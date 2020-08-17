import 'package:equatable/equatable.dart';
import 'package:virgo/models/friend.dart';

// abstract class to represent bday bloc events
abstract class BdayEvent extends Equatable {
  const BdayEvent();

  @override
  List<Object> get props => [];
}

// Event for when loading is successful
class BdayLoadSuccessEv extends BdayEvent {}

// Event for when a bday is added
class BdayAddedEv extends BdayEvent {
  final Friend friend;

  const BdayAddedEv(this.friend);

  @override
  List<Object> get props => [friend];

  @override
  String toString() => 'BdayAddedEv: { $friend }';
}

// Event for when a bday is updated
class BdayUpdatedEv extends BdayEvent {
  final Friend friend;

  const BdayUpdatedEv(this.friend);

  @override
  List<Object> get props => [friend];

  @override
  String toString() => 'BdayUpdatedEv: { $friend }';
}

// Event for when a bday is deleted
class BdayDeletedByIdEv extends BdayEvent {
  final String id;

  const BdayDeletedByIdEv(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'BdayDeletedByIdEv: { $id }';
}

// Event for when ALL bdays are deleted
class BdayDeletedAllEv extends BdayEvent {}
