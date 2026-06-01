import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:data/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';

part 'new_requests_state.dart';

@singleton
class NewRequestsCubit extends Cubit<NewRequestsState> {
  NewRequestsCubit(this._authBloc) : super(const NewRequestsState(0)) {
    _authSubscription = _authBloc.stream.listen(_onAuthChanged);
    _onAuthChanged(_authBloc.state);
  }

  final AuthenticationBloc _authBloc;
  StreamSubscription<AuthenticationState>? _authSubscription;
  RealtimeChannel? _channel;

  void _onAuthChanged(AuthenticationState state) {
    if (state.status == AuthenticationStatus.authenticated &&
        state.user is AuthModel) {
      final user = (state.user as AuthModel).user;
      final raw = user.role;
      final role = raw is List && raw.isNotEmpty
          ? raw.first.toString()
          : raw?.toString() ?? '';
      if (role == 'landlord') {
        _subscribeToRealtime(user.id);
        return;
      }
    }
    _unsubscribe();
    emit(const NewRequestsState(0));
  }

  void _subscribeToRealtime(String landlordId) {
    _unsubscribe();
    _channel = Supabase.instance.client
        .channel('new-rental-requests-$landlordId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'rental_requests',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'landlord_id',
            value: landlordId,
          ),
          callback: (_) => emit(NewRequestsState(state.count + 1)),
        )
        .subscribe();
  }

  void clearBadge() => emit(const NewRequestsState(0));

  void _unsubscribe() {
    _channel?.unsubscribe();
    _channel = null;
  }

  @disposeMethod
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _channel?.unsubscribe();
    return super.close();
  }
}
