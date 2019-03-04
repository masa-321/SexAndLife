//
//  QuestionCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/02/21.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var likeButton: RoundedButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    let formatter = DateFormatter()
    
    func setQuestionCellInfo(questionData: QuestionData) {
        
        //Date型をString型に変換する準備
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        //postDataLabelをstoryboardと紐つけておかないとエラーになる。
        postDateLabel.text = formatter.string(from: questionData.questionTime! /*Date()*/)
        
        //TextViewの高さを可変にする処理。CommentTableViewCell.swiftに倣っている。
        textView.text = questionData.questionText
        
        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        var frame = self.textView.frame
        frame.size.height = contentSize.height
        self.textView.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.textView, attribute: .height, relatedBy: .equal, toItem: self.textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        self.textView.addConstraint(aspectRatioTextViewConstraint)

        //
        if let likeNumber =  questionData.likeSumNumber{
            self.likeNumberLabel.text = String(likeNumber)
        }
        
        
        
        if questionData.isLiked {
            likeImage.image = UIImage(named: "Heart2")
            //likeNumberLabel.font = .boldSystemFont(ofSize: 17.0)
        } else {
            likeImage.image = UIImage(named: "Heart")
            //likeNumberLabel.font = //boldを解除するコードを書きたいがわからない
        }
   
    }

}
