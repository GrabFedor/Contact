//
//  ContactCell.swift
//  Contact
//
//  Created by Apple on 26.11.17.
//  Copyright © 2017 DevelopGrab inc. All rights reserved.
//

import UIKit

//MARK: Contact Cell Delegate protocol
protocol ContactCellDelegate: class {
  
  func contactCellButtonSetup(index: Int)
  
}

//MARK: - Contact Cell Class
class ContactCell: UITableViewCell {
  
  //MARK:- Properties
  private var definitionLabel: UILabel!
  private var contactCellButton: UIButton!
  
  weak var delegate: ContactCellDelegate?
  private var playerType: PlayerType?
//  private var word: String?
  private var indexRow: Int?
  
  //MARK:- Configuration
  func configure(message: Message, playerType: PlayerType, index: Int) {
    self.playerType = playerType
//    self.word = message.word
    self.indexRow = index
    setUpDefinitionLabel()
    setUpButton()
    definitionLabel.text = message.definition
  }
  
  func buttonAction(sender: UIButton) {
    guard let index = self.indexRow else { print("IndexRow hadn't been found"); return }
//    guard let word = self.word else { print("Word in Contact Cell hadn't been found"); return }
    delegate?.contactCellButtonSetup(index: index)
  }
  
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
    
    //Cornstraints
    definitionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    definitionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -45).isActive = true
    definitionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    definitionLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
  }
  
  func removeButton() {
    contactCellButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
  }
  
  //MARK:- Overrides
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
