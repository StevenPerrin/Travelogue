//
//  EntryTableViewCell.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/6/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
