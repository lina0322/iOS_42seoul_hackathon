//
//  ViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/15.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController {
    
    @IBOutlet weak var loginButtonImage: UIImageView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 2000, height: 2000)
            activityIndicator.center = self.view.center
            activityIndicator.color = UIColor.red
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            activityIndicator.stopAnimating()
            return activityIndicator }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.activityIndicator)

        let loginButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpLoginPage))
        loginButtonImage.addGestureRecognizer(loginButtonTabRecognizer)
        loginButtonImage.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Check.login.success {
            while (Constants.token == Constants.emptyString){
                activityIndicator.startAnimating()
            }
            setupAPIData()
            while (CadetData.me == nil) {}
            getCoalitionInfo(forUserId: CadetData.me!.userId){coaName in
                CadetData.me!.coalitionName = coaName
                
            }
           guard let homeViewVC = self.storyboard?.instantiateViewController(withIdentifier: View.tapBar.rawValue) else { return }
            homeViewVC.modalPresentationStyle = .fullScreen
            present(homeViewVC, animated: true, completion: nil)
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func popUpLoginPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.webLogin.rawValue) else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    func setupAPIData() {
        request(url: Constants.baseURL + Constants.me) { (responseJSON) in
            guard let data = responseJSON else { return }
            CadetData.me = CadetProfile(data: data)
            
        }
    }
    
    func getCoalitionInfo(forUserId id: Int, completionHandler: @escaping (String) -> Void) {
        request(url: Constants.baseURL + "users/\(id)/coalitions") { (responseJSON) in
            guard let data = responseJSON, data.isEmpty == false else {
                completionHandler("Unknown")
                return
            }
            var lowestId = data.arrayValue[0]["id"].intValue
            var coaName = data.arrayValue[0]["name"].stringValue
            
            let piscineCoas = [9, 10, 11, 12]
            for coalition in data.arrayValue {
                let id = coalition["id"].intValue
                if id <= lowestId && !piscineCoas.contains(id) {
                    lowestId = id
                    coaName = coalition["name"].stringValue
                }
            }
            completionHandler(coaName)
        }
    }
    
    func request(url: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completionHandler: @escaping ((JSON?) -> Void)) {
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let realURL = URL(string: encodedURL!)
        var request = URLRequest(url: realURL!)
        request.cachePolicy = cachePolicy
        request.httpMethod = "GET"
        request.addValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.global().async {
                
                guard let data = data, let valueJSON = try? JSON(data: data) else {
                    print("Request Error: Couldn't get data after request...")
                    print(response ?? "NO RESPONSE")
                    
                    return
                }
                completionHandler(valueJSON)
            }
        }.resume()
    }
    
    fileprivate func generateRandomString() -> String {
        let length = Int.random(in: 43...128)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension UIViewController {
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
                Constants.token = accessToken
            }
        }.resume()
    }
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
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
