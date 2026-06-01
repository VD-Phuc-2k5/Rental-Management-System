part of 'create_room_bloc.dart';

typedef CreateRoomState = SealedClassState<Failure, RoomEntity>;
typedef CreateRoomInitial = SealedClassInitial<Failure, RoomEntity>;
typedef CreateRoomLoadInProgress =
    SealedClassLoadInProgress<Failure, RoomEntity>;
typedef CreateRoomLoadSuccess = SealedClassLoadSuccess<Failure, RoomEntity>;
typedef CreateRoomLoadFailure = SealedClassLoadFailure<Failure, RoomEntity>;
