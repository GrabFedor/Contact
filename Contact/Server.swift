//
//  Server.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation
import SwiftWebSocket

//MARK:- Server Delegate protocol
protocol ServerDelegate: NSObjectProtocol {
  
  /// Propertie showing which type of a player is a current player
  var playerType: PlayerType { get set }
  
  /// This function is called when message has just been sent from a server
  /// - parameters:
  ///   - definition: definition of a word
  ///   - word: a word is being explained by player
  func newMessage(definition: String, word: String)
  
  /// This function is called when word is sent from a server
  /// - parameters:
  ///   - word: is a word from the server
  func word(word:String)
  
  /// This function is called after all the players connected to the server and game maker is set
  func gameMakerDidSet()
  
  /// Is called when client got a message that players made a contact
  /// - parameters:
  ///   - indexOfMessage: Index of contacted message (message's word for sure).
  func contactJustHappened(indexOfMessage: Int)
  
  func contactJustNotHappened()
  
  ///This function is called when someone has just canceled contact
  /// - parameters:
  ///   - indexOfCanceledMessage: index of a message which
  func contactHasHadCanceled(indexOfCanceledMessage: Int)
  
}


//MARK:- Server Class
class Server {
  
  static private let ws = WebSocket("ws://127.0.0.1:5678")
  
  static weak var delegate: ServerDelegate?
  static private var connectionIsOpened = false
  static private var roomId = ""
  
  //MARK:- Sending data to a server
  class func sendMessage(message: Message) {
    let definition = message.definition
    let word = message.word
    ws.send("100\(definition)/\(word)")
  }
  
  class func thinkOfAWord(word: String) {
    ws.send("200\(word)")
  }
  
  class func showCurrentWord() {
    ws.send("201frame")
  }
  
  class func tryToContact(estimatedWord: String, indexOfMessage: Int) {
    print("word is trying to be contacted is \(estimatedWord) and index is \(indexOfMessage)")
    ws.send("300\(estimatedWord)/\(indexOfMessage)")
    delay(withTime: 5.0, callback: checkWetherThereWasAContact)
  }
  
  class func cancelContact(estimatedWord: String, index: Int) {
    ws.send("302\(estimatedWord)/\(index)")
  }
  
  class func checkWetherThereWasAContact() {
    self.ws.send("301frame")
  }
  
  //MARK:- Recieving data from a server
  class func openConnection(firstMsg message: String) {
    ws.event.open = {
      if !connectionIsOpened {
        self.ws.send("000\(message)")
        connectionIsOpened = true
        print("opened")
      } else {
        self.ws.send("001\(message)/\(self.roomId)")
        print("reopened")
      }
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
      var decodedFrame = ""
      let characters = (message as! String).characters
      var i = 0
      for char in characters {
        if i <= 3 {
          code += "\(char)"
        } else {
          decodedFrame += "\(char)"
        }
        i += 1
      }
      
      switch code {
      case "0009":
        var arr = decodedFrame.components(separatedBy: "/")
        let iAmGameMaker = arr[0]
        self.roomId = arr[1]
        print(self.roomId)
        Server.delegate?.playerType = iAmGameMaker == "1" ? .gameMaker : .player
        Server.delegate?.gameMakerDidSet()
        
      case "1009":
        var arr = decodedFrame.components(separatedBy: "/")
        let definition = arr[0]
        let word = arr[1]
        Server.delegate?.newMessage(definition: definition, word: word)
        
      case "2009":
        Server.delegate?.word(word: decodedFrame)
        
      case "3029":
        var arr = decodedFrame.components(separatedBy: "/")
        let isCanceled = arr[0] == "1" ? true : false
        if isCanceled {
          delegate?.contactHasHadCanceled(indexOfCanceledMessage: Int(arr[1])!)
        }
        
      case "3019":
        if decodedFrame == "0" {
          Server.delegate?.contactJustNotHappened()
          print("Contact wasn't correct")
        } else {
          var arr = decodedFrame.components(separatedBy: "/")
          let indexOfMessageIsTryingToBeContacted = Int(arr[1])
          Server.delegate?.contactJustHappened(indexOfMessage: indexOfMessageIsTryingToBeContacted!)
          print("Contact just happened")
        }
        
      default:
        break
      }
    }
  }
}









