//
//  ChatData.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/30.
//

import RealmSwift
import Foundation

final class ChatData: Object {
    @Persisted var id: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    @Persisted var from: String
    @Persisted var to: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String, chat: String, createdAt: String, from: String, to: String) {
        self.init()
        self.id = id
        self.chat = chat
        self.createdAt = createdAt
        self.from = from
        self.to = to
    }
}
