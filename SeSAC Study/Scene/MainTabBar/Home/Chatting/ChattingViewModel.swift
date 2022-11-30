//
//  ChattingViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class ChattingViewModel {
    
    var totalChatData = BehaviorRelay<[ChatInfo]>(value: [])
    
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
        print("d유아이디 \(uid)")
        let api = SeSacAPI.chatTo(ohterUid: uid, chat: chat)
        APIService.shared.request(type: ChatInfo.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] data, statusCode in
            guard let status = SendChattingError(rawValue: statusCode), let data = data else {
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
            case .sendSuccess:
                //MARK: - 응답값 디비에 저장
                print("스테이터스샌드챗 \(status) 데이터 \(data)")
//                RealmManager.shared.saveChatToDB(chatInfo: data)
                self?.addToTotalChatData(chat: data)
                self?.sendChatStatus.accept(status)
            default:
                self?.sendChatStatus.accept(status)
            }
        }
    }
    
    //데이터베이스 업데이트 후 불러오기
    private func loadChat(uid: String) {
        print("로드챗")
        let chatData = RealmManager.shared.loadChatFromDB().filter { $0.from == uid || $0.to == uid }.sorted{ $0.createdAt < $1.createdAt }
        print("챗데이터 \(chatData)")
        totalChatData.accept(chatData)
        
        //MARK: 소켓연결
        SocketIOManager.shared.establishConnection()
    }
    
    //MARK: - Realm
    func fetchChat() {
        //상대방uid가져오기
        guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else {
            print("유아이디 못가져옴")
            return }
        //상대방 채팅 데이터 가져오기
        let chatData = RealmManager.shared.loadChatFromDB()
            .filter { $0.from == uid }
            .sorted { $0.createdAt < $1.createdAt }
        let lastDate = chatData.last?.createdAt ?? "2000-01-01T00:00:00.000Z"
        
        //from호출
        let api = SeSacAPI.chatFrom(ohterUid: uid, lastDate: lastDate)
        
        APIService.shared.request(type: FetchChat.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] data, statusCode in
            guard let status = FetchChattingError(rawValue: statusCode), let data = data else {
                print("채팅데이터 못가져옴")
                return
            }
            print("채팅가져오기 상태 \(status), \(statusCode)\n데이터 \(data)")
            data.payload.forEach {
                RealmManager.shared.saveChatToDB(chatInfo: $0)
                print("이거 뒤에 하하가 출력되어야해")
            }
            print("하하")
            self?.loadChat(uid: uid)
        }
    }
    
    func tableViewCellCount() -> Int {
        return totalChatData.value.count
    }
    
    func addToTotalChatData(chat: ChatInfo) {
        RealmManager.shared.saveChatToDB(chatInfo: chat)
        var temp = totalChatData.value
        temp.append(chat)
        totalChatData.accept(temp)
    }
    
    func closeSocketConnection() {
        SocketIOManager.shared.closeConnection()
    }
}
