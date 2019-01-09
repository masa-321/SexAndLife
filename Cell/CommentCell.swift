//
//  CommentCell.swift
//  
//
//  Created by 新真大 on 2018/10/31.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var CommentLabel: UILabel!
    
    func setCommentCellInfo() {
        CommentLabel.text = "現在コメントはありません"
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
