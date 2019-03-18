//
//  ConsultationDetailBodyCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/03/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class ConsultationDetailBodyCell: UITableViewCell {

    @IBOutlet weak var contentTitleLabel: UILabel!
    
    @IBOutlet weak var contentDetailLabel: UILabel!
    
    //contentArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //consultationBodyContentKeyに応じてCellのステータスを変更している
    func setCellInfo(consultationBodyContents: [String:Any],consultationBodyContentKey:String){
        
        //どんなことをやっているのか（WhatConsultationDo）
        if consultationBodyContentKey == "0" {
            contentTitleLabel.text = "どんなことをやっているのか"
            contentDetailLabel.text = (consultationBodyContents["0"] as? String)!.replacingOccurrences(of: "\\n", with: "\n")
        }
        
        //料金(fee)
        if consultationBodyContentKey == "1" {
            contentTitleLabel.text = "料金"
            contentDetailLabel.text = (consultationBodyContents["1"] as? String)!.replacingOccurrences(of: "\\n", with: "\n")
        }
        
        //利用方法(howToConsult)
        if consultationBodyContentKey == "2" {
            contentTitleLabel.text = "利用方法"
            contentDetailLabel.text = (consultationBodyContents["2"] as? String)!.replacingOccurrences(of: "\\n", with: "\n")
        }
        
        //時間(receptionTime)
        if consultationBodyContentKey == "3" {
            contentTitleLabel.text = "時間"
            contentDetailLabel.text = (consultationBodyContents["3"] as? String)!.replacingOccurrences(of: "\\n", with: "\n")
        }
        
        //対象(targetPersons)
        if consultationBodyContentKey == "4" {
            print("contentTitleLabel.text：",contentTitleLabel.text)
            contentTitleLabel.text = "対象"
            let contentArray = consultationBodyContents["4"] as! [String]
            contentDetailLabel.text = contentArray.joined(separator: " ")
        }
        
        //対象都道府県(targetPrefectures)
        if consultationBodyContentKey == "5" {
            contentTitleLabel.text = "対象都道府県"
            
            let contentArray = consultationBodyContents["5"] as! [String]
            contentDetailLabel.text = contentArray.joined(separator: " ")
        }
    }
    
}
