//
//  ContactCell.swift
//  Contact
//
//  Created by Apple on 26.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import UIKit

protocol ContactCellDelegate: class {
  
  func contactCellButtonSetup(firstWord: String)
  
}

class ContactCell: UITableViewCell {
  
  //MARK:- Properties
  private var definitionLabel: UILabel!
  private var contactCellButton: UIButton!
  
  weak var delegate: ContactCellDelegate?
  private var playerType: PlayerType?
  private var word: String?
  
  func configure(message: Message, playerType: PlayerType) {
    setUpDefinitionLabel()
    self.playerType = playerType
    self.word = message.word
    setUpButton()
    definitionLabel.text = message.definition
  }
  
  func buttonAction(sender: UIButton) {
    delegate?.contactCellButtonSetup(firstWord: self.word!)
  }
  //MARK:- Settings up
  func setUpButton() {
    
    contactCellButton = UIButton()
    contactCellButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contactCellButton)
    contactCellButton.titleLabel?.numberOfLines = 0
    contactCellButton.titleLabel?.adjustsFontSizeToFitWidth = true
    contactCellButton.titleLabel?.minimumScaleFactor = 0.5
    contactCellButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
    
    switch playerType {
    case .none:
      print("player type in contact cell is not defined")
    case .some(.player):
      contactCellButton.backgroundColor = UIColor.blue
      contactCellButton.setTitle("Contact", for: .normal)
    case .some(.gameMaker):
      contactCellButton.backgroundColor = UIColor.red
      contactCellButton.setTitle("Cancel", for: .normal)
    }
    
    //Cornstraints
    contactCellButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 5).isActive = true
    contactCellButton.leftAnchor.constraint(equalTo: definitionLabel.rightAnchor, constant: 5).isActive = true
    contactCellButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    contactCellButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
  }
  
  func setUpDefinitionLabel() {
    definitionLabel = UILabel()
    definitionLabel.translatesAutoresizingMaskIntoConstraints = false
    definitionLabel.numberOfLines = 0
    addSubview(definitionLabel)
    definitionLabel.backgroundColor = UIColor.gray
    definitionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    definitionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -45).isActive = true
    definitionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    definitionLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
