//
//  ChatViewController.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import UIKit

class ChatViewController: UIViewController,URLSessionDelegate,IRCServerDelegate,IRCChannelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var server: IRCServer? = nil
    var channel: IRCChannel? = nil
    var comments: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = CadetData.me!.username
        let user = IRCUser(username: username, realName: username, nick: username)
        
        server = IRCServer.connect("192.168.0.5", port: 6667, user: user)
        server?.delegate = self
        
        channel = server?.join("Libft")
        channel?.delegate = self
        channel?.send("hi")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        view.textLabel!.text = self.comments[indexPath.row]
        
        return view
    }
    
    func didRecieveMessage(_ server: IRCServer, message: String) {
        comments.append(message)
        print(message)
    }
    
    func didRecieveMessage(_ channel: IRCChannel, message: String) {
        comments.append(message)
        print("\(channel): \(message)")
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
