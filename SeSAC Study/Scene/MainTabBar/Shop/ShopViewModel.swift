//
//  ShopViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import Foundation
import RxCocoa
import RxSwift

final class ShopViewModel {
    
    var sesacImage = BehaviorRelay<Int>(value: 0)
    var backgroundImage = BehaviorRelay<Int>(value: 0)
    var updateStatus = PublishRelay<ShopNetworkError.UpdateShopItem>()
    
    func updateItem() {
        let api = SeSacAPI.shopUpdateItem(sesac: sesacImage.value, background: backgroundImage.value)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = ShopNetworkError.UpdateShopItem(rawValue: statusCode) else {
                print("상태 못가져옴. 상태코드는 \(statusCode)")
                self?.updateStatus.accept(.serverError)
                return
            }
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.updateItem()
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        self?.updateStatus.accept(.clientError)
                        return
                    }
                }
            default:
                self?.updateStatus.accept(status)
            }
        }
    }
    
    func setSesacImage(value: Int) {
        sesacImage.accept(value)
    }
    func setBackgroundImage(value: Int) {
        backgroundImage.accept(value)
    }
}
