//
//  QueueStatus.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/18.
//

import Foundation

enum MatchingStatus {
    case normal, matching, matched
    
    var imageName: String {
        switch self {
        case .normal:
            return "searchDefault"
        case .matching:
            return "searchMatching"
        case .matched:
            return "searchMatched"
        }
    }
}
