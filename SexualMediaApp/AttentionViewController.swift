//
//  AttentionViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/11/02.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit

class AttentionViewController: UIViewController {
    
    
    @IBOutlet weak var upperView: UIView!{
        didSet {
            upperView.layer.cornerRadius = 15.0
            upperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            upperView.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
        }
    }
    
    @IBOutlet weak var attentionLabel: UILabel!
    
    @IBOutlet weak var attentionView: UIView!{
        didSet {
            attentionView.layer.cornerRadius = 15.0
        }
    }
    
    @IBOutlet weak var lowerView: UIView!{
        didSet {
            lowerView.layer.cornerRadius = 15.0
            lowerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    
    @IBAction func okButton(_ sender: Any) {
        
        let startVc: ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        show(startVc, sender: nil)
        
       // self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
