//
//  ConsultationDetailViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/07.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class ConsultationDetailViewController: UIViewController {
    
    var receiveConsultation:Consultation?
    
    @IBOutlet weak var consultationNameLabel: UILabel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        consultationNameLabel.text = "\(receiveConsultation!.consultationName)"
    }
    
    @IBAction func browse(_ sender: Any) {
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
}
