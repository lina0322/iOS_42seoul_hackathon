//
//  Cadet.swift
//  BlackHelper
//
//  Created by 임리나 on 2020/12/16.
//

import Foundation
import UIKit
import SwiftyJSON
import SVGKit

typealias Cadet = (id: Int, login: String)

struct CadetData {
    static var me: CadetProfile?
}

class CadetProfile {
    var cursusUsers: [JSON]
    var projectsUsers: [JSON]
    
    var userId: Int = 0
    var username: String
    var fullName: String
    var imageURL: String
    var isStaff: Bool
    var phoneNumber: String
    var email: String
    var wallets: Int
    var correctionPoints: Int
    var level: Double = 0
    
    var coalitionName: String = ""
    
    var piscineMonth: String
    var piscineYear: String
    
    var mainCursusId: Int = 1
    var mainCursusName: String = ""
    var cursusList: [(id: Int, name: String)] = []
    
    var mainCampusId: Int = 1
    var mainCampusName: String = ""
    var campusList: [(id: Int, name: String)] = []
    
    var projects: [Project] = []
    var skills: [(name: String, level: Double)] = []
    
    var location: String?
    
    init(data: JSON) {
        username = data["login"].stringValue
        fullName = data["displayname"].stringValue
        imageURL = data["image_url"].stringValue
        isStaff = data["staff?"].boolValue
        phoneNumber = data["phone"].stringValue
        email = data["email"].stringValue
        wallets = data["wallet"].intValue
        correctionPoints = data["correction_point"].intValue
        piscineMonth = data["pool_month"].stringValue
        piscineYear = data["pool_year"].stringValue
        
        location = data["location"].string
        
        let projects = data["projects_users"].arrayValue
        projectsUsers = projects
        let cursuses = data["cursus_users"].arrayValue
        cursusUsers = cursuses
        var cursusId: Int = 1
        if cursuses.count > 0 {
            for cursus in cursuses {
                let info = cursus["cursus"]
                let name = info["name"].stringValue
                let id = info["id"].intValue
                if cursus["grade"].string != nil || cursuses.count == 1 {
                    mainCursusId = id
                    mainCursusName = name
                    cursusId = id
                }
                cursusList.append((id, name))
            }
        }
        
        let campusUsers = data["campus_users"].arrayValue
        var primaryId = 1
        for campus in campusUsers where campus["is_primary"].boolValue == true {
            primaryId = campus["campus_id"].intValue
            break
        }
        
        let campuses = data["campus"].arrayValue
        for campus in campuses {
            let id = campus["id"].intValue
            let name = campus["name"].stringValue
            if id == primaryId {
                mainCampusId = id
                mainCampusName = name
            }
            campusList.append((id, name))
        }
        getLevelAndSkills(cursusId: cursusId)
        getProjects(cursusId: cursusId)
       
    }
    
    func getLevelAndSkills(cursusId: Int) {
        skills = []
        for cursus in cursusUsers where cursus["cursus_id"].int == cursusId {
            self.level = cursus["level"].doubleValue
            self.userId = cursus["user"]["id"].intValue
            for skill in cursus["skills"].arrayValue {
                if let name = skill["name"].string, let level = skill["level"].double {
                    self.skills.append((name, level))
                }
            }
            break
        }
    }
    
    func getProjects(cursusId: Int) {
        projects = []
        for project in projectsUsers {
            if project["cursus_ids"].arrayValue.map({$0.int}).contains(cursusId) {
                let info = project["project"]
                if info["parent_id"] != JSON.null { continue }
                
                let piscineId = info["id"].intValue
                let piscineDays = getPiscineDays(projectsArray: projectsUsers, cursusId: cursusId, piscineId: piscineId)
                
                if let dateString = project["marked_at"].string {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: dateString)
                    
                    let newProject = Project(
                        name: info["name"].stringValue,
                        id: piscineId,
                        finished: date,
                        grade: project["final_mark"].intValue,
                        validated: project["validated?"].boolValue,
                        retries: project["occurence"].intValue,
                        piscineDays: piscineDays.isEmpty ? nil : piscineDays
                    )
                    self.projects.append(newProject)
                }
            }
        }
    }
    
    fileprivate func getPiscineDays(projectsArray: [JSON], cursusId: Int, piscineId: Int) -> [Project] {
        var piscineDays: [Project] = []

        for subProject in projectsArray {
            if subProject["cursus_ids"].arrayValue.map({$0.int}).contains(cursusId) {
                let info = subProject["project"]
                if info["parent_id"].intValue == piscineId {
                    let dateString = subProject["marked_at"].stringValue
                    let dateFormatter = DateFormatter()
                    let date = dateFormatter.date(from: dateString)
                    
                    let newProject = Project(
                        name: info["name"].stringValue,
                        id: info["id"].intValue,
                        finished: date,
                        grade: subProject["final_mark"].intValue,
                        validated: subProject["validated?"].boolValue,
                        retries: subProject["occurence"].intValue,
                        piscineDays: nil
                    )
                    piscineDays.append(newProject)
                }
            }
        }
        return piscineDays
    }
}
