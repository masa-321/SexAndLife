//
//  ProfileInfoViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/13.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileInfoViewController: UINavigationController {
    
    var masterViewPointer:ProfileViewController?
    var textView: UITextView = UITextView()
    var receivedUserId = ""
    
    let ref = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景色を記述
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        if let user = Auth.auth().currentUser {
            //receivedUserIdが自分だった時の処理
            if receivedUserId == user.uid {
                print("receivedUserId == user.uidだったよ")
                ref.document(user.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        if document.data()!["Profile"] != nil {
                            self.view.addSubview(self.textView)
                            return
                        }
                        
                    } else {
                        print("Document does not exist")
                    
                    }
                }
            } else {
                //receivedUserIdが他人だった場合の処理式
                
            }
        }
        
        
        
        //textViewの位置とサイズを設定
        textView.frame = CGRect(x:0, y:10, width:self.view.frame.width, height:textView.contentSize.height)
        //この下の２行を付け加え、且つ上をheight:textView.contentSize.heightとするkことで、heightが臨機応変に変わるようになったように思う。
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        
        
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderWidth = 0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.white
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
