class InitiateTransactionRepsonse {
  Head? head;
  Body? body;

  InitiateTransactionRepsonse({this.head, this.body});

  InitiateTransactionRepsonse.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? Head.fromJson(json['head']) : null;
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }
}

class Head {
  String? responseTimestamp;

  Head({this.responseTimestamp});

  Head.fromJson(Map<String, dynamic> json) {
    responseTimestamp = json['responseTimestamp'];
  }
}

class Body {
  ResultInfo? resultInfo;
  String? txnToken;
  bool? isPromoCodeValid;
  bool? authenticated;

  Body(
      {this.resultInfo,
      this.txnToken,
      this.isPromoCodeValid,
      this.authenticated});

  Body.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? ResultInfo.fromJson(json['resultInfo'])
        : null;
    txnToken = json['txnToken'];
    isPromoCodeValid = json['isPromoCodeValid'];
    authenticated = json['authenticated'];
  }
}

class ResultInfo {
  String? resultStatus;
  String? resultCode;
  String? resultMsg;
  bool? retry;

  ResultInfo({this.resultStatus, this.resultCode, this.resultMsg, this.retry});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    resultStatus = json['resultStatus'];
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
    retry = json['retry'];
  }
}
