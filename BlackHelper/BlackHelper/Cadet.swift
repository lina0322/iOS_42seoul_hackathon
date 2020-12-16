//
//  Cadet.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
//

import Foundation

class Cadet {
    var id: String
    var name: String
    var level: Any
    var coalition: Any
    var doneProject: [Any]
    var currentProject: [Any]
    var helperCount: Int = 0
    
    var helperRank: Int {
        return helperCount
    }
    
    init(id: String, name: String, level: Any, coalition: Any, doneProject: [Any], currentProject: [Any]) {
        self.id = id
        self.name = name
        self.level = level
        self.coalition = coalition
        self.doneProject = doneProject
        self.currentProject = currentProject
    }
}
