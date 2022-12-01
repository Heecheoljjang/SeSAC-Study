//
//  RealmManager.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/30.
//
import RealmSwift
import Foundation

final class RealmManager {
    private init() {}
    
    static let shared = RealmManager()
    
    let localRealm = try! Realm()
    
//    func loadChatFromDB() -> [ChatInfo] {
//        let data = localRealm.objects(ChatData.self).map { $0 } //[ChatData
//        let decoder = JSONDecoder()
//        var temp: [ChatInfo] = []
//        data.forEach {
//            guard let chatData = $0.chatData, let decodedData = try? decoder.decode(ChatInfo.self, from: chatData) else {
//                print("채팅데이터 디코딩 실패")
//                return }
//            temp.append(decodedData)
//        }
//        print("채팅데이터다다ㅏ다 \(temp)")
//        return temp
//    }
    
    func loadChatFromDB() -> [ChatData] {
        return localRealm.objects(ChatData.self).map { $0 }
    }
    
//    func saveChatToDB(chatInfo: ChatInfo) {
//        //MARK: 인코딩하고 ChatData로 저장
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(chatInfo) {
//            print("인코딩데이터: \(encoded)")
//            let chatData = ChatData(chatData: encoded)
//            do {
//                try localRealm.write {
//                    localRealm.add(chatData)
//                }
//            } catch {
//                print("저장 실패")
//            }
//        }
//    }
    func saveChatToDB(chatData: ChatData) {
        do {
            try localRealm.write {
                localRealm.add(chatData)
            }
        } catch {
            print("저장 실패")
        }
    }
}
