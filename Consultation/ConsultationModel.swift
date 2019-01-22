//
//  ConsultationModel.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit

class Consultation {
    var id:String?
    var consultationName: String
    var imageURLString: String
    var consultationType: String
    var consultationInfo: String
    
    var contactAddress: String
    var address: String
    var howToConsult: String
    var receptionTime:String
    var webSiteAddress: String
    
    var targetPersons:[String] = []
    var targetPrefectures:[String] = []
    
    
    init (snapshot: QueryDocumentSnapshot ) {
        self.id = snapshot.documentID
        let valueDictionary = snapshot.data()
        
        if let consultationName = valueDictionary["CconsultationName"] as? String {
            self.consultationName = consultationName
        } else {
            self.consultationName = ""
        }
        
        if let imageURLString = valueDictionary["ImageURLString"] as? String {
            self.imageURLString = imageURLString
        } else {
            self.imageURLString = "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg"
        }
        
        if let consultationType = valueDictionary["ConsultationType"] as? String {
            self.consultationType = consultationType
        } else {
            self.consultationType = "typeF" //とりあえず。
        }
        
        if let consultationInfo = valueDictionary["ConsultationInfo"] as? String {
            self.consultationInfo = consultationInfo
        } else {
            self.consultationInfo = ""
        }
        
        if let contactAddress = valueDictionary["ContactAddress"] as? String {
            self.contactAddress = contactAddress
        } else {
            self.contactAddress = ""
        }
        
        if let address = valueDictionary["Address"] as? String {
            self.address = address
        } else {
            self.address = ""
        }
        
        if let howToConsult = valueDictionary["HowToConsult"] as? String {
            self.howToConsult = howToConsult
        } else {
            self.howToConsult = ""
        }
        
        if let receptionTime = valueDictionary["ReceptionTime"] as? String {
            self.receptionTime = receptionTime
        } else {
            self.receptionTime = ""
        }
        
        if let webSiteAddress = valueDictionary["WebSiteAddress"] as? String {
            self.webSiteAddress = webSiteAddress
        } else {
            self.webSiteAddress = ""
        }
        
        if let targetPersons = valueDictionary["TargetPersons"] as? [String] {
            self.targetPersons = targetPersons
        }
        
        if let targetPrefectures = valueDictionary["TargetPrefectures"] as? [String] {
            self.targetPrefectures = targetPrefectures
        }
        
    }

    /*
    init(imageURLString: String, consultationName: String) {
        self.imageURLString = imageURLString
        self.consultationName = consultationName
    }*/
}
