//
//  SocialNetworkViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/10.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
//import SVProgressHUD

//接続するにあたって、Storyboadのcellに、SocialNetworkCellを継承させる必要があった。
class SocialNetworkCell: UITableViewCell{
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
    }
    
}

class SocialNetworkViewController: UIViewController/*,FBSDKLoginButtonDelegate */{
    
    @IBOutlet weak var tableView: UITableView!
    
    var userProfile:AuthDataResult!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("providerData[0]：\(Auth.auth().currentUser?.providerData[0])")
        //print("providerData[0].providerID：\(Auth.auth().currentUser?.providerData[0].providerID)")
        
        
        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.title = "ソーシャル連携"
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .gray  //clear
        navigationController?.navigationBar.alpha = 1 //0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser{
            //userの型はFIRUserで、userの中身は<FIRUser: 0x281449f80>、user.uidはeT7OYTOD0nW7URSW8gDk23RTXzv2、user.emailはOptional("ma.ly321.luna.notte@gmail.com")、user.providerIDはproviderID：Firebase
            //user.providerDataの型はArray<FIRUserInfo>で、user.providerDataの中身は<FIRUserInfoImpl: 0x281722680>
            
            fetchUserProfile()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SocialNetworkViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let socialNetworkCell:SocialNetworkCell = tableView.dequeueReusableCell(withIdentifier: "SocialNetworkCell", for: indexPath) as! SocialNetworkCell
        if let user = Auth.auth().currentUser {
            if user.providerData.isEmpty {
                socialNetworkCell.linkLabel.text = ""
                print("user.providerDataは空です")
            } else {
                print("user.providerDataは空ではない")
                for i in 0..<user.providerData.count {
                    if user.providerData[i].providerID == "facebook.com" {
                        socialNetworkCell.linkLabel.text = "連携中"
                    } else {
                        socialNetworkCell.linkLabel.text = ""
                    }
                }
            }
        } else {
            print("Auth.auth().currentUserはnilです")
        }
        return socialNetworkCell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginManager = FBSDKLoginManager()
        
        
        if let user = Auth.auth().currentUser {
            
            if user.providerData.isEmpty {
                print("user.providerDataは空です")
                
                loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
                    //public_profileの中に、pictureとかnameとか入っているはずなんだ。
                    if (error != nil) {
                        print("permission Errorメッセージ：\(error!)")
                    }
                    //この時点ではproviderDataは空のまま。ログインしているようでログインはできていない。tableViewを更新しても、連携とは表示されない。つまり・・・①
                    
                    
                    if let token = FBSDKAccessToken.current() {
                        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                        //Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        user.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
                            if error != nil {
                                print("ログイン Errorメッセージ：\(error!)")
                                return
                            }
                            
                            //成功時のアラート表示（始め）//
                            let title = "Facebookと連携しました"
                            let message = ""
                            //let okText = "OK"
                            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                            
                            //OK時の処理を定義。UIAlertAction.Styleがdefaultであることに注意
                            let okAction = UIAlertAction(title: "OK" ,style: UIAlertAction.Style.default, handler :
                            { (action:UIAlertAction) in
                                //ここで処理の続行へ戻させる
                               
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            //成功時のアラート表示（終わり）//
                            
                            //ここに、途中キャンセルした時の処理を書けたらいいのだが…
                            print("\(authResult)")
                            //連携状態って意味であって、Facebookにログインしたわけではないのでは？って思ったが、ちゃっかりログインしていた。無許可でも。意味がわからないぞ。
                            self.tableView.reloadData() //①により、ここにtableViewを配置してもあまり意味はない。
                            self.fetchUserProfile()
                        })
                        
                    }
                    
                }
                return
                
            } else {
                for item in user.providerData {
                //for i in 0..<user.providerData.count {
                    /*
                     for item in providerData {
                     print("\(item.providerID)")
                     }という書き方でも良いかもしれない。
                     */
                    if item.providerID == "facebook.com" {
                    //if user.providerData[i].providerID == "facebook.com" {
                        
                        //連携解除時のアラーを設置。OKを押したら、解除処理を行う。
                        let title = "Facebookとの連携を解除してもよろしいですか？"
                        let message = ""
                        //let okText = "OK"
                        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                        
                        //OK時の処理を定義。UIAlertAction.Styleがdefaultであることに注意
                        let okAction = UIAlertAction(title: "はい" ,style: UIAlertAction.Style.default, handler :
                        { (action:UIAlertAction) in
                            //ここで処理の続行へ戻させる
                            
                            //連携解除の処理
                            loginManager.logOut()
                            //loginManager.logOut()を記入しなくても、unlinkでログアウトしているようだ。Firebaseを見る限り。
                            //試しに使ってみたが、全く反応しない。
                            //いや、これを記述していないと、ログイン状態が保たれていて、いつでも許可なくlinkできてしまう状態が保たれるのでは？
                            
                            
                            //Facebookとの連携を解除する操作
                            user.unlink(fromProvider: "facebook.com") { (user, error) in
                                // ...
                                print("unlinkしました")
                                self.tableView.reloadData()
                                return
                            }
                            
                        })
                        alert.addAction(okAction)
                        
                        //キャンセル時の処理を定義。UIAlertAction.Styleがcancelであることに注意
                        let cancelAction:UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
                            //キャンセル時の処理を書く。ただ処理をやめるだけなら書く必要はない。
                        })
                        alert.addAction(cancelAction) //addActionなのね。
                        
                         
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                        /*
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }*/
                        
                    } else {
                        return
                        /*
                        //Twitterとかとは連携しているが、Facebookとは連携していないケースに、Facebookとの連携を行う操作
                        if let token = FBSDKAccessToken.current() {
                            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                            user.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
                                if error != nil {
                                    print("接続 Errorメッセージ：\(error!)")
                                    return
                                }
                                
                                self.userProfile = authResult!
                                print(self.userProfile)
                                //Optional(<FIRAuthDataResult: 0x282d5b2e0>)って？
                                //ログイン時の処理？
                                print("Facebookに連携しました")
                                self.tableView.reloadData()
                            })
                            
                            
                            
                            return
                        }*/
                        
                    }
                }
                
            }
        } else {
            print("Auth.auth().currentUserはnilです")
        }
        
    }
    
    
    
    
    func fetchUserProfile(){
        let graphPath = "me"
        
        //let parameters = ["fields": "id, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"]
        let parameters = ["fields": "id, name, picture"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
        
        var userInfo:[String : AnyObject] = [:]

        graphRequest?.start { (connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("type(of:result!)：\(type(of:result!))")
                //print(result!)
                userInfo = result as! [String : AnyObject]
                print("type(of:result!)：\(type(of:userInfo))")
                //userData = userInfo
                //この中に書くとか…
                if let user = Auth.auth().currentUser {
                    let userRef = Firestore.firestore().collection("users").document("\(user.uid)")
                    
                    //print("userInfo.values：",userInfo.values) ここに書くとなぜか呼ばれない。
                    //print("userInfo：",userInfo) ここに書くとなぜか呼ばれない。
                    
                    userRef.updateData(userInfo){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                        print("\(user.uid)")
                        //\()はOptionalな値になりがち？？StringDescribingにしてもOptionalだった。if let 構文の中に組み込むことでなんとか解消。ただ、Cloud Functionは更新されない。なんで？
                        /*
                         for key in userInfo.keys {
                         if key == "picture" {
                         element = [key:]
                         } else {
                         let  = array.map{
                         }
                         }*/
                        //let userInfo2 = userInfo.mapValues {String($0)}
                        //print(userInfo)
                        //let userInfo2 = userInfo.filter{ "\($0)" != "picture" }
                        //print(userInfo2)
                        //
                        print("userInfo（callbackの中）：",userInfo)
                        print("userInfo.values：",userInfo.values)
                    }
                }
            }
        }
        
        
    }
    
}



/*
//didCompleteWithもFirebaseに書かれていた。
// login callback
func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
    if error != nil {
        print("Login Errprメッセージ：\(error!)")
        return
    }
    
    //以下のif let文で、キャンセル時のunexpectedly nilを防いでいるっぽい。
    if let token = FBSDKAccessToken.current() {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        
        /*
         Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
         if error != nil {
         // ...
         print("Auth Errorメッセージ：\(error)")
         return
         }
         // ログイン時の処理
         }*/
        
        Auth.auth().currentUser?.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
            if error != nil {
                print("接続 Errorメッセージ：\(error)")
                return
            }
        })
        //匿名ログイン時のidを引き継いでFacebook連携できるようだ。ただ…サインアウトした時にuseridはリセットされるようだ。つまり、Facebookのログアウトと同時に、匿名アカウントのログアウトも行われてしまう。すでに作成していたFacebookのidと統合されるわけではないらしい。
        //加えて、クリップ記事になぜか追加されない現象が起きる。
        
        return
    }
    /*
     // ログイン時の処理
     let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
     linkToFireBase(credential: credential)
     */
}
/*
 //これも書かれていた。
 @IBAction func logoutButton(_ sender: Any) {
 if Auth.auth().currentUser?.providerData[0] != nil {
 print("providerData[0]：\(Auth.auth().currentUser?.providerData[0])")
 print("providerData[0].providerID：\(Auth.auth().currentUser?.providerData[0].providerID)")
 print("providerData[0].uid：\(Auth.auth().currentUser?.providerData[0].uid)")
 } else {
 print("providerDataはnilです")
 }
 
 /*
 providerData[0]：Optional(<FIRUserInfoImpl: 0x280ea2a40>)
 providerData[0].providerID：Optional("facebook.com")
 providerData[0].uid：Optional("1452193181581882")
 */
 //一度ログインしてログアウトしたら、Facebookアカウントがリセットされるかと思ったが、そんなことはなかった。
 /*
 providerData[0]：Optional(<FIRUserInfoImpl: 0x282fa0e40>)
 providerData[0].providerID：Optional("facebook.com")
 providerData[0].uid：Optional("1452193181581882")
 */
 
 /*
 let firebaseAuth = Auth.auth()
 do {
 try firebaseAuth.signOut()
 } catch let signOutError as NSError {
 print ("Error signing out: %@", signOutError)
 }*/
 
 
 if let user = Auth.auth().currentUser {
 user.unlink(fromProvider: "facebook.com") { (user, error) in
 // ...
 print("unlinkしました")
 }
 }
 
 }
 */


// Logout callback
func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
}
*/
