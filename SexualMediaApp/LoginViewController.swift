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

class LoginViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var sex = ["男性","女性","その他"]
    var lgbtqList = ["その他","レズビアン","ゲイ","バイセクシュアル","トランスジェンダー","クエスチョニング"]
    var age = ["19歳以下", "20~24歳", "25~29歳", "30~39歳", "40~49歳", "50歳以上"]
    var userSex = ""
    var userAge = ""
    
    //★lgbtqを選ぶpopupView★
    @IBOutlet weak var popupView: UIView!{
        didSet {
            popupView.alpha = 0
        }
    }
    
    @IBOutlet weak var sexpickerView: UIPickerView!{
        didSet{
            sexpickerView.layer.cornerRadius = 15.0
            sexpickerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var sexpickerSupportView: UIView!{
        didSet{
            sexpickerSupportView.layer.cornerRadius = 15.0
            sexpickerSupportView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lgbtqList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        
        return lgbtqList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        //選んだ後の処理を記述する
        //masterViewPointer?.profileData?.sex = dataList[row]
        self.userSex = lgbtqList[row]
        otherButtonLabel.text = self.userSex
        //otherButtonLabel.textAlignment = NSTextAlignment.center
        
        
        if self.userSex == "レズビアン" {
            otherButtonLabel.font = UIFont.systemFont(ofSize: 14)
        } else if self.userSex == "トランスジェンダー" {
            otherButtonLabel.font = UIFont.systemFont(ofSize: 9)
            
        }else if self.userSex == "バイセクシュアル" || self.userSex == "クエスチョニング" {
            otherButtonLabel.font = UIFont.systemFont(ofSize: 10)
        } else {
            otherButtonLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        print(userSex)
        
    }
    
    @IBAction func popdownButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.popupView.alpha = 0.0
        }, completion: nil)
        otherButtonLabel.text = self.userSex //念の為
    }
    
    @IBAction func okButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.popupView.alpha = 0.0
        }, completion: nil)
    }
    
    
    //★性別と年齢を選ぶ★
    @IBOutlet weak var basementView: UIView!{
        didSet {
            basementView.layer.cornerRadius = 15.0
        }
    }
    
    
    
    @IBOutlet weak var upperView: UIView!{
        didSet {
            upperView.layer.cornerRadius = 15.0
            //
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
        
        if maleButtonSelected == false {
            maleButton.backgroundColor = .gray
            maleButton.setTitleColor(.white, for: .normal)
            maleButtonSelected = true
            
            //userSexを"男性"へ
            userSex = sex[0]
            
            //その他の下のラベルをリセット
            otherButtonLabel.text = "その他"
            otherButtonLabel.font = UIFont.systemFont(ofSize: 17)
            
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
            
            otherButton.backgroundColor = .white
            //otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonLabel.textColor = .darkGray
            otherButtonSelected = false
        } else { //true時
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
            
            //userSexをリセット
            userSex = ""
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
            
            //userSexを"女性"へ
            userSex = sex[1]
            
            //その他の下のラベルをリセット
            otherButtonLabel.text = "その他"
            otherButtonLabel.font = UIFont.systemFont(ofSize: 17)
            
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
            
            otherButton.backgroundColor = .white
            //otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonLabel.textColor = .darkGray
            otherButtonSelected = false
            
            print(userSex)
        } else { //true時
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
            
            //userSexをリセット
            userSex = ""
            print(userSex)
        }
    }
    
    
    
    @IBOutlet weak var otherButton: RoundedButton!
    @IBOutlet weak var otherButtonLabel: UILabel!
    
    var otherButtonSelected:Bool = false
    
    @IBAction func otherButton(_ sender: Any) {
        if otherButtonSelected == false {
            otherButton.backgroundColor = .gray
            //otherButton.setTitleColor(.white, for: .normal)
            otherButtonLabel.textColor = .white
            otherButtonSelected = true
            
            //userSexを"その他"へ
            userSex = sex[2]
            
            //popupViewをぬるっと表示させる
            UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
                self.popupView.alpha = 1.0
            }, completion: nil)
            
            maleButton.backgroundColor = .white
            maleButton.setTitleColor(.darkGray, for: .normal)
            maleButtonSelected = false
            
            femaleButton.backgroundColor = .white
            femaleButton.setTitleColor(.darkGray, for: .normal)
            femaleButtonSelected = false
            
            print(userSex)
        } else { //true時
            otherButton.backgroundColor = .white
            //otherButton.setTitleColor(.darkGray, for: .normal)
            otherButtonLabel.textColor = .darkGray
            otherButtonSelected = false
            otherButtonLabel.text = "その他"
            
            //userSexをリセット
            userSex = ""
            
            print(userSex)
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
        
        if age1ButtonSelected == false {
            
            userAge = age[0]
            
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
            userAge = ""
            
            age1Button.backgroundColor = .white
            age1Button.setTitleColor(.darkGray, for: .normal)
            age1ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age2Button: RoundedButton!
    var age2ButtonSelected:Bool = false
    @IBAction func age2Button(_ sender: Any) {
        
        if age2ButtonSelected == false {
            userAge = age[1]
            
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
            userAge = ""
            
            age2Button.backgroundColor = .white
            age2Button.setTitleColor(.darkGray, for: .normal)
            age2ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age3Button: RoundedButton!
    var age3ButtonSelected:Bool = false
    @IBAction func age3Button(_ sender: Any) {
        
        if age3ButtonSelected == false {
            userAge = age[2]
            
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
            userAge = ""
            
            age3Button.backgroundColor = .white
            age3Button.setTitleColor(.darkGray, for: .normal)
            age3ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age4Button: RoundedButton!
    var age4ButtonSelected:Bool = false
    @IBAction func age4Button(_ sender: Any) {
        
        if age4ButtonSelected == false {
            userAge = age[3]
            
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
            userAge = ""
            
            age4Button.backgroundColor = .white
            age4Button.setTitleColor(.darkGray, for: .normal)
            age4ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age5Button: RoundedButton!
    var age5ButtonSelected:Bool = false
    @IBAction func age5Button(_ sender: Any) {
        
        if age5ButtonSelected == false {
            
            userAge = age[4]
            
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
            userAge = ""
            
            age5Button.backgroundColor = .white
            age5Button.setTitleColor(.darkGray, for: .normal)
            age5ButtonSelected = false
        }
    }
    
    @IBOutlet weak var age6Button: RoundedButton!
    var age6ButtonSelected:Bool = false
    @IBAction func age6Button(_ sender: Any) {
        
        if age6ButtonSelected == false {
            
            userAge = age[5]
            
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
            userAge = ""
            
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
            
            //FlexibleSteppedProgressBarを使ったTutorialへ誘導するよう変更
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
        sexpickerView.delegate = self
        sexpickerView.dataSource = self
        otherButtonLabel.text = "その他"
        otherButtonLabel.textColor = .darkGray
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    /*override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }*/

}
