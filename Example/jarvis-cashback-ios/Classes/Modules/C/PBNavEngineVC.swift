//
//  PBNavEngineVC.swift
//  BusinessApp
//
//  Created by Ankush Gupta on 07/01/20.
//  Copyright © 2020 PayTm. All rights reserved.
//

import UIKit
import WebKit
import jarvis_locale_ios
import CoreLocation

enum NavEngineJSInterface: String, CaseIterable {
    
    case kCommunicationWindow = "CommunicationWindow"
    case kOnBackPressed       = "onBackPressed"
    case kSessionExpiryEvent  = "sessionExpiryEvent"
    case kProcessLink         = "processLink"
    case kHideLoadingScreen   = "hideLoadingScreen"
}

class PBNavEngineVC: UIViewController {
    @IBOutlet weak var webContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    private var webView : WKWebView!

    var umpLoadURL = ""
    
    class var newInstance : PBNavEngineVC {
        get {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PBNavEngineVC") as! PBNavEngineVC
        }
    }
    
    private var loadURL: String {
        get {
            let url = umpLoadURL
            let urlComponents = url.split(separator: "?")
            if urlComponents.count == 3 {
                let baseURL = urlComponents[0]
                let redirectUrl = urlComponents[1]
                let queryParams = urlComponents[2]
                let params = "?osType=ios&appVersion=3.10.0"
                let allParams = "\(params)&\(queryParams)"
                var finalUrl = "\(baseURL)?\(redirectUrl)"
                if let escapedString = allParams.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                    finalUrl = "\(finalUrl)\(escapedString)"
                }
                return finalUrl
            }
            return url
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //your loader logic
        configureWKWebView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureWKWebView() {
        //1
        let contentController = WKUserContentController()
        contentController.add(self,name: NavEngineJSInterface.kCommunicationWindow.rawValue)
        
        //2
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        //Use to disable zoom when inter in textbox in wkwebview
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        //3
        webView = WKWebView(frame: webContainerView.bounds, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webContainerView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: webContainerView.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webContainerView.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: webContainerView.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webContainerView.bottomAnchor, constant: 0).isActive = true
        webView.navigationDelegate =  self
        webView.uiDelegate = self
        let urlStr = loadURL
        
        let weburl = URL(string:urlStr)
        let request = NSMutableURLRequest(url: weburl!)
        request.setValue("9088751e-b67b-4de4-9200-b12a97102000", forHTTPHeaderField: "x-app-token")
        request.setValue("WLBNGG08279113469809", forHTTPHeaderField: "x-app-mid")
        request.setValue("business-app-ios-staging", forHTTPHeaderField: "x-app-client")
        request.setValue("P4B", forHTTPHeaderField: "source")
        request.setValue("true", forHTTPHeaderField: "isFeatureMapAvailable")
        var languageCode = "en"
        if let currLocale = LanguageManager.shared.getCurrentLocale(), let langCode = currLocale.languageCode {
            languageCode = langCode
        }
        request.setValue(languageCode + "-IN", forHTTPHeaderField: "Accept-Language")
        
        let req = request as URLRequest
        webView.load(req)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PBNavEngineVC: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate{
    //Start----------------------------------->
    //MARK:- WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //This function handles the events coming from javascript.
        //We can access properties through the message body, like this:
        if message.name == NavEngineJSInterface.kCommunicationWindow.rawValue, let param = message.body as? String {
            
            guard let dict =  param.dictFormat() else {
                return
            }
            
            if let funcName = dict["functionName"] as? String {
                switch funcName {
                case NavEngineJSInterface.kHideLoadingScreen.rawValue: break
                // your logic for hiding your loader
                case NavEngineJSInterface.kOnBackPressed.rawValue: break
                // handle back press at your end
                case NavEngineJSInterface.kSessionExpiryEvent.rawValue: break
//                    AppManager.logout(isSessionOut:true)
                default:
                    break
                }
            }
        }
    }

    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handelWebSucess(with: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
        handelWebSucess(with: false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handelWebSucess(with: true)
    }
    
    private func handelWebSucess(with isError:Bool){
        backButton.isHidden = !isError
        if isError{
//            viewBlankLoading?.isNoInternet = true
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        
        if navigationAction.request.url?.scheme == "tel" {
            guard let url = navigationAction.request.url else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, completionHandler: { (success) in
                })
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    //MARK:- WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
