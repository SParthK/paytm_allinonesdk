import 'dart:convert';
import 'package:paytmpayments_allinonesdk_example/network/base_urls.dart';
import 'package:http/http.dart' as http;
import 'initiate_transaction_model.dart';

class InitiateTransactionHelper {
  const InitiateTransactionHelper(
      this.mid, this.amount, this.orderId, this.isStaging);
  final String mid, amount, orderId;
  final bool isStaging;

  Future<InitiateTransactionRepsonse> makeInitTransactionRequest() async {
    final baseUrl = (isStaging) ? BaseUrls.STAG_URL : BaseUrls.PROD_URL;
    final url =
        '$baseUrl/theia/api/v1/initiateTransaction?mid=$mid&orderId=$orderId';
    final headers = <String, String>{'Content-Type': 'application/json'};

    final reqHead = <String, dynamic>{
      'channelId': 'WAP',
      'clientId': 'C11',
      'signature': 'CH',
      'version': 'v1',
      'requestTimestamp': DateTime.now().millisecondsSinceEpoch.toString()
    };

    final reqBody = <String, dynamic>{
      'mid': mid,
      'orderId': orderId,
      'requestType': 'Payment',
      'userInfo': <String, dynamic>{
        'custId': 'cid',
        'email': '',
        'firstName': '',
        'lastName': '',
        'mobile': ''
      },
      'txnAmount': <String, dynamic>{'currency': 'INR', 'value': amount},
      'callbackUrl': '$baseUrl/theia/paytmCallback?ORDER_ID=$orderId',
      'websiteName': 'retail'
    };

    final postRequest = <String, dynamic>{'body': reqBody, 'head': reqHead};

    print(postRequest);
    print(url);

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(postRequest));

    print(response.body);

    if (response.statusCode == 200) {
      return InitiateTransactionRepsonse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Network Error!!');
    }
  }
}
