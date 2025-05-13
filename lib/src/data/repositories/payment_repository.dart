import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/services/payment_service.dart';

class PaymentRepository {
  final PaymentService _paymentService;

  PaymentRepository(this._paymentService);

  Future<List<PaymentModel>> getAllPaymentHistory({int page= 1,int pageSize = 10}) async {
    return await _paymentService.getAllPaymentHistory(page: page,pageSize: pageSize);
  }

  Future<PaymentModel?> getPaymentById(int paymentId) async {
    return await _paymentService.getPaymentById(paymentId);
  }

  Future<bool> deletePaymentHistory(int paymentId) async {
    return await _paymentService.deletePaymentHistory(paymentId);
  }


}