//
//  WebLoginViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/15.
//

import UIKit
import WebKit

var code: String = ""
class WebLoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var LoginWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginWebView.uiDelegate = self
        LoginWebView.navigationDelegate = self
        open42LoginPage()
    }
    
    func open42LoginPage() {
        if let url = URL(string:
                            "https://api.intra.42.fr/oauth/authorize?client_id=9ed59a92caf24a4acce31ee4a08d1b1590bda83f184d5743d54f6181a6a15744&redirect_uri=http%3A%2F%2Flocalhost&response_type=code") {
            let request: URLRequest = URLRequest(url: url)
            LoginWebView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        let strUrl : String = webView.url!.absoluteString
        print(strUrl)
        if (strUrl.range(of: "code=") != nil)
        {
            code = String(strUrl.split(separator: "=")[1])
            done()
        }
        else{
            print("nope")
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        Check.login.success = true
        processOAuthResponse(URL(string: "https://api.intra.42.fr/oauth/token")!)

        dismiss(animated: true, completion: nil)
    }
    
    
}
