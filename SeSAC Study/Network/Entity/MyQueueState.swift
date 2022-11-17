//
//  MyQueueState.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/17.
//

import Foundation

struct MyQueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
