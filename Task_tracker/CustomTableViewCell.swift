//
//  CustomTableViewCell.swift
//  Task_tracker
//
//  Created by Иван Базаров on 23.07.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let instance = CustomTableViewCell()
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var CommentaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
