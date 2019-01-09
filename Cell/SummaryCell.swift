//
//  SummaryCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/29.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//仕上げにimageにaspectRacioの制限を加えれば良い。
//aspectRacioの制限なしで全て青色なら大丈夫。

import UIKit

class SummaryCell: UITableViewCell {
    
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    
    @IBOutlet weak var clipButton: RoundedButton!
    @IBOutlet weak var clipButtonLabel: UILabel!
    
    @IBOutlet weak var ciImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
  
    
    @IBOutlet weak var articleImageView: UIImageView!
  
    
    @IBOutlet weak var browseButton: RoundedButton!
    
    
    @IBOutlet weak var sourceButton: UIButton!
    
    /*
    @IBAction func sourceButton(_ sender: Any) {
        
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController:ProfileViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let summaryViewController:SummaryViewController = MainStoryboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        summaryViewController.navigationController?.pushViewController(profileViewController, animated: false)
        print("ボタンが押されたよ")
        //これうまくいけば、ファイルを超えたメソッド呼び出しをマスターしたことになる。Qiitaに投降ものだな。
        //失敗。ただ、browseButtonを追っていけば、その秘密を突き止められそう。
    }*/
    
    
    func setSummaryCellInfo(articleData:ArticleData){
        browseButton.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
        titleLabel.text = articleData.titleStr
        sourceLabel.text = articleData.sourceName
        dateLabel.text = articleData.date
        //summaryLabel.text = articleData.summary
        //summaryLabel.setLineSpacing(lineSpacing: 2.0)
        
        let attributedString = NSMutableAttributedString(string: articleData.summary!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        summaryLabel.attributedText = attributedString
        
        guard let imageUrl = articleData.imageUrl else {return}
        articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImage"))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true //はみ出たところを切り取る=true,切り取らない=false
        
        let likeNumber = articleData.likes.count
        clipButtonLabel.text = "\(likeNumber)"
        print("\(likeNumber)")
        clipButtonLabel.textColor = .black
        //clipButtonLabel.text = articleData.clipSumNumber!.description//いけた
        selectionStyle = .none //ハイライトを消す
        backgroundColor = UIColor.clear
        
        if articleData.isLiked {
            clipButton.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
            clipButton.borderColor = .clear
            
            //let buttonImage = UIImage(named: "like_exist")
            //self.likeButton.setImage(buttonImage, for: UIControl.State.normal)
        } else {
            clipButton.backgroundColor = .clear
            //let buttonImage = UIImage(named: "like_none")
            //self.likeButton.setImage(buttonImage, for: UIControl.State.normal)
        }
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
