//
//  Constants.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/17.
//

import Foundation

enum Coalition: String {
    case gun = "gun"
    case gon = "gon"
    case gam = "gam"
    case lee = "lee"
    
    var cover: String {
        let cover = "_cover"
        return self.rawValue + cover
    }
}

enum View: String {
    case main = "MainView"
    case webLogin = "WebLoginView"
    case home = "HomeView"
    case helper = "HelperView"
    case peer = "PeerView"
    case tapBar = "TapBar"
}

struct Constants {
    
}
