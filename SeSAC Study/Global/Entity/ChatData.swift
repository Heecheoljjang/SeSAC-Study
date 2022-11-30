//
//  ChatData.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/30.
//

import RealmSwift
import Foundation

final class ChatData: Object {
    @Persisted var chatData: Data?
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(chatData: Data?) {
        self.init()
        self.chatData = chatData
    }
}
