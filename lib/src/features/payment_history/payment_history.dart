import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:learning_app/src/features/payment_history/bloc/payment_history_bloc.dart';
import 'package:learning_app/src/features/payment_history_detail/page/payment_history_detail.dart';
import 'package:learning_app/src/features/payment_history/widget/payment_history_item.dart';

import '../../data/model/payment_detail_model.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PaymentHistoryBloc(context.read<PaymentRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch Sử Thanh Toán',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[700],
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body:const PaymentHistoryView(),
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}

class PaymentHistoryView extends StatefulWidget {
  const PaymentHistoryView({super.key});

  @override
  State<PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<PaymentHistoryView> {
  late PaymentHistoryBloc _paymentHistoryBloc;

  @override
  void initState() {
    super.initState();
    _paymentHistoryBloc = context.read<PaymentHistoryBloc>();
    _paymentHistoryBloc.add(FetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
      builder: (context, state) {
        if(state is PaymentHistoryLoaded){
          List<PaymentModel> paymentHistory = state.payments;
          if(paymentHistory.isNotEmpty){
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: paymentHistory.length,
              separatorBuilder: (context, index) => const Divider(height: 20),
              itemBuilder: (context, index) =>
                  GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentHistoryDetail(paymentId: paymentHistory[index].paymentId)));
                  },child: PaymentHistoryItem(paymentModel: paymentHistory[index])),
            );
          }
          return _noItem();

        }
        return const Center(
          child: CircularProgressIndicator(),
        );

      },
    );
  }

  Widget _noItem() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có lịch sử thanh toán.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }


}