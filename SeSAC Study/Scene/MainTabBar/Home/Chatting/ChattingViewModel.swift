//
//  ChattingViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel {

    var myQueueStatus = BehaviorRelay<MyQueueState>(value: MyQueueState(dodged: 0, matched: 0, reviewed: 0, matchedNick: nil, matchedUid: nil))
    var dodgeStatus = PublishRelay<StudyDodgeError>()
    var sendChatStatus = PublishRelay<SendChattingError>()
//    var chatData MARK: 추가해야함
    
    //MARK: - 채팅 상단 메뉴 화면 -> myqueuestate, 스터디 취소, 리뷰등록
    func cancelStudy() {
        guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else { return }
        print("uid \(uid)")
        let api = SeSacAPI.dodge(otherUid: uid)
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = StudyDodgeError(rawValue: statusCode) else {
                print("닷지에러")
                return }
            print("캔슬스터디 \(status)")
            self?.dodgeStatus.accept(status)
        }
    }
    //메뉴버튼 눌렀을때 호출
    func fetchMyQueueState() {
        print("queuestate 실행됨")
        let api = SeSacAPI.myQueueState

        APIService.shared.request(type: MyQueueState.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            print("queueState 상태코드 \(statusCode)")
            guard let error = QueueStateError(rawValue: statusCode) else {
                print("에러떠서 queuestate못가져옴")
                return }
            switch error {
            case .checkSuccess, .normalState:
                guard let data = data else {
                    print("Queuestate통신 데이터 못가져옴")
                    return }
                print("상태 통신 성공", data, error)
                self?.myQueueStatus.accept(data)
            default:
                print("노필요")
            }
        }
    }
    
    func checkMyQueueStatus() -> Bool {
        print("체크마이큐 \(myQueueStatus.value.matched)")
        return myQueueStatus.value.matched == 1 ? true : false
    }
    
    //MARK: - 채팅
    func sendChat(chat: String) {
        guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else {
            print("유아이디 못가져옴")
            return }
        let api = SeSacAPI.chatTo(ohterUid: uid, chat: chat)
        APIService.shared.request(type: SendChat.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] data, statusCode in
            guard let status = SendChattingError(rawValue: statusCode) else {
                print("스테이터스 가져오지 모담")
                return
            }
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        print("아이디토큰받아왔으므로 네트워크 통신하기: \(token)")
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.sendChatStatus.accept(.tokenError) //다시 눌러달라고 토스트띄우기. 재귀방지
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        self?.sendChatStatus.accept(.clientError)
                    }
                }
            default:
                self?.sendChatStatus.accept(status)
            }
        }
    }
}
