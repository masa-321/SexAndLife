//
//  TutorialBaseViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/12/18.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit

class TutorialBaseViewController: UIViewController {


    @IBOutlet weak private var tutorialBaseTitleLabel: UILabel!
    
    @IBOutlet weak private var tutorialBaseImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTutorialBaseViewController()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    // MARK: - Navigatio
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setTutorialView(_ tutorial: Tutorial) {
        tutorialBaseTitleLabel.text = tutorial.title
        tutorialBaseImageView.image = tutorial.thumbnail
    }

    
    private func setupTutorialBaseViewController() {
        
        //背景に影をつける
        tutorialBaseImageView.layer.shadowRadius = 5
        tutorialBaseImageView.layer.shadowOpacity = 0.2
        tutorialBaseImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tutorialBaseImageView.layer.shadowColor = UIColor.black.cgColor
        tutorialBaseImageView.layer.masksToBounds = false
    }
}

