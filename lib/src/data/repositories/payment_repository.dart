import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/services/payment_service.dart';

class PaymentRepository {
  final PaymentService _paymentService;

  PaymentRepository(this._paymentService);

  Future<List<PaymentModel>> getAllPaymentHistory() async {
    return await _paymentService.getAllPaymentHistory();
  }

  Future<PaymentModel?> getPaymentById(int paymentId) async {
    return await _paymentService.getPaymentById(paymentId);
  }

  Future<bool> deletePaymentHistory(int paymentId) async {
    return await _paymentService.deletePaymentHistory(paymentId);
  }


}