//
//  SendChat.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/30.
//

import Foundation

struct ChatInfo: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
