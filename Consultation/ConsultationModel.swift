//
//  ConsultationModel.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import Foundation
import UIKit

class Consultation {
    var imageURLString: String
    //var imageName: String
    var consultationName: String
    
    init(imageURLString: String, consultationName: String) {
        self.imageURLString = imageURLString
        self.consultationName = consultationName
    }
}
