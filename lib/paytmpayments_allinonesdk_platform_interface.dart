import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'paytmpayments_allinonesdk_method_channel.dart';

abstract class PaytmpaymentsAllinonesdkPlatform extends PlatformInterface {
  /// Constructs a PaytmpaymentsAllinonesdkPlatform.
  PaytmpaymentsAllinonesdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static PaytmpaymentsAllinonesdkPlatform _instance = MethodChannelPaytmpaymentsAllinonesdk();

  /// The default instance of [PaytmpaymentsAllinonesdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelPaytmpaymentsAllinonesdk].
  static PaytmpaymentsAllinonesdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PaytmpaymentsAllinonesdkPlatform] when
  /// they register themselves.
  static set instance(PaytmpaymentsAllinonesdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<dynamic, dynamic>?> startTransaction(
      String mid,
      String orderId,
      String amount,
      String txnToken,
      String callbackUrl,
      bool isStaging,
      bool restrictAppInvoke,
      [bool enableAssist = true]) {
    throw UnimplementedError('startTransaction() has not been implemented.');
  }
}
