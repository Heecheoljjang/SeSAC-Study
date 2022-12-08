//
//  ShopBackgroundViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import Foundation
import StoreKit
import RxCocoa
import RxSwift

final class ShopBackgroundViewModel: NSObject {
    
    enum ShopBackgroundImage: String {
        case city = "씨티 뷰"
        case nightWalk = "밤의 산책로"
        case dayWalk = "낮의 산책로"
        case stage = "연극 무대"
        case latin = "라틴 거실"
        case training = "홈트방"
        case musician = "뮤지션 작업실"
        
        var imageNumber: Int {
            switch self {
            case .city:
                return 1
            case .nightWalk:
                return 2
            case .dayWalk:
                return 3
            case .stage:
                return 4
            case .latin:
                return 5
            case .training:
                return 6
            case .musician:
                return 7
            }
        }
    }
    
    var products = BehaviorRelay<[SKProduct]>(value: [])
    var shopBackgroundData = BehaviorRelay<[ShopBackgroundData]>(value: [])
    var purchaseStatus = PublishRelay<ShopNetworkError.PurchaseShopItem>()
    
    private func fetchBackgroundImageName(name: String) -> String {
        guard let imageNumber = ShopBackgroundImage(rawValue: name)?.imageNumber else {
            print("새싹샵 새싹이미지 넘버 못가져옴")
            return "sesac_background_1"
        }
        guard let backgroundImage = BackgroundImage(rawValue: imageNumber)?.imageName else {
            print("새싹샵 이미지 못가져옴")
            return "sesac_background_1"
        }
        return backgroundImage
    }
    
    func fetchPurchaseInfo() {
        LoadingIndicator.showLoading()

        let api = SeSacAPI.shopMyInfo
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] data, statusCode in
            guard let status = LoginError(rawValue: statusCode) else {
                print("상태코드 못가져옴")
                return
            }
            switch status {
            case .signUpSuccess:
                guard let data = data else {
                    print("데이터 못가져왔어용")
                    return
                }
                //데이터에 보유 상태 추가
                UserDefaultsManager.shared.setValue(value: data, type: .userInfo)
                self?.requestProductData()
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.fetchPurchaseInfo()
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        return
                    }
                }
            default:
                LoadingIndicator.hideLoading()
                print("유저인퓨ㅗ")
            }
        }
    }
    
    func checkPurchase(item: Int) -> Bool {
        guard let userInfo = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else { return false }
        let backgroundCollection = userInfo.backgroundCollection
        print(backgroundCollection, "@@@@#@#@#@#")
        return backgroundCollection.contains(item) ? true : false
    }
    
    func createShopBackgroundData(products: [SKProduct]) {
        var temp: [ShopBackgroundData] = [ShopBackgroundData(imageName: BackgroundImage.first.imageName, title: BackgroundImage.first.name, price: "보유", info: BackgroundImage.first.info)]
        for i in products {
            let image = fetchBackgroundImageName(name: i.localizedTitle)
            temp.append(ShopBackgroundData(imageName: image, title: i.localizedTitle, price: "\(i.price)", info: i.localizedDescription))
        }
        LoadingIndicator.hideLoading()
        self.shopBackgroundData.accept(temp)
    }
    
    private func purchaseSuccess(receipt: String, identifier: String) {
        let api = SeSacAPI.shopPurchaseItem(receipt: receipt, product: identifier)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = ShopNetworkError.PurchaseShopItem(rawValue: statusCode) else {
                print("퍼체이스아이템 상태 못가져옴 \(statusCode)")
                return
            }
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.purchaseSuccess(receipt: receipt, identifier: identifier)
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        self?.purchaseStatus.accept(.clientError)
                        return
                    }
                }
            default:
                self?.purchaseStatus.accept(status)
            }
        }
    }
}

//MARK: - 인앱
extension ShopBackgroundViewModel {
    func requestProductData() {
        let backgroundData: Set<String> = [IAPBundle.Background.city.bundle, IAPBundle.Background.nightWalk.bundle, IAPBundle.Background.dayWalk.bundle, IAPBundle.Background.stage.bundle, IAPBundle.Background.latin.bundle, IAPBundle.Background.training.bundle, IAPBundle.Background.musician.bundle]
        if SKPaymentQueue.canMakePayments() {
            print("인앱결제가능")
            let request = SKProductsRequest(productIdentifiers: backgroundData)
            request.delegate = self
            request.start()
        } else {
            print("인앱결제 불가능")
            LoadingIndicator.hideLoading()
        }
    }
    
    func tapPriceButton(index: Int) {
        LoadingIndicator.showLoading()
        let product = products.value[index - 1]
        print("프로덕트 \(product.localizedTitle)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
}

extension ShopBackgroundViewModel {
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {

        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            print("영수증 데이터 못가져옴")
            return
        }
        
        print(receiptString)
        
        purchaseSuccess(receipt: receiptString, identifier: productIdentifier)
        
        //거래 내역(transaction)을 큐에서 제거 => 결제가 중복으로 들어가거나 쌓일 수 있어서
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
}

extension ShopBackgroundViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            for i in products {
                print(i.localizedTitle, i.price, i.localizedDescription)
            }
            self.products.accept(products)
        } else {
            LoadingIndicator.hideLoading()
            print("No Product Found") //계약에 대한 업데이트가 안됐을때, 유료에 대한 계약을 하지 않았을때,인앱에 대한 항목들을 등록하지않았을 때 등 프린트문 찍힘
        }
    }
    
}

extension ShopBackgroundViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased: //구매 승인 이후에 영수증 검증
                
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier) //따로 만든 메서드
                
            case .failed: //실패 토스트, transaction
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("dkdkd")
                break
            }
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        LoadingIndicator.hideLoading()
        print("removedTransactions")
    }
}
