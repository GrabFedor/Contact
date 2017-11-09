//
//  Server.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation
import SwiftWebSocket

class Server {
  
  private let ws = WebSocket("ws://127.0.0.1:5678")
  
  func openConnection(firstMsg message: String) {
    ws.event.open = {
      self.ws.send(message)
      print("opened")
      
    }
    ws.event.close = { code, reason, clean in
      print("closed")
      self.ws.open()
    }
    ws.event.error = { error in
      print("error \(error)")
    }
    ws.event.message = { message in
      print("recv: \(message)")
    }
  }
  
  func requestForAMessage(numberOfMessages: Int) {
    self.ws.send(numberOfMessages)
  }
  
  func sendWSMessage(message: String, userName: String, numberOfMessages: Int, roomId: String, isANewMessage: Bool) {
    
    let param = [
      "nm":isANewMessage,
      "room_id": roomId,
      "nom": numberOfMessages,
      "message": message
      ] as [String : Any]
    
    print(param)
    if JSONSerialization.isValidJSONObject(param) {
      do {
        let rawData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        print(rawData)
        self.ws.send(rawData)
      } catch {
        print("smth is wrong")
      }
    }
  }
  
  func sendSimple(message: String) {
    self.ws.send(message)
  }
  
}
