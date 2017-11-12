//
//  Server.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation
import SwiftWebSocket

protocol ServerDelegate {
  
  func newMessage(definition: String, word: String)
  
  func word(word:String)
  
}

protocol ServerDelegatePlayer {
  
}
protocol ServerDelegateGameMaker{
  
}

class Server {
  
  static private let ws = WebSocket("ws://80.93.182.190:5678")
  
  static var commonFuncs: ServerDelegate!
  var player: ServerDelegatePlayer!
  var gameMAker: ServerDelegateGameMaker!
  
  class func sendMessage(message: Message){
    let definition = message.definition
    let word = message.word
    ws.send("100\(definition)/\(word)")
  }
  class func openConnection(firstMsg message: String) {
    ws.event.open = {
      self.ws.send(message)
      print("opened")
      
    }
    ws.event.close = { code, reason, clean in
      print("closed")
      print(reason)
      self.ws.open()
    }
    ws.event.error = { error in
      print("error \(error)")
    }
    
    ws.event.message = { message in
      print("recv: \(message)")
      var code = ""
      var frame = ""
      let characters = (message as! String).characters
      var i = 0
      for char in characters {
        if i <= 3 {
          code += "\(char)"
        } else {
          frame += "\(char)"
        }
        
        i += 1
      }
      switch code{
        
      case "1001":
        var arr = frame.components(separatedBy: "/")
        let definition = arr[0]
        let word = arr[1]
        Server.commonFuncs.newMessage(definition: definition, word: word)
        
      case "2001":
        Server.commonFuncs.word(word: frame)
        
      default:
        break
      }
    }
    
  }
}




//  func requestForGameMakerName(userName: String) {
//
//  }
//  func requestForAMessage(numberOfMessages: Int) {
//    self.ws.send(numberOfMessages)
//  }
//
//  func sendWSMessage(message: String, userName: String, numberOfMessages: Int, roomId: String, isANewMessage: Bool) {
//
//    let param = [
//      "nm":isANewMessage,
//      "room_id": roomId,
//      "nom": numberOfMessages,
//      "message": message
//      ] as [String : Any]
//
//    print(param)
//    if JSONSerialization.isValidJSONObject(param) {
//      do {
//        let rawData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
//        print(rawData)
//        self.ws.send(rawData)
//      } catch {
//        print("smth is wrong")
//      }
//    }
//  }

//  func sendSimple(message: String) {
//    self.ws.send(message)
//  }







