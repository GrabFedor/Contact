//
//  GameVC.swift
//  Contact
//
//  Created by Apple on 09.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import Foundation
import UIKit


//MARK:- Player Type
enum PlayerType {
  case player
  
  case gameMaker
}

//MARK:- Game View Controller Class
class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ServerDelegate, ContactCellDelegate {
  
  //MARK:- Properties
  private var messages = [Message]()
  private var name = ""
  var playerType: PlayerType = .player
  
  //MARK:- UI Objects
  public var tableView : UITableView!
  public var definitionTextField: UITextField!
  public var wordTextField: UITextField!
  public var sendButton: UIButton!
  public var wordLabel: UILabel!
  
  //MARK:- View Cotnroller Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    Server.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startGame()
  }
  
  func sendButtonAction(sender: UIButton!) {
    let btnSendTag: UIButton = sender
    if btnSendTag.tag == 1 {
      let message = Message(definition: definitionTextField.text!, word: wordTextField.text!, user: self.name)
      Server.sendMessage(message: message)
    }
  }
  
  func startGame() {
    let alertController = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "Type your nickname here..."
    }
    let alertAction = UIAlertAction(title: "Ok", style: .default) { aa in
      self.name = (alertController.textFields?[0].text)!
      Server.openConnection(firstMsg: self.name)
    }
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - Contact Cell Delegate
  func contactCellButtonSetup(index: Int) {
    switch playerType {
    case .gameMaker:
      gameMakerContactCellButtonTarget(index: index)
    case .player:
      playerContactCellButtonTarget(index: index)
    }
  }
  
  func buttonAlert(title: String, placeholder: String?, handler: ((_:String) -> Void)?) {
    let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    if let placeholder = placeholder {
      ac.addTextField { tt in
        tt.placeholder = placeholder
      }
    }
    let aa = UIAlertAction(title: "Ok", style: .default) { aa in
      if let textFieldText = ac.textFields?[0].text {
        if let compl = handler {
          compl(textFieldText)
        }
      }
    }
    ac.addAction(aa)
    present(ac, animated: true, completion: nil)
  }
  
  func gameMakerContactCellButtonTarget(index: Int) {
    buttonAlert(title: "Cancel Contact", placeholder: "type a word here") { word in
      Server.cancelContact(estimatedWord: word, index: index)
    }
  }
  
  func playerContactCellButtonTarget(index: Int) {
    buttonAlert(title: "Contact!", placeholder: "type a word here") { word in
      Server.tryToContact(estimatedWord: word, indexOfMessage: index)
    }
  }
  
  // MARK: - Server Delegate
  
  func newMessage(definition: String, word: String) {
    let message = Message(definition: definition, word: word, user: self.name)
    self.messages.append(message)
    tableView.reloadData()
  }
  
  func word(word: String) {
    wordLabel.text = word
  }
  
  func gameMakerDidSet() {
    switch self.playerType {
    case .gameMaker:
      setUpGameMakerView()
    case .player:
      setUpPlayerView()
    }
  }
  
  func contactJustHappened(indexOfMessage: Int) {
    messages[indexOfMessage].isAbleToBeInteracted = false
    tableView.reloadData()
    Server.showCurrentWord()
  }
  
  func contactJustNotHappened() {
    buttonAlert(title: "Contact is not correct", placeholder: nil, handler: nil)
  }
  
  func contactHasHadCanceled(indexOfCanceledMessage: Int) {
    print("Game Maker has canceled the word \(messages[indexOfCanceledMessage].word)")
    messages[indexOfCanceledMessage].isAbleToBeInteracted = false
    let indexPath = IndexPath(row: indexOfCanceledMessage, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  // MARK: - Table view Delegate
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
    cell.delegate = self
    cell.configure(message: self.messages[indexPath.row], playerType: self.playerType, index: indexPath.row)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
}

func delay (withTime time: Double, callback: @escaping () -> Void) {
  let when = DispatchTime.now() + time
  DispatchQueue.main.asyncAfter(deadline: when) {
    callback()
  }
}



















