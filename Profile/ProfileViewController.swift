//
//  ProfileViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/06.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import FirebaseFirestore
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    var pageMenu:CAPSPageMenu?
    var receivedUserId = ""    //自分で自分のプロフィールページを見ているのか、他人が覗いているのかの判断。後続するコードで、infoViewControllerからprofileViewControllerへ移った時に、receiveUserId == user.uidとなっていることが確かめられた。うまくできている。
    let ref = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "プロフィール"
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .gray  //clear
        navigationController?.navigationBar.alpha = 1 //0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        var controllerArray : [UIViewController] = []
        let controller1:ProfileCommentViewController = ProfileCommentViewController()
        controller1.masterViewPointer = self
        controller1.title = "ホーム"
        //receivedUserIdを、枝のViewControllerへ渡している。上手く渡せた。
        controller1.receivedUserId = receivedUserId
        controllerArray.append(controller1)
        
        let controller2:ProfileInfoViewController = ProfileInfoViewController()
        controller2.masterViewPointer = self
        controller2.title = "基本情報"
        //receivedUserIdを、枝のViewControllerへ渡している。上手く渡せた。
        controller1.receivedUserId = receivedUserId
        controllerArray.append(controller2)
        
        //receiveUserIdにuser.uidが入っていれば、編集ボタンを表示させ、基礎情報には自分の基礎情報を。入っていなければ編集ボタンを消去し、receivedUserIdに基づいた基礎情報を。
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                //print("receiveUserId == user.uidだった")
                //print(user.uid)
                ref.document(user.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        //print(document.data())
                        //textViewが存在しないケースがあるのでは？っと思ったけれど、addSubViewしなければいいだけなので、unexpected nilは生じないと思われる。
                        controller1.textView.text = document.data()!["Profile"] as? String
                        controller2.textView.text = document.data()!["Profile"] as? String
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                //receivedUserIdが他人だった場合の処理式。編集ボタンを消す必要ある。
            }
        }
        
        
        let paramerters:[CAPSPageMenuOption] = [
            
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
            
        ]
        
        //PageMenuの幅高さを決めておく
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 165.0, width: self.view.frame.width, height: self.view.frame.height) ,pageMenuOptions:paramerters) //ここを50下げた
        
        //PageMenuのViewを親のView（is.initialのViewContoroller）にコード上で追加した。
        self.view.addSubview(pageMenu!.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProfileData()
    }
    
    func fetchProfileData() {
        if let user = Auth.auth().currentUser{
            let ref = Firestore.firestore().collection("users").document("\(user.uid)")
            ref.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    /*if let ageLabelText = document.data()!["年齢"] as? String {
                        self.ageLabel.text = ageLabelText
                    }
                    
                    if let sexLabelText = document.data()!["性別"] as? String {
                        self.sexLabel.text = sexLabelText
                    }*/
                    
                    if let nameLabelText = document.data()!["name"] as? String {
                        self.nameLabel.text = nameLabelText
                    }
                    
                    if let pictureData = document.data()!["picture"] as? [String : Any] {
                        let pictureProperties = pictureData["data"]! as! [String:Any]
                        let imageUrl = pictureProperties["url"] as! String
                        self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile2"))
                    }
                    /*
                    //self.ageLabel.text = document.data()!["年齢"] as? String
                    self.sexLabel.text = document.data()!["性別"] as? String
                    self.nameLabel.text = document.data()!["name"] as? String
                    //print("document.data()![picture]のtype",type(of: document.data()!["picture"]))
                    //document.data()!["picture"]はAny型だった。どうしようもないな…
                    let pictureData = document.data()!["picture"] as! [String : Any]
                    print(pictureData) //以下のようになった。成功だと思われる。
                    /*
                     ["data": {
                     height = 50;
                     "is_silhouette" = 0;
                     url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1452193181581882&height=50&width=50&ext=1549953388&hash=AeSSHFN0nNSp71VE";
                     width = 50;
                     }]
                     */
                    let pictureProperties = pictureData["data"]! as! [String:Any] //[String:String]とキャストするとThread 1: EXC_BREAKPOINT (code=1, subcode=0x104a88ff0)というエラーが出る。 //[String:Any]としてエラー回避
                    print(pictureProperties)
                    
                    let imageUrl = pictureProperties["url"] as! String
                    self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile"))

                    /*for i in 0..<document.data()!.count {
                        self.categories.append(document.data()![self.types[i]] as! String)
                    }
                    print(self.categories)*/ //categoriesの中に何が入っているかがこれでわかる。
                    */
                } else {
                    print("Document does not exist")
                }
            }
        }
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
