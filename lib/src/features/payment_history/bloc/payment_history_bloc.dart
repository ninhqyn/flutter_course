import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:meta/meta.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final PaymentRepository _paymentRepository;
  PaymentHistoryBloc(PaymentRepository paymentRepository)
      :_paymentRepository = paymentRepository,
        super(PaymentHistoryInitial()) {
    on<FetchHistory>(_onFetchHistory);
  }
  Future<void> _onFetchHistory(FetchHistory event,Emitter<PaymentHistoryState> emit) async{
    emit(PaymentHistoryLoading());
    final payments = await _paymentRepository.getAllPaymentHistory();
    emit(PaymentHistoryLoaded(payments: payments));

  }
}
