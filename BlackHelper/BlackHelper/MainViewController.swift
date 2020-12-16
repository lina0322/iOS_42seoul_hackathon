//
//  ViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/15.
//

import UIKit

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

