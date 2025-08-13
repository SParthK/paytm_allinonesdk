import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'network/initiate_transaction_helper.dart';
import 'edit_text.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App'),
        ),
        body: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String mid = "", orderId = "", amount = "1", txnToken = "";
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool enableAssist = true;

  @override
  void initState() {
    super.initState();
    orderId = generateOrderId();
  }

  String generateOrderId() {
    final randomNum =
        Random().nextDouble() * DateTime.now().millisecondsSinceEpoch;
    return 'PARCEL${1 + (randomNum % 2000).floor()}A${(randomNum % 100000).floor() + 10000}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              EditText('Merchant ID', mid, onChange: (val) => mid = val),
              EditText('Order ID', orderId, onChange: (val) => orderId = val),
              EditText('Amount', amount, onChange: (val) => amount = val),
              EditText('Transaction Token', txnToken,
                  onChange: (val) => txnToken = val),
              EditText('CallBack URL', callbackUrl,
                  onChange: (val) => callbackUrl = val),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _generateTxnToken,
                  child: const Text('Generate Txn Token'),
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Colors.lightBlue,
                      value: isStaging,
                      onChanged: (bool? val) {
                        setState(() {
                          isStaging = val!;
                        });
                      }),
                  const Text("Staging")
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Colors.lightBlue,
                      value: restrictAppInvoke,
                      onChanged: (bool? val) {
                        setState(() {
                          restrictAppInvoke = val!;
                        });
                      }),
                  const Text("Restrict AppInvoke")
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: isApiCallInprogress
                      ? null
                      : () {
                          _startTransaction();
                        },
                  child: const Text('Start Transcation'),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text("Message : "),
              ),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateTxnToken() async {
    setState(() {
      result = '';
      txnToken = '';
    });

    if (mid.isEmpty) {
      setState(() {
        result = 'MID Field is Empty';
      });
      return;
    }

    if (orderId.isEmpty) {
      setState(() {
        result = 'OrderID Field is Empty';
      });
      return;
    }

    try {
      var initTransactionResponse =
          await InitiateTransactionHelper(mid, amount, orderId, isStaging)
              .makeInitTransactionRequest();
      if (initTransactionResponse.body?.txnToken != null &&
          initTransactionResponse.body?.txnToken?.isNotEmpty == true) {
        setState(() {
          txnToken = initTransactionResponse.body!.txnToken!;
        });
        return;
      } else {
        setState(() {
          result = initTransactionResponse.body?.resultInfo?.resultMsg ??
              'Txn Api Failed';
        });
        return;
      }
    } catch (err) {
      setState(() {
        result = err.toString();
      });
      return;
    }
  }

  Future<void> _startTransaction() async {
    setState(() {
      result = '';
    });

    if (txnToken.isEmpty) {
      setState(() {
        result = 'Txn Token Field is Empty';
      });
      return;
    }

    if (mid.isEmpty) {
      setState(() {
        result = 'MID Field is Empty';
      });
      return;
    }

    if (orderId.isEmpty) {
      setState(() {
        result = 'OrderID Field is Empty';
      });
      return;
    }

    try {
      var response = PaytmPaymentsAllinonesdk().startTransaction(
          mid,
          orderId,
          amount,
          txnToken,
          callbackUrl,
          isStaging,
          restrictAppInvoke,
          enableAssist);
      response.then((value) {
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            result = "${onError.message} \n  ${onError.details}";
          });
        } else {
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      setState(() {
        result = err.toString();
      });
    }
  }
}
