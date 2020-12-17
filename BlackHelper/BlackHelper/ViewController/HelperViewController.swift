//
//  HelperViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import UIKit

class HelperViewController: UIViewController {

    @IBOutlet weak var chatButton: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let chatButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpchatPage))
        chatButton.addGestureRecognizer(chatButtonTabRecognizer)
        chatButton.isUserInteractionEnabled = true
    }
    
    @objc func popUpchatPage() {
        guard let chatVC = self.storyboard?.instantiateViewController(withIdentifier: View.chat.rawValue) else { return }
        chatVC.modalPresentationStyle = .fullScreen
        present(chatVC, animated: true, completion: nil)
    }
}
