import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virgo/bloc/bday/bday_event.dart';
import 'package:virgo/bloc/bday/bday_state.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/repository/bday_repo.dart';

class BdayBloc extends Bloc<BdayEvent, BdayState> {
  final BdayRepo bdayRepo = BdayRepo();

  BdayBloc() : super(BdayLoadingSt());

  @override
  Stream<BdayState> mapEventToState(BdayEvent event) async* {
    if (event is BdayLoadSuccessEv)
      yield* _mapBdayLoadedToState();
    else if (event is BdayAddedEv)
      yield* _mapBdayAddedToState(event);
    else if (event is BdayUpdatedEv)
      yield* _mapBdayUpdatedToState(event);
    else if (event is BdayDeletedByIdEv)
      yield* _mapBdayDeletedByIdToState(event);
    else if (event is BdayDeletedAllEv) yield* _mapBdayDeletedAllToState();
  }

  Stream<BdayState> _mapBdayLoadedToState() async* {
    try {
      List<Friend> list = await bdayRepo.getAllBdays();
      print(list);
      yield BdayLoadSuccessSt(list);
    } catch (e) {
      print(e);
      yield BdayLoadFailureSt();
    }
  }

  Stream<BdayState> _mapBdayAddedToState(BdayAddedEv event) async* {
    if (state is BdayLoadSuccessSt) {
      List<Friend> updatedBdays = List.from((state as BdayLoadSuccessSt).bdays)
        ..add(event.friend);
      await bdayRepo.insertBday(event.friend);
      updatedBdays = sortFriends(updatedBdays);
      print(BdayLoadSuccessSt(updatedBdays));
      yield BdayLoadSuccessSt(updatedBdays);
    }
  }

  Stream<BdayState> _mapBdayUpdatedToState(BdayUpdatedEv event) async* {
    if (state is BdayLoadSuccessSt) {
      List<Friend> updatedBdays = (state as BdayLoadSuccessSt)
          .bdays
          .map((friend) => friend.id == event.friend.id ? event.friend : friend)
          .toList();
      await bdayRepo.updateBday(event.friend);
      updatedBdays = sortFriends(updatedBdays);
      yield BdayLoadSuccessSt(updatedBdays);
    }
  }

  Stream<BdayState> _mapBdayDeletedByIdToState(BdayDeletedByIdEv event) async* {
    if (state is BdayLoadSuccessSt) {
      final List<Friend> updatedBdays = (state as BdayLoadSuccessSt)
          .bdays
          .where((friend) => friend.id != event.id)
          .toList();
      await bdayRepo.deleteBdayById(event.id);
      yield BdayLoadSuccessSt(updatedBdays);
    }
  }

  Stream<BdayState> _mapBdayDeletedAllToState() async* {
    if (state is BdayLoadSuccessSt) {
      await bdayRepo.deleteAllBdays();
      yield BdayLoadSuccessSt([]);
    }
  }
}
