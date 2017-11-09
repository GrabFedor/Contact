//
//  GameVC.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation
import UIKit

protocol GameViewControllerDelegate {
  func gameLoop(tableViewToUpdate tableView: UITableView, wordLabelToUpdate wordLabel: UILabel)
}

class GameViewController: UIViewController {
  
  var server = Server()
  var messages = [Message]()
  var userName = ""
  var gameIsOver = false
  var isGameMaker = false
  var gameIsStartedL = false
  var wordIsAlreadySet = false
  var delegate: GameViewControllerDelegate!
 
  
}
