//
//  Constants.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import Foundation

enum Coalition: String {
    case gun = "Gun"
    case gon = "Gon"
    case gam = "Gam"
    case lee = "Lee"
    
    var cover: String {
        let cover = "_cover"
        return self.rawValue.lowercased() + cover
    }
}

enum View: String {
    case main = "MainView"
    case webLogin = "WebLoginView"
    case home = "HomeView"
    case helper = "HelperView"
    case peer = "PeerView"
    case tapBar = "TapBar"
    case chat = "ChatView"
    case list = "ListView"
}

struct Constants {
    static var token:String = ""
    static let baseURL = "https://api.intra.42.fr/v2/"
    static let emptyString = ""
    static let me = "me"
    static let level = "Level : "
    static let wallet = "Wallet : $"
    static let coalition = "Coalition : "
}

class Check {
    static var login = Check()
    var success: Bool = false
    private init() {}
}
