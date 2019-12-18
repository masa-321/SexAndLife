//
//  TutorialViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/22.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
class TutorialViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            //dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
            let vc:TutorialViewController2 = storyboard!.instantiateViewController(withIdentifier: "Tutorial2") as! TutorialViewController2
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

class TutorialViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
            let vc:TutorialViewController3 = storyboard!.instantiateViewController(withIdentifier: "Tutorial3") as! TutorialViewController3
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

class TutorialViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
            let vc:TutorialViewController4 = storyboard!.instantiateViewController(withIdentifier: "Tutorial4") as! TutorialViewController4
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }

    
    /*
    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
        print("leftSwiped in TV2")
        dismiss(animated: true, completion: nil)
    }*/
}

class TutorialViewController4: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
            let vc:TutorialViewController5 = storyboard!.instantiateViewController(withIdentifier: "Tutorial5") as! TutorialViewController5
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
}

class TutorialViewController5: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
            let vc:TutorialViewController6 = storyboard!.instantiateViewController(withIdentifier: "Tutorial6") as! TutorialViewController6
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    

}

class TutorialViewController6: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            dismiss(animated: true, completion: nil)
        }
        else if sender.direction == .left {
            print("Left")
        }
    }
    

    
    @IBAction func start(_ sender: Any) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVc: UINavigationController = MainStoryboard.instantiateViewController(withIdentifier: "Initial") as! UINavigationController
        self.show(initialVc, sender: nil)
    }
    
    
}

