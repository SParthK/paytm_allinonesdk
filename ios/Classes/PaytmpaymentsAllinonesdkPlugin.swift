import Flutter
import UIKit
import AppInvokeSDK

public class PaytmpaymentsAllinonesdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "paytmpayments_allinonesdk", binaryMessenger: registrar.messenger())
        let instance = PaytmpaymentsAllinonesdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.flutterCallbackResult = result
        guard  call.method.elementsEqual("startTransaction") else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        if let parameters = call.arguments as? [String: Any] {
            self.startTransaction(parameters: parameters, callBack: result)
        }
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Response in Plugin")
        print(url.absoluteString)
        let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
        self.handleResponseAppInvoke(dict) // MARK: Called to send response to flutter app in result parameter.
        return true
    }
    
    var flutterCallbackResult: FlutterResult?
    let appinvoke = AIHandler()
    
    func startTransaction(parameters: [String:Any], callBack: @escaping FlutterResult) {
        self.flutterCallbackResult = callBack
        if let mid = parameters["mid"] as? String, let isStaging = parameters["isStaging"] as? Bool, let orderId = parameters["orderId"] as? String, let transactionToken = parameters["txnToken"] as? String, let amount = parameters["amount"] as? String, let callbackUrl = parameters["callbackUrl"] as? String, let restrictAppInvoke = parameters["restrictAppInvoke"] as? Bool {
            DispatchQueue.main.async {
                var env: AIEnvironment = .production
                if isStaging {
                    env = .staging
                } else {
                    env = .production
                }
                self.appinvoke.setBridgeName(name: "Flutter")
                print(self.appinvoke.sdkVersion())
                self.appinvoke.restrictAppInvokeFlow(restrict: restrictAppInvoke)
                self.appinvoke.openPaytm(merchantId: mid, orderId: orderId, txnToken: transactionToken, amount: amount, callbackUrl: callbackUrl, delegate: self, environment: env, urlScheme: "")
            }
        }
    }
    
    //MARK: response got in the URL can be segregated and converted into json from here.
    func separateDeeplinkParamsIn(url: String?, byRemovingParams rparams: [String]?) -> [String: String] {
        guard let url = url else {
            return [String: String]()
        }
        
        /// This url gets mutated until the end. The approach is working fine in current scenario. May need a revisit.
        var urlString = stringByRemovingDeeplinkSymbolsIn(url: url)
        
        var paramList = [String: String]()
        let pList = urlString.components(separatedBy: CharacterSet.init(charactersIn: "&?//"))
        for keyvaluePair in pList {
            let info = keyvaluePair.components(separatedBy: CharacterSet.init(charactersIn: "="))
            if let fst = info.first , let lst = info.last, info.count == 2 {
                paramList[fst] = lst.removingPercentEncoding
                if let rparams = rparams, rparams.contains(info.first!) {
                    urlString = urlString.replacingOccurrences(of: keyvaluePair + "&", with: "")
                    //Please dont interchage the order
                    urlString = urlString.replacingOccurrences(of: keyvaluePair, with: "")
                }
            }
            if info.first == "response" {
                paramList["response"] = keyvaluePair.replacingOccurrences(of: "response=", with: "").removingPercentEncoding
            }
        }
        
        if let trimmedURL = pList.first {
            paramList["trimmedurl"] = trimmedURL
        }
        return paramList
    }
    
    func stringByRemovingDeeplinkSymbolsIn(url: String) -> String {
        var urlString = url.replacingOccurrences(of: "$", with: "&")
        
        /// This may need a revisit. This is doing more than just removing the deeplink symbol.
        if let range = urlString.range(of: "&"), urlString.contains("?") == false{
            urlString = urlString.replacingCharacters(in: range, with: "?")
        }
        return urlString
    }
}


extension PaytmpaymentsAllinonesdkPlugin: AIDelegate {
    public func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        self.handleResponseRedirection(response)
    }
    
    public func openPaymentWebVC(_ controller: UIViewController?) {
        print("Response2")
        
        if let vc = controller {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}

private extension PaytmpaymentsAllinonesdkPlugin {
    enum MerchantPaymentStatus: String {
        case none = "PYTM_100"
        case initiated = "PYTM_101"
        case paymentMode = "PYTM_102"
        case paymentDeduction = "PYTM_103"
        case errorInParameter = "PYTM_104"
        case error = "PYTM_105"
        case cancel = "PYTM_106"
    }
    
    func handleResponseAppInvoke(_ response: [String: Any]) {
        var status: MerchantPaymentStatus = .none
        if let statusCode = response["status"] as? String {
            switch  statusCode {
            case "PYTM_103": status = .paymentDeduction
            case "PYTM_104": status = .errorInParameter
            case "PYTM_105": status = .error
            case "PYTM_106": status = .cancel
            default: status = .error
            }
        }
        
        if status == .paymentDeduction {
            self.flutterCallbackResult?(response)
        } else if status == .error {
            let error = FlutterError(code: "0", message: "Transaction Failure", details: response)
            self.flutterCallbackResult?(error)
        } else if status == .cancel {
            let error = FlutterError(code: "0", message: "User has not completed transaction.", details: response)
            self.flutterCallbackResult?(error)
        } else if status == .errorInParameter {
            let error = FlutterError(code: "0", message: "Invalid Parameters", details: response)
            self.flutterCallbackResult?(error)
        } else {
            self.flutterCallbackResult?(response)
        }
    }
    
    func handleResponseRedirection(_ response: [String: Any]) {
        if let STATUS = response["STATUS"] as? String, STATUS == "TXN_SUCCESS" {
            self.flutterCallbackResult?(response)
        } else {
            var message = ""
            if let errorMSG = response["RESPMSG"] as? String {
                message = errorMSG
            }
            let error = FlutterError(code: "0", message: message, details: response)
            self.flutterCallbackResult?(error)
        }
    }
}
