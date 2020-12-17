//
//  IRCServerInputParser.swift
//  BlackHelper
//
//  Created by 주 on 2020/12/17.
//

import Foundation

struct IRCServerInputParser {
    static func parseServerMessage(_ message: String) -> IRCServerInput {
        if message.hasPrefix("PING") {
            return .ping
        }
        
        if message.hasPrefix(":") {
            let firstSpaceIndex = message.firstIndex(of: " ")!
            let source = message[..<firstSpaceIndex]
            let rest = message[firstSpaceIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
            print(source)
            
            if rest.hasPrefix("PRIVMSG") {
                let remaining = rest[rest.index(message.startIndex, offsetBy: 8)...]
                
                if remaining.hasPrefix("#") {
                    let split = remaining.components(separatedBy: ":")
                    let channel = split[0].trimmingCharacters(in: CharacterSet(charactersIn: " #"))
                    let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                    let message = split[1]
                    
                    return .channelMessage(channel: channel, user: user, message: message)
                }
            } else if rest.hasPrefix("JOIN") {
                let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                let channel = rest[rest.index(message.startIndex, offsetBy: 5)...].trimmingCharacters(in: CharacterSet(charactersIn: "# "))
                return .joinMessage(user: user, channel: channel)
            } else{
                let server = source.trimmingCharacters(in: CharacterSet(charactersIn: ": "))
                
                // :development.irc.roundwallsoftware.com 353 mukman = #clearlyafakechannel :mukman @sgoodwin\r\n:development.irc.roundwallsoftware.com 366 mukman #clearlyafakechannel :End of /NAMES list.
                
                if rest.hasSuffix(":End of /NAMES list.") {
                    let scanner = Scanner(string: rest)
                    scanner.scanUpTo("#", into: nil)
                    
                    var channel: NSString?
                    
                    scanner.scanUpTo(" ", into: &channel)
                    
                    let channelName = (channel as String?)!.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
                    
                    var users = [String]()
                    var user: NSString?
                    scanner.scanUpTo(" ", into: &user)
                    users.append((user as String?)!.trimmingCharacters(in: CharacterSet(charactersIn: ":")))
                    
                    return .userList(channel: channelName, users: users)
                }
                
                if rest.contains(":") {
                    let serverMessage = rest.components(separatedBy: ":")[1]
                    return .serverMessage(server: server, message: serverMessage)
                } else {
                    return .serverMessage(server: server, message: rest)
                }
            }
        }
        
        return .unknown(raw: message)
    }
}

enum IRCServerInput: Equatable {
    case unknown(raw: String)
    case ping
    case serverMessage(server: String, message: String)
    case channelMessage(channel: String, user: String, message: String)
    case joinMessage(user: String, channel: String)
    case userList(channel: String, users: [String])
}

func ==(lhs: IRCServerInput, rhs: IRCServerInput) -> Bool{
    switch (lhs, rhs) {
    case (.ping, .ping):
        return true
    case (.channelMessage(let lhsChannel, let lhsUser, let lhsMessage),
          .channelMessage(let rhsChannel, let rhsUser, let rhsMessage)):
        return lhsChannel == rhsChannel && lhsMessage == rhsMessage && lhsUser == rhsUser
    case (.serverMessage(let lhsServer, let lhsMessage),
          .serverMessage(let rhsServer, let rhsMessage)):
        return lhsServer == rhsServer && lhsMessage == rhsMessage
    case (.joinMessage(let lhsUser, let lhsChannel), .joinMessage(let rhsUser, let rhsChannel)):
        return lhsUser == rhsUser && lhsChannel == rhsChannel
    case (.userList(let lhsChannel, let lhsUsers), .userList(let rhsChannel, let rhsUsers)):
        return lhsChannel == rhsChannel && lhsUsers == rhsUsers
    default:
        return false
    }
}
