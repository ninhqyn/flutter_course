import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/data/model/result_model.dart';
import 'package:learning_app/src/features/payment/page/payment_result.dart';

class VnPayWebView extends StatefulWidget {
  final String paymentUrl;

  const VnPayWebView({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<VnPayWebView> createState() => _VnPayWebViewState();
}

class _VnPayWebViewState extends State<VnPayWebView> {
  final GlobalKey webViewKey = GlobalKey();
  bool _isLoading = true;
  bool _isNavigating = false;

  void handleLoadStop(BuildContext context, String url) async {
    if (_isNavigating) return; // Tránh xử lý nhiều lần

    setState(() {
      _isLoading = false;
    });

    try {
      final urlString = url.toString();
      debugPrint("WebView stop loading URL: $urlString");

      if (urlString.startsWith('https://${ApiConstants.baseUrl}/api/VnPay/payment-return')) {
        _isNavigating = true;
        debugPrint('Callback URL from VNPay: $urlString');

        // Parse payment data
        final uri = Uri.parse(urlString);
        final params = uri.queryParameters;

        final paymentDate = params['vnp_PayDate'] ?? '';
        final amountString = params['vnp_Amount'] ?? '0';
        final amount = double.tryParse(amountString) ?? 0.0;
        final responseCode = params['vnp_ResponseCode'] ?? '';
        final txnRef = params['vnp_TxnRef'] ?? '';
        final orderInfo = params['vnp_OrderInfo'] ?? '';

        Map<String, dynamic> orderInfoMap = {};
        final decodedOrderInfo = Uri.decodeComponent(orderInfo);
        orderInfoMap = jsonDecode(decodedOrderInfo);

        final description = orderInfoMap['Description'] ?? '';

        final result = ModelResult(
          transactionId: txnRef,
          amount: amount/100,
          content: description,
          isSuccess: responseCode == '00',
          payDate: paymentDate,
          responseCode: responseCode,
        );


        // Pop WebView trước
        Navigator.of(context).pop();
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 100));

        if (!mounted) return;

        // Push màn hình kết quả
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentResult(result: result),
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('Error handling payment: $e');
      debugPrint(stack.toString());

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Payment processing error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _isNavigating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mounted && !_isNavigating) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (mounted && !_isNavigating) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    clearSessionCache: true,
                    thirdPartyCookiesEnabled: true,
                    allowFileAccess: true,
                    allowContentAccess: true,
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                  ),
                ),
                onLoadStart: (controller, url) {
                  if (mounted) {
                    setState(() => _isLoading = true);
                  }
                },
                onLoadStop: (controller, url) {
                  handleLoadStop(context, url.toString());
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED
                  );
                },
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
