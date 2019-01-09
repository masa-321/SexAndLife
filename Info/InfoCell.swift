//
//  InfoCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/12.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit


class InfoCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextImageView: UIImageView!
    
    var viewModel: InfoCellViewModel? {
        didSet{
            guard let viewModel = viewModel else {return}
            iconImageView.image = viewModel.iconImage
            titleLabel.text = viewModel.titleText
            nextImageView.isHidden = viewModel.isNextImageHidden
        }
    }
    
}
