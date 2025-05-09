import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'payment_history_detail_event.dart';
part 'payment_history_detail_state.dart';

class PaymentHistoryDetailBloc extends Bloc<PaymentHistoryDetailEvent, PaymentHistoryDetailState> {
  final CourseRepository _courseRepository;
  final PaymentRepository _paymentRepository;
  final int paymentId;

  PaymentHistoryDetailBloc({
    required this.paymentId,
    required CourseRepository courseRepository,
    required PaymentRepository paymentRepository,
  })  : _courseRepository = courseRepository,
        _paymentRepository = paymentRepository,
        super(PaymentHistoryDetailInitial()) {
    on<FetchDataDetailHistory>(_onFetchDataDetailHistory);
  }

  Future<void> _onFetchDataDetailHistory(
      FetchDataDetailHistory event,
      Emitter<PaymentHistoryDetailState> emit,
      ) async {
    emit(PaymentHistoryDetailLoading());
    try {
      final payment = await _paymentRepository.getPaymentById(paymentId);
      if (payment != null && payment.paymentDetails != null) {
        print('fetch payment success');
        List<Course> courses = [];
        for (final detail in payment.paymentDetails!) {
          if (detail.itemType.toLowerCase() == 'course') {
            final course = await _courseRepository.getCourseById(detail.itemId);
            if (course != null) {
              courses.add(course);
            }
          }
          // You can add logic here to fetch other item types if needed
        }
        emit(PaymentHistoryDetailLoaded(payments: payment, courses: courses));
      } else {
        emit(PaymentHistoryDetailError('Không tìm thấy thông tin thanh toán.'));
      }
    } catch (e) {
      print('Error fetching payment detail: $e');
    }
  }
}