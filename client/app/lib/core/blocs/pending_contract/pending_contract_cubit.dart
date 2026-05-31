import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/usecase.dart';
import 'package:data/auth.dart';
import 'package:domain/rental_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';

part 'pending_contract_state.dart';

@singleton
class PendingContractCubit extends Cubit<PendingContractState> {
  PendingContractCubit(
    this._getMyContractsUsecase,
    this._authBloc,
  ) : super(const PendingContractNone()) {
    _authSubscription = _authBloc.stream.listen(_onAuthChanged);
    _onAuthChanged(_authBloc.state);
  }

  final GetMyContractsUsecase _getMyContractsUsecase;
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
      if (role != 'landlord') {
        _fetchAndSubscribe(user.id);
        return;
      }
    }
    _unsubscribe();
    if (!isClosed) emit(const PendingContractNone());
  }

  Timer? _pollTimer;

  Future<void> _fetchAndSubscribe(String tenantId) async {
    _unsubscribe();
    await _fetchSentContracts();

    bool subscriptionOk = false;
    _channel = Supabase.instance.client
        .channel('pending-contracts-$tenantId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'contracts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'tenant_id',
            value: tenantId,
          ),
          callback: (payload) {
            final newStatus =
                payload.newRecord['status']?.toString().toUpperCase();
            if (newStatus == 'SENT' || newStatus == 'CANCELLED') {
              _fetchSentContracts();
            }
          },
        )
        .subscribe((status, error) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            subscriptionOk = true;
            _pollTimer?.cancel();
          }
        });

    // Fallback polling: nếu Realtime không subscribe được trong 5s thì polling 30s
    _pollTimer?.cancel();
    _pollTimer = Timer(const Duration(seconds: 5), () {
      if (!subscriptionOk) {
        _pollTimer = Timer.periodic(
          const Duration(seconds: 30),
          (_) => _fetchSentContracts(),
        );
      }
    });
  }

  void _cancelPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _fetchSentContracts() async {
    final result = await _getMyContractsUsecase(const NoParams());
    result.fold(
      (_) {},
      (contracts) {
        final sent = contracts
            .where((c) => c.status == ContractStatus.sent)
            .toList();
        if (sent.isNotEmpty && !isClosed) {
          // Guard: don't re-emit if popup is already visible (prevents double popup from realtime events)
          if (state is! PendingContractFound) {
            emit(PendingContractFound(sent.first));
          }
        } else if (!isClosed && state is PendingContractFound) {
          emit(const PendingContractNone());
        }
      },
    );
  }

  /// Hides the popup for the current view; will re-appear next time checkPending() is called.
  void dismiss() {
    if (!isClosed) emit(const PendingContractNone());
  }

  /// Re-checks for pending contracts — call when returning to a page that shows the popup.
  Future<void> checkPending() => _fetchSentContracts();

  void _unsubscribe() {
    _cancelPolling();
    _channel?.unsubscribe();
    _channel = null;
  }

  @disposeMethod
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cancelPolling();
    _channel?.unsubscribe();
    return super.close();
  }
}
