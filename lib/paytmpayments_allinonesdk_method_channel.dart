import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'paytmpayments_allinonesdk_platform_interface.dart';

/// An implementation of [PaytmpaymentsAllinonesdkPlatform] that uses method channels.
class MethodChannelPaytmpaymentsAllinonesdk extends PaytmpaymentsAllinonesdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('paytmpayments_allinonesdk');

  @override
  Future<Map<dynamic, dynamic>?> startTransaction(
      String mid,
      String orderId,
      String amount,
      String txnToken,
      String callbackUrl,
      bool isStaging,
      bool restrictAppInvoke,
      [bool enableAssist = true]) {
    var sendMap = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };
    return methodChannel.invokeMethod('startTransaction', sendMap);
  }
}
