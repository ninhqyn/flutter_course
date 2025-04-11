import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/core/payment/vnpay/vnpay_service.dart';
import 'package:meta/meta.dart';

import '../../../shared/models/course.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final VnPayService _vnPayService;
  PaymentBloc(VnPayService vnPayService) :_vnPayService = vnPayService, super(PaymentInitial()) {
    on<CheckOutSubmit>(_onCheckOutSubmit);
  }
  Future<void> _onCheckOutSubmit(CheckOutSubmit event,Emitter<PaymentState> emit) async{
    print('check out submit');

      final amount = event.course.price * (1 - event.course.discountPercentage / 100);
      final paymentUrl = await _vnPayService.createVnPayPayment(
          amount: amount,
          orderDescription: 'Đăng ký ${event.course.courseName}',
          courseId: event.course.courseId
      );
      print('tao payment url success');
      emit(PaymentLoaded(course: event.course,paymentUrl: paymentUrl));

  }
}
