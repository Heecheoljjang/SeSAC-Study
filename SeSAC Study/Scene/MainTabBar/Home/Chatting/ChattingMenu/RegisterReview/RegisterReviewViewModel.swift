//
//  RegisterReviewViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/02.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterReviewViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    
    enum ReviewButton {
        case good, time, fast, kind, expert, helpful
    }
    
    struct Input {
        let tapCancel: ControlEvent<Void>
        let buttonValue: BehaviorRelay<[ButtonStatus]>
        let keyboard: Driver<CGFloat>
        let tapGood: ControlEvent<Void>
        let tapTime: ControlEvent<Void>
        let tapFast: ControlEvent<Void>
        let tapKind: ControlEvent<Void>
        let tapExpert: ControlEvent<Void>
        let tapHelpful: ControlEvent<Void>
        let textViewText: ControlProperty<String>
        let textViewEmptyStatus: BehaviorRelay<EmptyStatus>
        let tapRegisterButton: ControlEvent<Void>
        let registerStatus: PublishRelay<RegisterError>
    }
    struct Output {
        let tapCancel: ControlEvent<Void>
        let buttonValue: Driver<[ButtonStatus]>
        let keyboard: Driver<CGFloat>
        let tapGood: Void
        let tapTime: Void
        let tapFast: Void
        let tapKind: Void
        let tapExpert: Void
        let tapHelpful: Void
        let textViewIsEmpty: Void
        let textViewCount: Observable<Bool>
        let textViewEmptyStatus: Driver<EmptyStatus>
        let tapRegisterButton: ControlEvent<Void>
        let registerStatus: Driver<RegisterError>
    }
    func transform(input: Input) -> Output {
        
        let buttonValue = input.buttonValue.asDriver(onErrorJustReturn: [])
        
        let tapGood: Void = input.tapGood.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .good)
        })
        .disposed(by: disposeBag)
        let tapTime: Void = input.tapTime.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .time)
        })
        .disposed(by: disposeBag)
        let tapFast: Void = input.tapFast.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .fast)
        })
        .disposed(by: disposeBag)
        let tapKind: Void = input.tapKind.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .kind)
        })
        .disposed(by: disposeBag)
        let tapExpert: Void = input.tapExpert.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .expert)
        })
        .disposed(by: disposeBag)
        let tapHelpful: Void = input.tapHelpful.bind(onNext: { [weak self] _ in
            self?.tapButton(type: .helpful)
        })
        .disposed(by: disposeBag)
        
        let textViewIsEmpty: Void = input.textViewText.map { $0.count < 1 }.bind(onNext: { [weak self] value in
            self?.checkTextCount(isEmpty: value)
        })
        .disposed(by: disposeBag)
        
        let textViewCount = input.textViewText.map { $0.count > 500 }
        
        let textViewEmptyStatus = input.textViewEmptyStatus.asDriver(onErrorJustReturn: .empty)
        
        let registerStatus = input.registerStatus.asDriver(onErrorJustReturn: .clientError)
        
        return Output(tapCancel: input.tapCancel, buttonValue: buttonValue, keyboard: input.keyboard, tapGood: tapGood, tapTime: tapTime, tapFast: tapFast, tapKind: tapKind, tapExpert: tapExpert, tapHelpful: tapHelpful, textViewIsEmpty: textViewIsEmpty, textViewCount: textViewCount, textViewEmptyStatus: textViewEmptyStatus, tapRegisterButton: input.tapRegisterButton, registerStatus: registerStatus)
    }
    
    var buttonValue = BehaviorRelay<[ButtonStatus]>(value: Array(repeating: .disable, count: 9))
    var textViewIsEmpty = BehaviorRelay<EmptyStatus>(value: .empty)
    var registerStatus = PublishRelay<RegisterError>()
    
    func fetchMatchedNick() -> String {
        guard let nick = UserDefaultsManager.shared.fetchValue(type: .otherNick) as? String else { return "" }
        return nick
    }
    
    //MARK: - 버튼 탭
    private func fetchButtonValue() -> [ButtonStatus] {
        return buttonValue.value
    }
    
    func tapButton(type: ReviewButton) {
        var temp = fetchButtonValue()
        switch type {
        case .good:
            temp[0] = temp[0] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        case .time:
            temp[1] = temp[1] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        case .fast:
            temp[2] = temp[2] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        case .kind:
            temp[3] = temp[3] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        case .expert:
            temp[4] = temp[4] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        case .helpful:
            temp[5] = temp[5] == .disable ? .enable : .disable
            buttonValue.accept(temp)
        }
    }
    
    //MARK: - 텍스트뷰
    func checkTextCount(isEmpty: Bool) {
        isEmpty ? textViewIsEmpty.accept(.empty) : textViewIsEmpty.accept(.notEmpty)
    }
    
    //MARK: - 서버통신
    
    //reputation 구하기
    private func transitionToIntArray(review: [ButtonStatus]) -> [Int] {
        var temp: [Int] = []
        for i in 0..<review.count {
            temp.append(review[i] == .enable ? 1 : 0)
        }
        return temp
    }
    
    func checkReputationAllZero() -> Bool {
        let temp = transitionToIntArray(review: buttonValue.value)
        return temp.filter { $0 == 1 }.count == 0 ? true : false
    }
    
    //uid 구하기
    private func fetchOtherUid() -> String {
        return UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String ?? ""
    }
    
    //네트워킹
    func registerReview(comment: String) {
        let reputation = transitionToIntArray(review: buttonValue.value)
        let uid = fetchOtherUid()
        
        print(reputation, uid, comment)
        let api = SeSacAPI.rate(otherUid: uid, reputation: reputation, comment: comment)
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = RegisterError(rawValue: statusCode) else {
                print("리뷰 등록 실패했음")
                return
            }
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.registerStatus.accept(.tokenError) //다시 눌러달라고 토스트띄우기. 재귀방지
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        self?.registerStatus.accept(.clientError)
                    }
                }
            default:
                self?.registerStatus.accept(status)
            }
        }
    }
}
