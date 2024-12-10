import 'package:real_time_chat/features/chat/data/datasources/online_status_data_source.dart';
import 'package:real_time_chat/features/chat/domain/repositories/online_status_repository.dart';

class OnlineStatusRepositoryImpl implements OnlineStatusRepository {
  final OnlineStatusDataSourceImpl remoteDataSource;

  OnlineStatusRepositoryImpl(this.remoteDataSource);

  @override
  Stream<bool> getUserStatusStream() {
    return remoteDataSource.userStatusStream;
  }
}
