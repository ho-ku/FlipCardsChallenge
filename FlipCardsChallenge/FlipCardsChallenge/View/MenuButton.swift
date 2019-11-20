//
//  MenuButton.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/16/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
@IBDesignable
class MenuButton: UIButton {

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    func customizeView() {
        layer.borderWidth = 3.0
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

}
