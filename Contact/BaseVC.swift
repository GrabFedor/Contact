//
//  ViewController.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate {
  func gameLoop(tableViewToUpdate tableView: UITableView, wordLabelToUpdate wordLabel: UILabel)
}

class ViewController: UIViewController {

  var server = Server()
  var messages = [Message]()
  var userName = ""
  var gameIsOver = false
  var isGameMaker = false
  var gameIsStarted = false
  var wordIsAlreadySet = false
  var delegate: GameViewControllerDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

