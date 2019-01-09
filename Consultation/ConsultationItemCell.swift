//
//  ConsultationItemCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseUI
import SDWebImage

class ConsultationItemCell : UICollectionViewCell {
    let storage = Storage.storage() //初期化
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var consultaionTitle: UILabel!
    
    
    @IBOutlet weak var detailButton: UIButton!
    
    var consultation: Consultation? {
        didSet {
            //thumbnail.image = UIImage(named: consultation!.imageName/*consultation!.imageName*/)
            thumbnail.sd_setImage(with: storage.reference(forURL: consultation!.imageURLString))
            thumbnail.layer.cornerRadius = 6
            
            consultaionTitle.text = consultation!.consultationName

        }
        
    }
}
