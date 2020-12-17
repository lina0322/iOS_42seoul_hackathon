//
//  ChatViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import UIKit
class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = CadetData.me!.username
        let user = IRCUser(username: username, realName: username, nick: username)
        let server = IRCServer.connect("192.168.0.5", port: 6667, user: user)
        
        let channel = server.join("Libft")
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
