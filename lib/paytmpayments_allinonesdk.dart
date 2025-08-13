import 'paytmpayments_allinonesdk_platform_interface.dart';

class PaytmPaymentsAllinonesdk {
  Future<Map<dynamic, dynamic>?> startTransaction(
      String mid,
      String orderId,
      String amount,
      String txnToken,
      String callbackUrl,
      bool isStaging,
      bool restrictAppInvoke,
      [bool enableAssist = true]) {
    return PaytmpaymentsAllinonesdkPlatform.instance.startTransaction(
        mid,
        orderId,
        amount,
        txnToken,
        callbackUrl,
        isStaging,
        restrictAppInvoke,
        enableAssist);
  }
}
