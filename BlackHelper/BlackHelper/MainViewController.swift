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
    
    @objc func popUpLoginPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "WebLoginView") else { return }
        present(loginVC, animated: true, completion: nil)
  }
}

