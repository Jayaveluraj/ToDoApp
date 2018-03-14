//
//  CustomTableCell.swift
//  ToDoSample
//
//  Created by DHANDAPANI R on 08/03/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
