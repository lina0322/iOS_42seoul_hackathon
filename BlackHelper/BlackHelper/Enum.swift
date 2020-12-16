//
//  Enum.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
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
