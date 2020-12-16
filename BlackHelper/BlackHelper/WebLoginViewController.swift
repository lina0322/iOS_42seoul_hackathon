//
//  WebLoginViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/15.
//

import UIKit
import WebKit

class WebLoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var LoginwebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        open42LoginPage()
        LoginwebView.navigationDelegate = self
        
    }
    
    func open42LoginPage() {
        if let url = URL(string:
                            "https://api.intra.42.fr/oauth/authorize?client_id=9ed59a92caf24a4acce31ee4a08d1b1590bda83f184d5743d54f6181a6a15744&redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback&response_type=code") {
            let request: URLRequest = URLRequest(url: url)
            LoginwebView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        let strUrl :String = webView.url!.absoluteString
        if (strUrl.range(of: "code") != nil)
        {
            let code = strUrl.split(separator: "=")[1]
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
        dismiss(animated: true, completion: nil)
    }
}
