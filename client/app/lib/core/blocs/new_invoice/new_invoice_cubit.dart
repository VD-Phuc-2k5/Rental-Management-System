import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:data/auth.dart';
import 'package:domain/billing.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';

part 'new_invoice_state.dart';

@singleton
class NewInvoiceCubit extends Cubit<NewInvoiceState> {
  NewInvoiceCubit(
    this._authBloc,
    this._getTenantInvoices,
  ) : super(const NewInvoiceState(0)) {
    _authSubscription = _authBloc.stream.listen(_onAuthChanged);
    _onAuthChanged(_authBloc.state);
  }

  final AuthenticationBloc _authBloc;
  final GetTenantInvoicesUsecase _getTenantInvoices;
  StreamSubscription<AuthenticationState>? _authSubscription;
  RealtimeChannel? _channel;
  Timer? _pollTimer;

  void _onAuthChanged(AuthenticationState state) {
    if (state.status == AuthenticationStatus.authenticated &&
        state.user is AuthModel) {
      final user = (state.user as AuthModel).user;
      final raw = user.role;
      final role = raw is List && raw.isNotEmpty
          ? raw.first.toString()
          : raw?.toString() ?? '';
      if (role != 'landlord') {
        _subscribeToRealtime(user.id);
        return;
      }
    }
    _unsubscribe();
    emit(const NewInvoiceState(0));
  }

  void _subscribeToRealtime(String tenantId) {
    _unsubscribe();

    bool subscriptionOk = false;

    _channel = Supabase.instance.client
        .channel('new-invoice-$tenantId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'invoices',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'tenant_id',
            value: tenantId,
          ),
          callback: (payload) {
            final status = payload.newRecord['status']?.toString();
            if (status == 'finalized') {
              emit(NewInvoiceState(state.count + 1,
                  latestInvoiceId: payload.newRecord['id']?.toString()));
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
        _startPolling();
      }
    });
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final result = await _getTenantInvoices(const GetTenantInvoicesParams());
      result.fold((_) {}, (invoices) {
        final hasNewFinalized = invoices.any((inv) => inv.status == 'finalized');
        if (hasNewFinalized) {
          emit(NewInvoiceState(state.count + 1));
        }
      });
    });
  }

  void _cancelPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void clearBadge() => emit(const NewInvoiceState(0));

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
