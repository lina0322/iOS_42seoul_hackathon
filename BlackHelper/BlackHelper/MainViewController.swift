//
//  ViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/15.
//

import UIKit
import SwiftyJSON

let baseURL = "https://api.intra.42.fr/v2/"
var me: CadetProfile?
var token:String?

class MainViewController: UIViewController {
    
    @IBOutlet weak var loginButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpLoginPage))
        loginButtonImage.addGestureRecognizer(loginButtonTabRecognizer)
        loginButtonImage.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Check.login.success {
            while (token == nil){}
            setupAPIData()

            guard let homeViewVC = self.storyboard?.instantiateViewController(withIdentifier: View.tapBar.rawValue) else { return }
            homeViewVC.modalPresentationStyle = .fullScreen
            present(homeViewVC, animated: true, completion: nil)
            let HomeView = HomeViewController()
            if let storyboard = self.navigationController {
                storyboard.pushViewController(HomeView, animated: true)
            }
        }
    }
    
    @objc func popUpLoginPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.webLogin.rawValue) else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

func setupAPIData() {
    request(url: baseURL + "me") { (responseJSON) in
        guard let data = responseJSON else { return }
        print(data)
        me = CadetProfile(data: data)
        print(me?.username)
    }
    print(me?.username)
}


func request(url: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completionHandler: @escaping ((JSON?) -> Void)) {
    let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let realURL = URL(string: encodedURL!)
    var request = URLRequest(url: realURL!)
    request.cachePolicy = cachePolicy
    request.httpMethod = "GET"
    request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.global().async {
            
            guard let data = data, let valueJSON = try? JSON(data: data) else {
                print("Request Error: Couldn't get data after request...")
                print(response ?? "NO RESPONSE")
                
                return
            }
            print(valueJSON)
            completionHandler(valueJSON)
        }
    }.resume()
}

fileprivate func generateRandomString() -> String {
    let length = Int.random(in: 43...128)
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement()! })
}
func processOAuthResponse(_ url: URL) {
    let tokenParams = [
        "grant_type": "authorization_code",
        "client_id": "9ed59a92caf24a4acce31ee4a08d1b1590bda83f184d5743d54f6181a6a15744",
        "client_secret": "eff51fdb4d09fcb61339cde21d2257eacd63063154aff258017197dbab7f6a37",
        "code": code,
        "redirect_uri": "http://localhost",
    ]
    
    var urequest = URLRequest(url: url)
    urequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    urequest.httpMethod = "POST"
    urequest.httpBody = tokenParams.percentEscaped().data(using: .utf8)
    URLSession.shared.dataTask(with: urequest) { data, _, error in
        DispatchQueue.global().sync {
            guard error == nil, let data = data, let valueJSON = try? JSON(data: data) else {
                return
            }
            guard valueJSON["token_type"].string == "bearer",
                  let accessToken = valueJSON["access_token"].string
            else {
                return
            }
            token = accessToken
        }
    }.resume()
    
}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
