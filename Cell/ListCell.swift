//
//  ListCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/25.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import SDWebImage

class ListCell: UITableViewCell {
    
    
    @IBOutlet weak var clipButton: RoundedButton!
    @IBOutlet weak var clipButtonLabel: UILabel!
    @IBOutlet weak var ciImageView: UIImageView! //少し暗くする効果
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!

    var imageUrl: String = ""
    
    /*
    var viewModel: ArticleData? {
        didSet{
            setCellInfo()
        }
    }*/
    
    
    func setCellInfo(articleData:ArticleData) {

        titleLabel.text = articleData.titleStr
        sourceLabel.text = articleData.sourceName
        guard let imageUrl = articleData.imageUrl else {return}
        articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImage"))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true //はみ出たところを切り取る
        
        let likeNumber = articleData.likes.count
        clipButtonLabel.text = "\(likeNumber)"
        //clipButtonLabel.text = articleData.clipSumNumber!.description//いけた
        selectionStyle = .none //ハイライトを消す
        backgroundColor = UIColor.clear
        
        if articleData.isLiked { 
            clipButton.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
            clipButton.borderColor = .clear
            clipButtonLabel.textColor = .black
            //let buttonImage = UIImage(named: "like_exist")
            //self.likeButton.setImage(buttonImage, for: UIControl.State.normal)
        } else {
            clipButton.backgroundColor = .clear
            clipButton.borderColor = .white
            clipButtonLabel.textColor = .white
            //let buttonImage = UIImage(named: "like_none")
            //self.likeButton.setImage(buttonImage, for: UIControl.State.normal)
        }
    
    }
}
