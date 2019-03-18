//
//  ConsultationDetailHeaderCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/03/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseUI
import SDWebImage

class ConsultationDetailHeaderCell: UITableViewCell {

    let storage = Storage.storage()
    
    @IBOutlet weak var consultationImageView: UIImageView!{
        didSet {
            consultationImageView.isHidden = true
            
        }
    }
    @IBOutlet weak var consultationInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellInfo(consultation:Consultation){
        
        if consultation.imageURLString != "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg" {
            consultationImageView.isHidden = false
            consultationImageView.sd_setImage(with: storage.reference(forURL: consultation.imageURLString))
            consultationImageView.layer.cornerRadius = 6
        } else {
            consultationImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            consultationImageView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        consultationInfoLabel.text = consultation.consultationInfo.replacingOccurrences(of: "\\n", with: "\n")
        //.replacingOccurrences(of: "\\n", with: "\n")をつけて、firestoreの方で、改行のところに\nを加えるとうまく改行される。
    }
    
}
