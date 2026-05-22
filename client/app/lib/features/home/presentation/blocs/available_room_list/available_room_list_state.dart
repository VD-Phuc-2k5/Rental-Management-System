part of 'available_room_list_bloc.dart';

typedef AvailableRoomListState
    = SealedClassState<Failure, List<AvailableRoomEntity>>;
typedef AvailableRoomListInitial
    = SealedClassInitial<Failure, List<AvailableRoomEntity>>;
typedef AvailableRoomListLoadInProgress
    = SealedClassLoadInProgress<Failure, List<AvailableRoomEntity>>;
typedef AvailableRoomListLoadSuccess
    = SealedClassLoadSuccess<Failure, List<AvailableRoomEntity>>;
typedef AvailableRoomListLoadFailure
    = SealedClassLoadFailure<Failure, List<AvailableRoomEntity>>;
