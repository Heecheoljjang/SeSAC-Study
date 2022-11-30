//
//  SocketIOManager.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/01.
//

import Foundation
import SocketIO

final class SocketIOManager {
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: SocketAPI.url)!, config: [
            
            .log(true)
            
        ])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("connect")
            guard let userData = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else {
                print("유저정보 못가져왔음 여기는 소켓")
                return
            }
            self?.socket.emit("changesocketid", userData.uid)
            
            /*
             [{
                 "_id" = 62038ce72cc3a112c6852227;
                 chat = "안녕하세요. 스쿠버 다이빙 좋아하시는 것 같아 연락드렸습니다";
                 createdAt = "2022-11-09T09:44:07.337Z";
                 from = dDoxlskSoMcZQdvoyEeqilRgSiM2;
                 to = 988TjxxzWkVcvxUfwfBNI7U0a322;
             }]
             */
            
            let data = data[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
             
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"),
                                            object: self,
                                            userInfo:
                                                [
                                                    "id": id,
                                                    "chat": chat,
                                                    "createdAt": createdAt,
                                                    "from": from,
                                                    "to": to
                                                ]
            )
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 종료", data, ack)
        }
        //이벤트 수신
        socket.on("sesac") { data, ack in
            print("이벤트 받음", data, ack)
        }
    }
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
