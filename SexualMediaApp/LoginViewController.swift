//
//  LoginViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/28.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class LoginViewController: UIViewController {
    
    var sex = ["男性","女性","その他"]
    var age = ["19歳以下", "20~24歳", "25~29歳", "30~39歳", "40~49歳", "50歳以上"]
    var userSex = ""
    var userAge = ""

    
    @IBOutlet weak var basementView: UIView!{
        didSet {
            basementView.layer.cornerRadius = 15.0
        }
    }
    @IBOutlet weak var upperView: UIView!{
        didSet {
            upperView.layer.cornerRadius = 15.0
            upperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            upperView.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
            
            //upperView.layer.cornerRadius = 3.0
        }
    }
    
    @IBOutlet weak var lowerView: UIView!{
        didSet{
            lowerView.layer.cornerRadius = 15.0
            lowerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    //性別情報
    @IBOutlet weak var sexView: UIView! {
        didSet {
            sexView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var maleButton: RoundedButton!
    var maleButtonSelected:Bool = false
    @IBAction func maleButton(_ sender: Any) {
        userSex = sex[0]
        if maleButtonSelected == false {
            maleButton.backgroundColor = .gray
            maleButton.setTitleColor(.white, for: .normal)
            maleButtonSelected = true
            
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
            
            otherButton.backgroundColor = .white
            otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonSelected = false
        } else { //true時
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
        }
    }
    
    @IBOutlet weak var femaleButton: RoundedButton!

    var femaleButtonSelected:Bool = false
    
    @IBAction func femaleButton(_ sender: Any) {
        userSex = sex[1]
        if femaleButtonSelected == false {
            femaleButton.backgroundColor = .gray
            femaleButton.setTitleColor(.white, for: .normal)
            femaleButtonSelected = true
            
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
            
            otherButton.backgroundColor = .white
            otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonSelected = false
        } else { //true時
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
        }
    }
    
    
    
    @IBOutlet weak var otherButton: RoundedButton!
    var otherButtonSelected:Bool = false
    
    @IBAction func otherButton(_ sender: Any) {
        userSex = sex[2]
        if otherButtonSelected == false {
            otherButton.backgroundColor = .gray
            otherButton.setTitleColor(.white, for: .normal)
            otherButtonSelected = true
            
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
            
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
        } else { //true時
            otherButton.backgroundColor = .white
            otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonSelected = false
        }
    }
    
    @IBOutlet weak var ageView: UIView!{
        didSet {
            ageView.layer.cornerRadius = 10.0
        }
    }
    
    
    //年齢情報
    
    @IBOutlet weak var age1Button: RoundedButton!
    var age1ButtonSelected:Bool = false
    @IBAction func age1Button(_ sender: Any) {
        userAge = age[0]
        if age1ButtonSelected == false {
            age1Button.backgroundColor = .gray
            age1Button.setTitleColor(.white, for: .normal)
            age1ButtonSelected = true
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
            
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        } else { //true時
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age2Button: RoundedButton!
    var age2ButtonSelected:Bool = false
    @IBAction func age2Button(_ sender: Any) {
        userAge = age[1]
        if age2ButtonSelected == false {
            age2Button.backgroundColor = .gray
            age2Button.setTitleColor(.white, for: .normal)
            age2ButtonSelected = true
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
            
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        } else { //true時
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age3Button: RoundedButton!
    var age3ButtonSelected:Bool = false
    @IBAction func age3Button(_ sender: Any) {
        userAge = age[2]
        if age3ButtonSelected == false {
            age3Button.backgroundColor = .gray
            age3Button.setTitleColor(.white, for: .normal)
            age3ButtonSelected = true
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
            
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        } else { //true時
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age4Button: RoundedButton!
    var age4ButtonSelected:Bool = false
    @IBAction func age4Button(_ sender: Any) {
        userAge = age[3]
        if age4ButtonSelected == false {
            age4Button.backgroundColor = .gray
            age4Button.setTitleColor(.white, for: .normal)
            age4ButtonSelected = true
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
            
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        } else { //true時
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age5Button: RoundedButton!
    var age5ButtonSelected:Bool = false
    @IBAction func age5Button(_ sender: Any) {
        userAge = age[4]
        if age5ButtonSelected == false {
            age5Button.backgroundColor = .gray
            age5Button.setTitleColor(.white, for: .normal)
            age5ButtonSelected = true
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
            
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        } else { //true時
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age6Button: RoundedButton!
    var age6ButtonSelected:Bool = false
    @IBAction func age6Button(_ sender: Any) {
        userAge = age[5]
        if age6ButtonSelected == false {
            age6Button.backgroundColor = .gray
            age6Button.setTitleColor(.white, for: .normal)
            age6ButtonSelected = true
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
        } else { //true時
            age6Button.backgroundColor = .white
            age6Button.setTitleColor(.darkGray, for: .normal)
            age6ButtonSelected = false
        }
    }
    
    //let userRef  = Database.database().reference().child("users")
    let userRef =  Firestore.firestore().collection("users")
    
    @IBOutlet weak var passLoginButton: RoundedButton!

    @IBOutlet weak var handleLoginButton: RoundedButton!
    

    //let startVc:Media1ViewController = Media1ViewController()
    
    @IBAction func handleLoginButton(_ sender: Any) {
        passLoginButton.isEnabled = false
        passLoginButton.backgroundColor = .lightGray
        /*let startVc: ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        show(startVc, sender: nil)*/ //以前弄っていたところの名残が残っていたからかもしれない。
        /*
        let attentionViewController = self.storyboard?.instantiateViewController(withIdentifier: "Attention")
        self.show(attentionViewController!, sender: nil)*/

        
        Auth.auth().signInAnonymously() { (user, error) in
            if error != nil {
                //アラート表示とか
                SVProgressHUD.showError(withStatus: "何らかのエラーが発生しました。")
                return
            }
            SVProgressHUD.show()
            let userInfo = ["Sex":self.userSex,"Age":self.userAge]
            self.userRef.document((user?.user.uid)!).setData(userInfo){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            //uidもちゃんと指定した。
            
            //self.userRef.child((user?.user.uid)!).setValue(userInfo)
            //self.startVc.fetchCellViewModell()
            //self.dismiss(animated: true, completion: nil)
            /*
            let initialVc: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "Initial") as! UINavigationController
            self.show(initialVc, sender: nil)*/
            
            let  tutorialVc:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "Tutorial") as! UIViewController
            self.show(tutorialVc, sender: nil)
            
            /*
            let homeVc:ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
            */
        }
    }
    
    @IBAction func passLoginButton(_ sender: Any) {
        handleLoginButton.isEnabled = false
        handleLoginButton.backgroundColor = .lightGray
        
        
        /*
        let attentionViewController = self.storyboard?.instantiateViewController(withIdentifier: "Attention")
        self.show(attentionViewController!, sender: nil)*/
        
        Auth.auth().signInAnonymously() { (user, error) in
            if error != nil {
                //アラート表示とか
                SVProgressHUD.showError(withStatus: "何らかのエラーが発生しました。")
                return
            }
            SVProgressHUD.show()
            let userInfo = ["Sex":"","Age":""]
            self.userRef.document((user?.user.uid)!).setData(userInfo){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                    /*
                     updateDataでは、以下のエラーが出たが、setDataではエラーが出なかった。
 Error adding document: Error Domain=FIRFirestoreErrorDomain Code=5 "No document to update: projects/sexualhealthmedia-736f9/databases/(default)/documents/users/XAAmc3iZ54gxBnQ9otoVYHVyd383" UserInfo={NSLocalizedDescription=No document to update: projects/sexualhealthmedia-736f9/databases/(default)/documents/users/XAAmc3iZ54gxBnQ9otoVYHVyd383}
                    */
                }
            }
            /*
            self.userRef.addDocument(data: userInfo ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }*/
            
            //self.startVc.fetchCellViewModell()
            //self.dismiss(animated: true, completion: nil)
            
            
            //この時点で、アカウントは生成されているし、それも確認されているはず。なのになぜ？
            let  tutorialVc:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "Tutorial") as! UIViewController
            self.show(tutorialVc, sender: nil)
            //これで解決
            /*
            let homeVc:ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(homeVc, animated: true)*/
            
            
            
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

}
