//
//  InitialTableViewCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/11/02.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitleLabel(string:String) {
        titleLabel.text = string
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
