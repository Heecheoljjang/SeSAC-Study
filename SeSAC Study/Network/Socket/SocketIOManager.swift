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
        manager = SocketManager(socketURL: URL(string: SeSacAPI.baseUrl)!, config: [
            
            .log(true),
            .forceWebsockets(true)
        ])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] dataArray, ack in
            print("connectasdfasdfsd")
            guard let userData = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else {
                print("유저정보 못가져왔음 여기는 소켓")
                return
            }
            self?.socket.emit("changesocketid", userData.uid)
        }
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 종료", data, ack)
        }
        //이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("이벤트 받음", dataArray, ack)
            let data = dataArray[0] as! NSDictionary
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
    }
    func establishConnection() {
        print("이스테")
        socket.connect()
    }
    
    func closeConnection() {
        print("클로즈")
        socket.disconnect()
    }
}
