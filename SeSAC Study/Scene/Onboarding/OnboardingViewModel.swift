//
//  OnboardingViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseMessaging

final class OnboardingViewModel: CommonViewModel {

    struct Input {
        let offset: ControlProperty<CGPoint>
        let tapStartButton: ControlEvent<Void>
    }
    struct Output {
        let items: Observable<[OnboardingData]>
        let pageCount: Observable<[OnboardingData]>
        let xOffset: Observable<CGFloat>
        let tapStartButton: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        let xOffset = input.offset.map { $0.x }
        
        return Output(items: onboardingData, pageCount: onboardingData, xOffset: xOffset, tapStartButton: input.tapStartButton)
    }
    
    let onboardingData = Observable.just([OnboardingData.first, OnboardingData.second, OnboardingData.third])
    
    func pageControlPage(xOffset: CGFloat, width: CGFloat) -> Int {
        return Int(xOffset / width)
    }
    
    func fetchFCMToken() {
        guard let token = UserDefaultsManager.shared.fetchValue(type: .fcmToken) as? String else { return }
        if !token.isEmpty {
            return
        }
        print("토큰이 비어있어요!!!!")
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaultsManager.shared.setValue(value: token, type: .fcmToken)
            }
        }
    }
}
