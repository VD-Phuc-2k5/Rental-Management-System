part of 'room_list_bloc.dart';

typedef RoomListState = SealedClassState<Failure, List<RoomEntity>>;
typedef RoomListInitial = SealedClassInitial<Failure, List<RoomEntity>>;
typedef RoomListLoadInProgress =
    SealedClassLoadInProgress<Failure, List<RoomEntity>>;
typedef RoomListLoadSuccess = SealedClassLoadSuccess<Failure, List<RoomEntity>>;
typedef RoomListLoadFailure = SealedClassLoadFailure<Failure, List<RoomEntity>>;
