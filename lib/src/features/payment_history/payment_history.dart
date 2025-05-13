import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:learning_app/src/features/payment_history/bloc/payment_history_bloc.dart';
import 'package:learning_app/src/features/payment_history_detail/page/payment_history_detail.dart';
import 'package:learning_app/src/features/payment_history/widget/payment_history_item.dart';
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
  final ScrollController _scrollController = ScrollController();
  void _onScroll(){
    if(_isBottom) {
      context.read<PaymentHistoryBloc>().add(FetchHistory());
    }
  }

  bool get _isBottom{
    if(!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() => context.read<PaymentHistoryBloc>().add(FetchHistory()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
      builder: (context, state) {
        if(state is PaymentHistoryLoaded || state is PaymentHistoryLoadMore){
          List<PaymentModel> paymentHistory = state is PaymentHistoryLoaded ?
          (state).payments:(state as PaymentHistoryLoadMore).payments;
          if(paymentHistory.isNotEmpty){
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: paymentHistory.length,
                    separatorBuilder: (context, index) => const Divider(height: 20),
                    itemBuilder: (context, index) =>
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentHistoryDetail(paymentId: paymentHistory[index].paymentId)));
                        },child: PaymentHistoryItem(paymentModel: paymentHistory[index])),
                  ),
                ),
                if(state is PaymentHistoryLoadMore)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
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