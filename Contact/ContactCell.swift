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
  public var definitionLabel: UILabel!
  public var contactCellButton: UIButton!
  
  public weak var delegate: ContactCellDelegate?
  public var playerType: PlayerType?
  private var indexRow: Int?
  
  //MARK:- Configuration
  func configure(message: Message, playerType: PlayerType, index: Int) {
    self.playerType = playerType
    self.indexRow = index
    setUpDefinitionLabel()
    contactCellButton = contentView.viewWithTag(111) as! UIButton!
    if message.isAbleToBeInteracted {
      setUpButton()
    } else {
      contactCellButton?.removeFromSuperview()
    }
    definitionLabel.text = message.definition
  }
  
  func buttonAction(sender: UIButton) {
    guard let index = self.indexRow else { print("IndexRow hadn't been found"); return }
    delegate?.contactCellButtonSetup(index: index)
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





