//
//  HistoryCell.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/21/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
