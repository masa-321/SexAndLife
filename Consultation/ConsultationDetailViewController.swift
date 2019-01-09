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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
