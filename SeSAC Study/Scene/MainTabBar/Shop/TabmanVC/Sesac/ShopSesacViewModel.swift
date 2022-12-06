//
//  ShopSesacViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import Foundation
import StoreKit
import RxCocoa
import RxSwift

/*
 인앱 결제를 시작하게되면 paymentQueue updatedTransaction에서 default쪽이 무조건 실행된 뒤에, 앱 내에서 구입 창이 뜸. 여기서 구입을 눌러 구입이 완료가 되면 success쪽이 실행이됨. 그래서 그 안에 있는 receiptValidation이 실행되고 finishTransaction이 실행되면 removedTransaction이 실행됨. 취소를 누르거나 다른 화면을 눌러 구입을 취소하면 failed 구문으로 가게되어 removedTransaction이 실행될 수 밖에 업승ㅁ. 로딩바 숨겨주는걸 이 메서드 안에 추가하면 될듯. finishTransaction을 실행하더라도 이후 코드가 실행되므로 이후에 서버와 통신하면 될듯
 */

final class ShopSesacViewModel: NSObject {
    
    enum ShopSesacImage: String {
        case strong = "튼튼 새싹"
        case mint = "민트 새싹"
        case purple = "퍼플 새싹"
        case gold = "골드 새싹"
        
        var imageNumber: Int {
            switch self {
            case .strong:
                return 1
            case .mint:
                return 2
            case .purple:
                return 3
            case .gold:
                return 4
            }
        }
    }
    
    var products = BehaviorRelay<[SKProduct]>(value: [])
    var shopSesacData = BehaviorRelay<[ShopSesacData]>(value: [])
    var purchaseStatus = PublishRelay<ShopNetworkError.PurchaseShopItem>()
    
    private func fetchSesacImageName(name: String) -> String {
        guard let imageNumber = ShopSesacImage(rawValue: name)?.imageNumber else {
            print("새싹샵 새싹이미지 넘버 못가져옴")
            return "sesac_face_1"
        }
        guard let sesacImage = UserProfileImage(rawValue: imageNumber)?.image else {
            print("새싹샵 이미지 못가져옴")
            return "sesac_face_1"
        }
        return sesacImage
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
        let sesacCollection = userInfo.sesacCollection
        print(sesacCollection, "@@@@#@#@#@#")
        return sesacCollection.contains(item) ? true : false
    }
    
    func createShopSesacData(products: [SKProduct]) {
        var temp: [ShopSesacData] = [ShopSesacData(imageName: UserProfileImage.basic.image, title: UserProfileImage.basic.name, price: "보유", info: UserProfileImage.basic.info, alreadyPurchased: 0)]
        for i in products {
            let image = fetchSesacImageName(name: i.localizedTitle)
            temp.append(ShopSesacData(imageName: image, title: i.localizedTitle, price: "\(i.price)", info: i.localizedDescription, alreadyPurchased: 0))
        }
        LoadingIndicator.hideLoading()
        self.shopSesacData.accept(temp)
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
extension ShopSesacViewModel {
    
    func requestProductData() {
//        LoadingIndicator.showLoading()
        let sesacData: Set<String> = [IAPBundle.Sesac.strong.bundle, IAPBundle.Sesac.mint.bundle, IAPBundle.Sesac.purple.bundle, IAPBundle.Sesac.gold.bundle]
        if SKPaymentQueue.canMakePayments() {
            print("인앱결제가능")
            let request = SKProductsRequest(productIdentifiers: sesacData)
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

extension ShopSesacViewModel {
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        print(#function)
        // 앱에서 애플이 만들어놓은 링크로 영수증 정보를 보내고 애플에서 응답으로 문제없다는 것을 보내고 그때부터 유저디폴트 등으로 확인해서 인앱결제를 했다안했다 확인가능
        // 스테이터스가 0이 아니라 cancellation뭐시기가뜨면 환불한것
        //스테이터스가 21007인 경우엔 테스트용 영수증. 실제 결제가 일어나지 않은것
        
        // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        
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

extension ShopSesacViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(#function)
        
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

extension ShopSesacViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
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
        print(#function)
        LoadingIndicator.hideLoading()
        print("removedTransactions")
    }
}
