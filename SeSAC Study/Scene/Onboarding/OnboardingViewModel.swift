//
//  OnboardingViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import RxCocoa
import RxSwift

final class OnboardingViewModel {

    let onboardingData = Observable.just([OnboardingData.first, OnboardingData.second, OnboardingData.third])
    
    func pageControlPage(xOffset: CGFloat, width: CGFloat) -> Int {
        return Int(xOffset / width)
    }
}
