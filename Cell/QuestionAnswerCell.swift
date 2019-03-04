//
//  QuestionAnswerCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/06.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import SDWebImage

class QuestionAnswerCell: UITableViewCell {
    
    @IBOutlet weak var clipButton: RoundedButton!
    @IBOutlet weak var clipButtonLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!

    
    @IBOutlet weak var categoryImageView: UIImageView!{
        didSet {
            categoryImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!{
        didSet {
            categoryLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    
    var imageUrl: String = ""

    
    func setQuestionAnswerCellInfo(articleData:ArticleQueryData) {
        
        if articleData.isFAQ {
            //categoryImageView.backgroundColor = UIColor(red: 146/255, green: 208/255, blue: 80/255, alpha: 1)//rgb(146,208,80)
            categoryImageView.image = UIImage(named: "category-1")
            categoryImageView.isHidden = false
            categoryLabel.text = "FAQ"
            categoryLabel.isHidden = false
        } else if articleData.isSupervised {
            //categoryImageView.backgroundColor = UIColor(red: 0/255, green: 176/255, blue: 240/255, alpha: 1)//rgb(0,176,240)
            categoryImageView.image = UIImage(named: "category-2")
            categoryImageView.isHidden = false
            categoryLabel.text = "医師監修"
            categoryLabel.isHidden = false
        } else if articleData.isStory {
            //categoryImageView.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 1)//rgb(255,192,0)
            categoryImageView.image = UIImage(named: "category-3")
            categoryImageView.isHidden = false
            categoryLabel.text = "体験談"
            categoryLabel.isHidden = false
        } else {
            categoryImageView.isHidden = true
            categoryImageView.isHidden = true
            categoryLabel.isHidden = true
        }
        
        titleLabel.text = articleData.titleStr
        sourceLabel.text = articleData.sourceName
        guard let imageUrl = articleData.imageUrl else {return}
        articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImage"))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true //はみ出たところを切り取る
        
        let likeNumber = articleData.likes.count
        clipButtonLabel.text = "\(likeNumber)"
        //clipButtonLabel.text = articleData.clipSumNumber!.description//いけた
        
        let commentNumber = articleData.commenterIDs.count
        commentCountLabel.text = "\(commentNumber)"
        
        
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
    /*
    func setQuestionAnswerCellInfo2(articleData:ArticleQueryData) {
        
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
        
    }*/
    
}
