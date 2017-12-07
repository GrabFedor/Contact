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
  
  //MARK:- UI Objects Initialisations
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
    btn.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    btn.tag = 1
    return btn
  }()
  
  //MARK:- Setting up Views
  func setUpButton() {
    self.view.addSubview(sendButton)
    
  }
  
  func setUpDefinitionTextField() {
    self.view.addSubview(definitionTextField)
    definitionTextField.backgroundColor = UIColor.lightGray
    definitionTextField.placeholder = "Type a definition here"
    //Cornstarits
    definitionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
    definitionTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10.0).isActive = true
    definitionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    definitionTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  func setUpWordTextField() {
    self.view.addSubview(wordTextField)
    wordTextField.backgroundColor = UIColor.lightGray
    wordTextField.placeholder = "type a word here"
    //Cornstraits
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
    tableView.register(ContactCell.self, forCellReuseIdentifier: "cell")
  }
  
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
    let btnsendtag: UIButton = sender
    if btnsendtag.tag == 1 {
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
    let ac = UIAlertController(title: "", message: nil, preferredStyle: .alert)
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
    print(word)
  }
  
  func gameMakerDidSet() {
    switch self.playerType {
    case .gameMaker:
      self.setUpTableView()
    case .player:
      self.setUpTableView()
      self.setUpDefinitionTextField()
      self.setUpWordTextField()
      self.setUpButton()
      
    }
  }
  
  func contactJustHappened() {
//    buttonAlert(title: "Contact was right!", placeholder: nil, handler: nil)
    let ac = UIAlertController(title: "Nice one!", message: nil, preferredStyle: .alert)
    let aa = UIAlertAction(title: "Ok", style: .default, handler: nil)
    ac.addAction(aa)
    self.present(ac, animated: true, completion: nil)
  }
  
  func contactJustNotHappened() {
    buttonAlert(title: "Contact is not correct", placeholder: nil, handler: nil)
  }
  
  // MARK: - Table view data source
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
  
  // MARK: - Table view delegate
  
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



















