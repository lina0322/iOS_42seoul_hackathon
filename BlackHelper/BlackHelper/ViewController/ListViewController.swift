//
//  ListViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import UIKit

class ListViewController: UIViewController {

    @IBAction func goChatView() {
        guard let chatVC = self.storyboard?.instantiateViewController(withIdentifier: View.chat.rawValue) else { return }
        chatVC.modalPresentationStyle = .fullScreen
        present(chatVC, animated: true, completion: nil)
    }
}
