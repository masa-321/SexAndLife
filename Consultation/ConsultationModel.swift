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
    var address: String
    var consultationInfo: String
    var consultationName: String
    var consultationTools:[String] = []
    var consultationType: String
    var contactAddress: String
    var fee : String
    var howToConsult: String
    var imageURLString: String
    var operatingAgency: String
    var receptionTime:String
    var targetPersons:[String] = []
    var targetPrefectures:[String] = []
    var webSiteAddress: String
    var whatConsultationDo: String
    
    
    init (snapshot: QueryDocumentSnapshot ) {
        self.id = snapshot.documentID
        let valueDictionary = snapshot.data()
        
        //adress
        if let address = valueDictionary["Address"] as? String {
            self.address = address
        } else {
            self.address = ""
        }
        
        //consultationInfo
        if let consultationInfo = valueDictionary["ConsultationInfo"] as? String {
            self.consultationInfo = consultationInfo
        } else {
            self.consultationInfo = ""
        }
        
        //consultationName
        if let consultationName = valueDictionary["ConsultationName"] as? String {
            self.consultationName = consultationName
        } else {
            self.consultationName = ""
        }
        
        //consultationTools
        if let consultationTools = valueDictionary["ConsultationTools"] as? [String] {
            self.consultationTools = consultationTools
        }
        
        //consultationType
        if let consultationType = valueDictionary["ConsultationType"] as? String {
            self.consultationType = consultationType
        } else {
            self.consultationType = "typeF" //とりあえず。
        }
        
        //contactAddress
        if let contactAddress = valueDictionary["ContactAddress"] as? String {
            self.contactAddress = contactAddress
        } else {
            self.contactAddress = ""
        }
        
        //fee
        if let fee = valueDictionary["Fee"] as? String {
            self.fee = fee
        } else {
            self.fee = ""
        }
        
        //howToConsult
        if let howToConsult = valueDictionary["HowToConsult"] as? String {
            self.howToConsult = howToConsult
        } else {
            self.howToConsult = ""
        }
        
        //imageURLString
        if let imageURLString = valueDictionary["ImageURLString"] as? String {
            self.imageURLString = imageURLString
        } else {
            self.imageURLString = "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg"
        }
        
        //operatingAgency
        if let operatingAgency = valueDictionary["OperatingAgency"] as? String {
            self.operatingAgency = operatingAgency
        } else {
            self.operatingAgency = ""
        }
        
        //receptionTime
        if let receptionTime = valueDictionary["ReceptionTime"] as? String {
            self.receptionTime = receptionTime
        } else {
            self.receptionTime = ""
        }
        
        //targetPersons
        if let targetPersons = valueDictionary["TargetPersons"] as? [String] {
            self.targetPersons = targetPersons
        }
        
        //targetPrefectures
        if let targetPrefectures = valueDictionary["TargetPrefectures"] as? [String] {
            self.targetPrefectures = targetPrefectures
        }
        
        //webSiteAddress
        if let webSiteAddress = valueDictionary["WebSiteAddress"] as? String {
            self.webSiteAddress = webSiteAddress
        } else {
            self.webSiteAddress = ""
        }
        
        //whatConsultationDo
        if let whatConsultationDo = valueDictionary["WhatConsultationDo"] as? String {
            self.whatConsultationDo = whatConsultationDo
        } else {
            self.whatConsultationDo = ""
        }
        
    }

    /*
    init(imageURLString: String, consultationName: String) {
        self.imageURLString = imageURLString
        self.consultationName = consultationName
    }*/
}
