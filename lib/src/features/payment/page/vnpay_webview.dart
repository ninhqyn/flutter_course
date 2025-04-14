import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/data/model/result_model.dart';

class VnPayWebView extends StatefulWidget {
  final String paymentUrl;
  final Function(ModelResult)? onPaymentComplete;

  const VnPayWebView({
    super.key,
    required this.paymentUrl,
    this.onPaymentComplete,
  });

  @override
  State<VnPayWebView> createState() => _VnPayWebViewState();
}

class _VnPayWebViewState extends State<VnPayWebView> {
  final GlobalKey webViewKey = GlobalKey();
  bool _isLoading = true;

  void handleLoadStop(BuildContext context, String url) async {
    setState(() {
      _isLoading = false;
    });
    final urlString = url.toString();
    debugPrint("WebView stop loading URL: $urlString");
    if (urlString.startsWith('https://${ApiConstants.baseUrl}/api/VnPay/payment-return')) {
      debugPrint('Callback URL from VNPay: $urlString');
      final uri = Uri.parse(urlString);
      final params = uri.queryParameters;
      final paymentDate = params['vnp_PayDate'] ?? '';
      final amountString = params['vnp_Amount'] ?? '0';
      final amount = double.tryParse(amountString) ?? 0.0;
      final responseCode = params['vnp_ResponseCode'] ?? '';
      final txnRef = params['vnp_TxnRef'] ?? '';
      final orderInfo = params['vnp_OrderInfo'] ?? '';
      final decodedOrderInfo = Uri.decodeComponent(orderInfo);
      Map<String, dynamic> orderInfoMap = {};
        orderInfoMap = jsonDecode(decodedOrderInfo);
        debugPrint("Decoded order info: $orderInfoMap");
        final description = orderInfoMap['Description'] ?? '';
        final courseId = orderInfoMap['CourseId'] ?? 0;
        debugPrint("Description: $description");

      Navigator.of(context).pop();
      if (widget.onPaymentComplete != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onPaymentComplete!(
              ModelResult(
                  transactionId: txnRef,
                  amount: amount/100,
                  content: courseId,
                  isSuccess: responseCode == '00',
                  payDate: paymentDate,
                  responseCode:responseCode,
                  courseId: courseId
              )
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Xử lý nút back
        Navigator.of(context).pop(null);
        return false;
      },
      child: Scaffold(
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
                  setState(() {
                    _isLoading = true;
                  });
                },
                onLoadStop: (controller, url) {
                  handleLoadStop(context, url.toString());
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url.toString();
                  debugPrint("Intercepted URL: $url");
                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                  // Chấp nhận mọi chứng chỉ trong môi trường phát triển
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
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