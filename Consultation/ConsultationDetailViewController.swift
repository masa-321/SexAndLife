//
//  ConsultationDetailViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/07.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class ConsultationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receiveConsultation:Consultation?
    var consultationBodyContents:[String:Any] = [:]
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
            //nibファイルを使って設定する場合は、こちらに記述が必要っぽい。
            let nib1 = UINib(nibName: "ConsultationDetailHeaderCell", bundle: nil)
            tableView.register(nib1, forCellReuseIdentifier: "ConsultationDetailHeaderCell")
            
            let nib2 = UINib(nibName: "ConsultationDetailBodyCell", bundle: nil)
            tableView.register(nib2, forCellReuseIdentifier: "ConsultationDetailBodyCell")
            
            let nib3 = UINib(nibName: "ConsultationDetailFooterCell", bundle: nil)
            tableView.register(nib3, forCellReuseIdentifier: "ConsultationDetailFooterCell")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationBarの設定
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "\(receiveConsultation!.consultationName)"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil //UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .black  //clear
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //consultationNameLabel.text = "\(receiveConsultation!.consultationName)" //消去
    }
    
    //sectionの数。今回はHeader,Body,Footerの３種類。
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

    
    //sectionの中のrowの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //Header
            return 1
        } else if section == 1 { //Body
            //情報が指定されていない項目は除いてCellを生成しなくてはいけない。そのための処理。
            consultationBodyContents = [:] //ダブりをなくすために初期化
            
            //sortをするために、keyの値は全て数字にしている。
            //どんなことをやっているのか（WhatConsultationDo:0）をconsultationBodyContentsに追加
            if receiveConsultation!.whatConsultationDo != "" {
                consultationBodyContents.updateValue(receiveConsultation!.whatConsultationDo, forKey:"0")
            }
            
            //料金(fee:1)をconsultationBodyContentsに追加
            if receiveConsultation!.fee != "" {
                consultationBodyContents.updateValue(receiveConsultation!.fee, forKey:"1")
            }
            
            //利用方法(howToConsult:2)をconsultationBodyContentsに追加
            if receiveConsultation!.howToConsult != "" {
                consultationBodyContents.updateValue(receiveConsultation!.howToConsult, forKey:"2")
            }
            
            //受付時間(receptionTime:3)をconsultationBodyContentsに追加
            if receiveConsultation!.receptionTime != "" {
                consultationBodyContents.updateValue(receiveConsultation!.receptionTime, forKey:"3")
            }
            
            //対象(targetPersons:4)をconsultationBodyContentsに追加
            if receiveConsultation!.targetPersons != [] {
                consultationBodyContents.updateValue(receiveConsultation!.targetPersons, forKey: "4")
            }
            
            //対象都道府県(targetPrefectures:5)をconsultationBodyContentsに追加
            if receiveConsultation!.targetPrefectures != [] {
                consultationBodyContents.updateValue(receiveConsultation!.targetPrefectures, forKey: "5")
            }
            
            /*
            //住所情報をconsultationBodyContentsに追加
            if receiveConsultation!.address != "" {
                consultationBodyContents.updateValue(receiveConsultation!.address, forKey: "address")
            }
            
            //連絡先をconsultationBodyContentsに追加
            if receiveConsultation!.address != "" {
                consultationBodyContents.updateValue(receiveConsultation!.address, forKey: "address")
            }*/
            
            
            return consultationBodyContents.count
        } else { //section == 2 //Footer
            return 1
        }
        
    }
    
    //rowの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //Header
            let cell:ConsultationDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ConsultationDetailHeaderCell", for:indexPath) as! ConsultationDetailHeaderCell
            cell.setCellInfo(consultation: receiveConsultation!)
            //cell.setCellInfo(receivedUserId: self.receivedUserId)
            return cell
            
        } else if indexPath.section == 1 { //Body
            let cell:ConsultationDetailBodyCell = tableView.dequeueReusableCell(withIdentifier: "ConsultationDetailBodyCell", for:indexPath) as! ConsultationDetailBodyCell
            
            //dictionaryは順番がバラバラ。よって順番を整えるためにsortする必要がある。sortしやすくするために、key値を数値にする。これらによって、辞書とソートの両立ができるようになる。
            var keysArray = Array(consultationBodyContents.keys)
            keysArray.sort(by: {$0 < $1})

            //空欄ではない情報だけピックアップし、そのKeyを順に取り出して送り込んでいる。
            //String(indexPath.row)とするのは悪手。5番目でkey値7というのがありうる。
            cell.setCellInfo(consultationBodyContents: consultationBodyContents, consultationBodyContentKey:keysArray[indexPath.row])
            return cell
            
        } else { //section == 2 //Footer
            let cell:ConsultationDetailFooterCell = tableView.dequeueReusableCell(withIdentifier: "ConsultationDetailFooterCell", for:indexPath) as! ConsultationDetailFooterCell
            cell.browseButton.addTarget(self, action: #selector(browseButton(sender:event:)), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    //rowをクリックした時の設定
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    
    //右上のシェアボタンの設定
    @IBAction func shareButton(_ sender: Any) {
        let shareString = "\(receiveConsultation!.consultationName)" + " | " + "#Sex&Life"
        var items = [] as [Any]
        if let shareUrl =  URL(string: receiveConsultation!.webSiteAddress) {
            items = [shareString, shareUrl] as [Any]
        } else {
            items = [shareString]
        }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height, width: 0, height: 0)
            //iPadではこれがないとクラッシュする。
        }
        
        let excludedActivityTypes: Array<UIActivity.ActivityType> = [
            //除外するもの
            // UIActivityType.addToReadingList,
            // UIActivityType.airDrop,
            // UIActivityType.assignToContact,
            // UIActivityType.copyToPasteboard,
            // UIActivityType.mail,
            // UIActivityType.message,
            // UIActivityType.openInIBooks,
            //UIActivity.ActivityType.postToFacebook,
            //UIActivity.ActivityType.postToFlickr,
            //UIActivity.ActivityType.postToTencentWeibo,
            //UIActivity.ActivityType.postToTwitter,
            // UIActivityType.postToVimeo,
            // UIActivityType.postToWeibo,
            // UIActivityType.print,
            // UIActivityType.saveToCameraRoll,
            // UIActivityType.markupAsPDF
        ]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
    }
    
    //browseButtonに紐つけられた,ブラウズするためのコード
    @objc func browseButton(sender:UIButton, event:UIEvent){
        guard let url = URL(string: receiveConsultation!.webSiteAddress) else {return}
        let title = receiveConsultation!.consultationName
        browse(URLRequest(url: url),titleStr: title)
    }
    
    func browse(_ request:URLRequest, titleStr:String) {
        let vc:BrowseConsultationViewController = self.storyboard?.instantiateViewController(withIdentifier: "BrowseConsultationViewController") as! BrowseConsultationViewController
        vc.browseURLRequest = request
        vc.browsePageTitle = titleStr
        //vc.receivedArticleData = receiveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
