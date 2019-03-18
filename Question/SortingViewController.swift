//
//  SortingViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/03/07.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class SortingViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var sortingTypeAButton: UIButton!
    
    @IBAction func sortingTypeBButton(_ sender: Any) {
    }
    
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //View以外のところに触れればdismiss
    }
    
    @IBAction func sortingTypeA(_ sender: Any) {
        UserDefaults.standard.set("sortingTypeA", forKey: "sortingMode")
        /*let vc:QuestionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)*/
        
        /*let parentVC = presentingViewController as! QuestionViewController
        parentVC.fetchQuestions()
        parentVC.view.setNeedsDisplay()
        self.dismiss(animated: true, completion: nil)*/
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortingTypeB(_ sender: Any) {
        UserDefaults.standard.set("sortingTypeB", forKey: "sortingMode")
        /*let vc:QuestionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)*/
        
        /*let parentVC = presentingViewController as! QuestionViewController
        parentVC.fetchQuestions()
        parentVC.view.setNeedsDisplay()
        self.dismiss(animated: true, completion: nil)*/
        
        self.dismiss(animated: true, completion: nil)
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
