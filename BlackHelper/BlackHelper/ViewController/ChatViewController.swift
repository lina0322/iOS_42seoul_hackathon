//
//  ChatViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import UIKit

class ChatViewController: UIViewController,URLSessionDelegate,IRCServerDelegate,IRCChannelDelegate {
    func didRecieveMessage(_ server: IRCServer, message: String) {
        print(message)
    }
    
    func didRecieveMessage(_ channel: IRCChannel, message: String) {
        print("\(channel): \(message)")
    }
    
    var server: IRCServer? = nil
    var channel: IRCChannel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("어서와")
        let username = CadetData.me!.username
        let user = IRCUser(username: username, realName: username, nick: username)
        
        server = IRCServer.connect("192.168.0.5", port: 6667, user: user)
        server?.delegate = self
        
        channel = server?.join("Libft")
        channel?.delegate = self
        channel?.send("hi")
    }
}
