//
//  WebviewJavascriptBridge.swift
//  WebviewJavaScriptBridge.swift
//
//  Created by Wong Zigii on 15/10/29.
//  Copyright © 2015年 Wong Zigii. All rights reserved.
//

import Foundation
import UIKit

//typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

typealias WVJBHandler = (data: AnyObject?, responseCallback: WVJBResponseCallback) -> Void
typealias WVJBResponseCallback = (data: AnyObject?) -> Void
typealias WVJBMessage = NSMutableDictionary

protocol WebviewJavascriptBridgeBaseDelegate {
    func _evaluateJavascript(javascriptCommand: String) -> String?
}

class WebviewJavascriptBridge: NSObject, UIWebViewDelegate, WebviewJavascriptBridgeBaseDelegate {
    
    override init() {
        
        
    }
    
    var _webViewDelegate: UIWebViewDelegate?
    
    var base: WebviewJavascriptBridgeBase
    
    var webview: UIWebView?
    
    var numberRequestLoading: UInt = 0
    
    class func enableLogging() {
        WebviewJavascriptBridgeBase.enableLogging()
    }
    
    convenience init (webview: UIWebView, handler: WVJBHandler) {
        
    }
    
    convenience init (webview: UIWebView, delegate: WebviewJavascriptBridgeBaseDelegate?, handler: WVJBHandler) {
        
    }
    
    convenience init (webview: UIWebView, delegate: WebviewJavascriptBridgeBaseDelegate?, handler: WVJBHandler, resourceBundle: NSBundle?) {
        
    }
    
    func send(data: AnyObject) {
        self.send(data, responseCallback: nil)
    }
    
    func send(data: AnyObject, responseCallback: WVJBResponseCallback?) {
        base.sendData(data, responseCallback: responseCallback, handlerName: nil)
    }
    
    func callHandler(handlerName: String) {
        self.callHandler(handlerName, data: nil, responseCallback: nil)
    }
    
    func callHandler(handlerName: String, data: AnyObject?) {
        self.callHandler(handlerName, data: data, responseCallback: nil)
    }
    
    func callHandler(handlerName: String, data: AnyObject?, responseCallback: WVJBResponseCallback?) {
        base.sendData(data, responseCallback: responseCallback, handlerName: handlerName)
    }
    
    func registerHandler(handlerName: String, handler: WVJBHandler) {
        base.messagerHandler[handlerName] = handler
    }
    
    // MARK : WebviewJavascriptBridgeBaseDelegate
    
    func _evaluateJavascript(javascriptCommand: String) -> String? {
        return self.webview?.stringByEvaluatingJavaScriptFromString(javascriptCommand)
    }
    
    func platformSpecificSetup(webview: UIWebView, delegate: UIWebViewDelegate?, handler: WVJBHandler, resourceBundle: NSBundle?) {
        self.webview = webview;
        self.webview?.delegate = self
        _webViewDelegate = delegate
        self.base = WebviewJavascriptBridgeBase(handler: handler, bundle: resourceBundle)
        self.base.delegate = self
    }
    
    // MARK: - Deinit
    
    deinit {
        
    }
    
    // MARK: - UIWebviewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        if webView != self.webview {
            return
        }
        
        numberRequestLoading += 1
        
        if let delegate = _webViewDelegate {
            delegate.webViewDidStartLoad!(webView)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView != self.webview {
            return
        }
        
        numberRequestLoading -= 1
        
        if numberRequestLoading == 0 && !(webview?.stringByEvaluatingJavaScriptFromString(base.webviewJavascriptCheckCommand()) == "true") {
            base.injectJavascriptFile(true)
        }
        
        base.dispatchStartUpMessageQueue()
        
        if let delegate = _webViewDelegate {
            delegate.webViewDidFinishLoad!(webView)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if webview != self.webview {
            return
        }
        
        numberRequestLoading -= 1
        
        if let delegate = _webViewDelegate {
            delegate.webView!(webView, didFailLoadWithError: error)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if webview != self.webview {
            return true
        }
        
        let url = request.URL
        if base.isCorrectProtocolScheme(url) {
            if base.isCorrectHost(url) {
                let messageQueueString = self._evaluateJavascript(base.webviewJavascriptCheckCommand())
                base.flushMessageQueue(messageQueueString)
            } else {
                base.logUnknownMessage(url)
            }
            return false
        } else if let delegate = _webViewDelegate {
            return delegate.webView!(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        } else {
            return true
        }
    }
}



class WebviewJavascriptBridgeBase {
    

    
    var messagerHandler = [String: WVJBHandler]()
    
    var delegate: WebviewJavascriptBridgeBaseDelegate?
    
    var startupMessageQueue : [WVJBMessage]?
    
    var responseCallbacks : [String: WVJBResponseCallback]?
    
    var messageHandlers : [String: WVJBHandler]?
    
    var uniqueID: UInt64 = 0
    
    required init(handler: WVJBHandler, bundle: NSBundle?) {
        
    }
    
    class func enableLogging() {
        
    }
    
    func reset() {
        self.startupMessageQueue?.removeAll()
        self.responseCallbacks?.removeAll()
        uniqueID = 0
    }
    
    func sendData(data: AnyObject?, responseCallback: WVJBResponseCallback?, handlerName: String?) {
        
        let message = WVJBMessage()
        
        if let data = data {
            message["data"] = data
        }
        
        if let callback = responseCallback {
            let callbackId = "swift_callback_" + String(++uniqueID)
            self.responseCallbacks![callbackId] = callback
            message["callbackId"] = callbackId
        }
        
        if let handlerName = handlerName {
            message["handlerName"] = handlerName
        }
        
        queueMessage(message)
    }
    
    func queueMessage(message: WVJBMessage) {
        if let queue = self.startupMessageQueue {
            
        }
    }
    
    func isCorrectProtocolScheme(url: NSURL?) -> Bool {
        
    }
    
    func logUnknownMessage(url: NSURL?) {
        
    }
    
    func isCorrectHost(url: NSURL?) -> Bool {
    
    }
    
    func flushMessageQueue(messageQueueString: String?) {
        
    }
    
    func dispatchStartUpMessageQueue() {
        
    }
    
    func injectJavascriptFile(shouldInject: Bool) {
        
    }
    
    func webviewJavascriptCheckCommand() -> String! {
        return "typeof WebviewJavascriptBridge == \'object'\\;"
    }
    
    // MARK: - Deinit
    
    deinit {
        
    }
}


