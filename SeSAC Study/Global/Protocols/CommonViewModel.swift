//
//  Protocol.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import Foundation

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
