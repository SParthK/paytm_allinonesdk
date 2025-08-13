import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPaytmpaymentsAllinonesdk platform = MethodChannelPaytmpaymentsAllinonesdk();
  const MethodChannel channel = MethodChannel('paytmpayments_allinonesdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
