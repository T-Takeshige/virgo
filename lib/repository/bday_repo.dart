import 'package:virgo/database/bday/bday_dao.dart';
import 'package:virgo/models/friend.dart';

// Currently a redundant class, but in case of integration with
// other backends like web services, this will come useful
class BdayRepo {
  final bdayDao = BdayDao();

  Future getAllBdays({String query}) => bdayDao.getBdays(query: query);
  Future insertBday(Friend friend) => bdayDao.createBday(friend);
  Future updateBday(Friend friend) => bdayDao.updateBday(friend);
  Future deleteBdayById(String id) => bdayDao.deleteBday(id);
  Future deleteAllBdays() => bdayDao.deleteAllBdays();
}
