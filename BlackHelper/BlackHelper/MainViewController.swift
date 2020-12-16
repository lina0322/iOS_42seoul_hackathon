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
            
            //여기서 작업하세요.
            setupAPIData()
            
            
            guard let homeViewVC = self.storyboard?.instantiateViewController(withIdentifier: "TapBar") else { return }
            homeViewVC.modalPresentationStyle = .fullScreen
            present(homeViewVC, animated: true, completion: nil)
            let HomeView = HomeViewController()
            if let storyboard = self.navigationController {
                storyboard.pushViewController(HomeView, animated: true)
            }
        }
    }
    
    @objc func popUpLoginPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "WebLoginView") else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

func setupAPIData() {

    // Get info about current token user
    request(url: baseURL + "me") { (responseJSON) in
        guard let data = responseJSON else { return }
        print(data)
        me = CadetProfile(data: data)
        print(me?.username)
    }
    print(me?.username)
}


func request(url: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completionHandler: @escaping ((JSON?) -> Void)) {
    let token = code
    print("code : !!!!!"+token)
    let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let realURL = URL(string: encodedURL!)
    var request = URLRequest(url: realURL!)
    request.cachePolicy = cachePolicy
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            
            guard let data = data, let valueJSON = try? JSON(data: data) else {
                print("Request Error: Couldn't get data after request...")
                print(response ?? "NO RESPONSE")
                
                return
                
            }
            completionHandler(valueJSON)
        }
    }.resume()
}

