import 'package:flutter_test/flutter_test.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk_platform_interface.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPaytmpaymentsAllinonesdkPlatform
    with MockPlatformInterfaceMixin
    implements PaytmpaymentsAllinonesdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PaytmpaymentsAllinonesdkPlatform initialPlatform = PaytmpaymentsAllinonesdkPlatform.instance;

  test('$MethodChannelPaytmpaymentsAllinonesdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPaytmpaymentsAllinonesdk>());
  });

  test('getPlatformVersion', () async {
    PaytmpaymentsAllinonesdk paytmpaymentsAllinonesdkPlugin = PaytmpaymentsAllinonesdk();
    MockPaytmpaymentsAllinonesdkPlatform fakePlatform = MockPaytmpaymentsAllinonesdkPlatform();
    PaytmpaymentsAllinonesdkPlatform.instance = fakePlatform;

    expect(await paytmpaymentsAllinonesdkPlugin.getPlatformVersion(), '42');
  });
}
