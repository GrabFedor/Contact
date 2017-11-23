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

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ServerDelegate {
  
  var messages = [Message]()
  
  let tableView : UITableView = {
    let t = UITableView()
    t.translatesAutoresizingMaskIntoConstraints = false
    return t
  }()
  
  let definitionTextField: UITextField = {
    let dtf = UITextField()
    dtf.translatesAutoresizingMaskIntoConstraints = false
    return dtf
  }()
  let wordTextField: UITextField = {
    let wtf = UITextField()
    wtf.translatesAutoresizingMaskIntoConstraints = false
    return wtf
  }()
  
  let sendButton: UIButton = {
    let btn: UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    btn.backgroundColor = UIColor.green
    btn.setTitle("Click Me", for: .normal)
    btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    btn.tag = 1
    return btn
  }()
  
  func buttonAction(sender: UIButton!) {
    let btnsendtag: UIButton = sender
    if btnsendtag.tag == 1 {
      let message = Message(definition: definitionTextField.text!, word: wordTextField.text!, user: "Fedya")
      Server.sendMessage(message: message)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    Server.commonFuncs = self
    Server.openConnection(firstMsg: "Fedya")
    setUpTableView()
    setUpDefinitionTextField()
    setUpWordTextField()
    setUpButton()
  }
  override func viewWillAppear(_ animated: Bool) {
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
  }
  
//  func keyboardWillShow(notification: NSNotification) {
//    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//      let keyboardHeight = keyboardSize.height
//      print(keyboardHeight)
//    }
//  }
  
  func setUpButton() {
    self.view.addSubview(sendButton)
    
  }
  
  func setUpDefinitionTextField() {
    self.view.addSubview(definitionTextField)
    definitionTextField.backgroundColor = UIColor.lightGray
    definitionTextField.placeholder = "Type a definition here"
    
    definitionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
    definitionTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10.0).isActive = true
    definitionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    definitionTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  func setUpWordTextField() {
    self.view.addSubview(wordTextField)
    wordTextField.backgroundColor = UIColor.lightGray
    wordTextField.placeholder = "type a word here"
    wordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
    wordTextField.topAnchor.constraint(equalTo: definitionTextField.bottomAnchor, constant: 10.0).isActive = true
    wordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    definitionTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

  }
  
  func setUpTableView() {
    self.view.addSubview(tableView)
    
    // constrain the table view to 120-pts on the top,
    //  32-pts on left, right and bottom (just to demonstrate size/position)
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32.0).isActive = true
    tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32.0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -230.0).isActive = true
    
    // set delegate and datasource
    tableView.delegate = self
    tableView.dataSource = self
    
    // register a defalut cell
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  // MARK: - Derver Delegate
  
  func newMessage(definition: String, word: String) {
    let message = Message(definition: definition, word: word, user: "Smone")
    self.messages.append(message)
    tableView.reloadData()
  }
  
  func word(word: String) {
    print(word)
  }
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = "\(self.messages[indexPath.row].definition)"
    
    return cell
  }
  
  // MARK: - Table view delegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // etc
  }
  
  
  /*
//
//  var server = Server()
//  var messages = [Message]()
//  var userName = ""
//  var gameIsOver = false
//  var isGameMaker = false
//  var gameIsStartedL = false
//  var wordIsAlreadySet = false
////  var tableView: UITableView!
//  var delegate: GameViewControllerDelegate!
  
  override func viewDidLoad() {
//    tableView.delegate = self
//    tableView.dataSource = self
//    delegate = self
//    Server.commonFuncs = self
    tableViewSettings()
  }
  
  let tableView = UIButton()
  
  func tableViewSettings() {
    tableView.setTitle("Button", for: .normal)
    tableView.setTitleColor(UIColor.black, for: .normal)
    tableView.backgroundColor = UIColor.white
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    let leftConstraint = NSLayoutConstraint(item: tableView, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0)
    let rightConstraint = NSLayoutConstraint(item: tableView, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: 0)
    let topConstraint = NSLayoutConstraint(item: tableView, attribute: .topMargin, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0)
//    let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
    tableView.addConstraints([leftConstraint, rightConstraint, topConstraint])
    
  }
  
//  func newMessage(definition: String, word: String) {
//    let message = Message(definition: definition, word: word, user: "smbd")
//    self.messages.append(message)
//  }
//  
//  func displayViewController(_ gameMaker: Bool) -> GameViewController? {
//    let viewControllerIdentifer = gameMaker ? "GameMakerVC" : "PlayerVC"
//    guard let gameVC = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifer) as? GameViewController else { return nil }
//    gameVC.isGameMaker = self.isGameMaker
//    gameVC.server = self.server
//    gameVC.userName = self.userName
//    return gameVC
//  }
//  
  /// Switchs View Controller
  
//  func nextVC() {
//    if let gameVC = displayViewController(self.isGameMaker) {
//      present(gameVC, animated: true, completion: nil)
//    }
//  }
//  
  */
  
}
