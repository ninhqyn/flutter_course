import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/core/payment/vnpay/vnpay_service.dart';
import 'package:meta/meta.dart';

import '../../../shared/models/course.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final VnPayService _vnPayService;
  final List<Course> _courses;

  PaymentBloc(VnPayService vnPayService, List<Course> courses)
      : _vnPayService = vnPayService,
        _courses = courses,
        super(PaymentInitial()) {
    on<CheckOutSubmit>(_onCheckOutSubmit);
    on<LoadCheckOut>(_onLoadCheckOut);
  }

  Future<void> _onLoadCheckOut(LoadCheckOut event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    print('on load check out');
    try {
      // Tính tổng giá gốc
      double originalPrice = _courses.fold(0, (sum, course) => sum + course.price);

      // Tính tổng giảm giá dựa trên discountPercentage của từng khóa học
      double totalDiscount = _courses.fold(0, (sum, course) =>
      sum + (course.price * course.discountPercentage / 100));

      // Giá sau khi giảm
      double finalPrice = originalPrice - totalDiscount;

      emit(PaymentLoaded(
        originalPrice: originalPrice,
        discountedPrice: finalPrice,
        discountAmount: totalDiscount,
      ));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onCheckOutSubmit(CheckOutSubmit event, Emitter<PaymentState> emit) async {
    if(state is PaymentLoaded){
      final currentState = state as PaymentLoaded;
      emit(PaymentLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        String orderDescription = 'Đăng ký khóa học';
        final paymentUrl = await _vnPayService.createVnPayPayment(
          amount: currentState.discountedPrice,
          orderDescription: orderDescription,
          courses: _courses.map((c) => c.courseId).toList(),
        );
        emit(currentState.copyWith(paymentUrl: paymentUrl));
      } catch (e) {
        emit(PaymentError(message: e.toString()));
      }
    }



  }
}


