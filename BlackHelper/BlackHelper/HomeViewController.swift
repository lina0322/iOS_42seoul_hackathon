//
//  HomeViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let background = UIImage(named: "lee_cover") {
            backgroundView.backgroundColor = UIColor(patternImage: background)
        }
        
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
