import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:meta/meta.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final PaymentRepository _paymentRepository;
  int _currentPage = 1;
  final _pageSize = 10;
  PaymentHistoryBloc(PaymentRepository paymentRepository)
      :_paymentRepository = paymentRepository,
        super(PaymentHistoryInitial()) {
    on<FetchHistory>(_onFetchHistory);
  }
  Future<void> _onFetchHistory(FetchHistory event,Emitter<PaymentHistoryState> emit) async{
    if(state is PaymentHistoryInitial){
      emit(PaymentHistoryLoading());
      final payments = await _paymentRepository.getAllPaymentHistory(page: 1,pageSize: 5);
      emit(PaymentHistoryLoaded(payments: payments,hasMax: payments.length<_pageSize));
    }
    else if(state is PaymentHistoryLoaded){
      //fetch more
      final currentState = state as PaymentHistoryLoaded;
      if(currentState.hasMax) return;

      emit(PaymentHistoryLoadMore(payments: currentState.payments, hasMax:currentState.hasMax));
      _currentPage++;
      final payments = await _paymentRepository.getAllPaymentHistory(page: _currentPage,pageSize: _pageSize);
      emit(PaymentHistoryLoaded(
          payments: List.of(currentState.payments)..addAll(payments),
          hasMax: payments.length<_pageSize));
    }


  }
}
