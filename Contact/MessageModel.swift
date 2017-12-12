//
//  MessageModel.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation

class Message {
  var definition: String
  var word: String
  var user: String
  var isAbleToBeInteracted: Bool
  
  init(definition: String, word: String, user: String) {
    self.definition = definition
    self.word = word
    self.user = user
    self.isAbleToBeInteracted = true
  }
}
