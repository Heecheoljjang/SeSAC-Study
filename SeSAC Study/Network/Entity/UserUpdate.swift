//
//  UserUpdate.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/22.
//

import Foundation

struct UserUpdate: Codable {
    let searchable, ageMin, ageMax, gender: Int
    let study: String
}
