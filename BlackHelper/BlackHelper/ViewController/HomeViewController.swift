//
//  HomeViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var helperImageButton: UIImageView!
    @IBOutlet weak var peerImageButton: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let helperButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpHelperPage))
        helperImageButton.addGestureRecognizer(helperButtonTabRecognizer)
        helperImageButton.isUserInteractionEnabled = true
        
        let peerButtonTabRecognizer = UITapGestureRecognizer(target: self, action:#selector(popUpPeerPage))
        peerImageButton.addGestureRecognizer(peerButtonTabRecognizer)
        peerImageButton.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        while CadetData.me == nil { }
        
        let imageURL = URL(string: CadetData.me!.imageURL)!
        do {
            let data = try Data(contentsOf: imageURL)
            profileImage.image = UIImage(data: data)!.af_imageRoundedIntoCircle()
        } catch { }

        idLabel.text = CadetData.me!.username
        levelLabel.text = Constants.level + String(CadetData.me!.level)
        
        if let background = UIImage(named: Coalition.init(rawValue: CadetData.me!.coalitionName)!.cover) {
            backgroundView.backgroundColor = UIColor(patternImage: background)
        }
    }
    
    @objc func popUpHelperPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.helper.rawValue) else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func popUpPeerPage() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: View.peer.rawValue) else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
