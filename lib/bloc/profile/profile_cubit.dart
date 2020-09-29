import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/friend.dart';

class ProfileCubit extends Cubit<Friend> {
  ProfileCubit(Friend friend) : super(friend);

  void updateFriend(Friend friend) {
    emit(friend);
  }
}
