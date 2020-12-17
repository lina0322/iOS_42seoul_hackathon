//
//  HomeViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var helperImageButton: UIImageView!
    @IBOutlet weak var peerImageButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let helperButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpHelperPage))
        helperImageButton.addGestureRecognizer(helperButtonTabRecognizer)
        helperImageButton.isUserInteractionEnabled = true
        
        let peerButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpPeerPage))
        peerImageButton.addGestureRecognizer(peerButtonTabRecognizer)
        peerImageButton.isUserInteractionEnabled = true
        
        if let background = UIImage(named: Coalition.init(rawValue: "lee")!.cover) {
            backgroundView.backgroundColor = UIColor(patternImage: background)
        }
    }
    
    @objc func popUpHelperPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.helper.rawValue) else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func popUpPeerPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.peer.rawValue) else { return }
        present(loginVC, animated: true, completion: nil)
    }
}
