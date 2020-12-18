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
        setUpKeyboardDoneButton()
        
        let username = CadetData.me!.username
        let user = IRCUser(username: username, realName: username, nick: username)
        server = IRCServer.connect("192.168.0.5", port: 6667, user: user)
        server?.delegate = self
        
        channel = server?.join("Libft")
        channel?.delegate = self
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChatView), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        DispatchQueue.global(qos: .background).async { [self] in
            while(true){
                sleep(1)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
                self.view.setNeedsLayout()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        comments.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        view.textLabel?.text = self.comments[indexPath.row]
        
        return view
    }
    
    func didRecieveMessage(_ server: IRCServer, message: String) {
        comments.append(message)
    }
    
    func didRecieveMessage(_ channel: IRCChannel, message: String) {
        comments.append(message)
    }
    
    @objc func reloadChatView(){
        self.chatTableView.reloadData()
    }
    
    @objc func sendMessage() {
        if (messageTextField.hasText) {
            channel?.send(messageTextField.text!)
            comments.append(messageTextField.text!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
            messageTextField.text = ""
        }
    }
    
    private func setUpKeyboardDoneButton() {
            let toolBarKeyboard = UIToolbar()
            toolBarKeyboard.sizeToFit()
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendMessage))
            
            toolBarKeyboard.items = [flexibleSpace, doneButton]
            messageTextField.inputAccessoryView = toolBarKeyboard
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
