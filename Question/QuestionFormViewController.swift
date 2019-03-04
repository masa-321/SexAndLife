//
//  QuestionFormViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/02/22.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class QuestionFormViewController: UIViewController, UITextViewDelegate {
    
    var postedQuestionData:QuestionData?
    
    @IBOutlet weak var imageView: EnhancedCircleImageView!{
        didSet{
            //imageView.sd_setImage(with: URL(string: profileData!.pictureUrl!), placeholderImage: UIImage(named: "profile2"))
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            //self.nameLabel.text = profileData!.name
        }
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            if let savedText = UserDefaults.standard.object(forKey: "question") as? String{
                textView.text = savedText
            }
        }
    }
    
    @IBOutlet weak var upperView: UIView!{
        didSet{
            upperView.layer.cornerRadius = 15.0
            upperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        }
    }
    
    @IBOutlet weak var lowerView: UIView!{
        didSet {
            //lowerView.layer.cornerRadius = 15.0
            lowerView.layer.cornerRadius = 15.0
            lowerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearButton(_ sender: Any) {
        textView.text = ""
        UserDefaults.standard.set(textView.text, forKey: "question")
    }
    
    //submitボタン。CommentViewController.swiftを参考に構築
    @IBAction func submitButton(_ sender: Any) {
        SVProgressHUD.show()
        
        if let user = Auth.auth().currentUser {
            let now = NSDate()
            //Firestoreに格納するために辞書型の箱を作っている
            var questionData:[String:Any] = [:]
            //一つ一つのQuestionに割り当てられるuuidを生成
            let uuid = NSUUID().uuidString

            let question = [
                    uuid:[
                    "questionLikes":[],
                    "questionText":textView.text,
                    "questionTime":now
                ]
            ] as! [String : Any]
            
            questionData = question
            
            let ref = Firestore.firestore().collection("questions").document(user.uid)
            ref.updateData(questionData) { err in
                if let err = err {
                    print("updateData(questionData) Error adding document:\(err)")
                    //updateDataが通用するのはすでにuser.uidに紐ついたdocumentが存在したケース。存在しない場合は新たにuser.uidに紐ついたdocumentを作成しなければならない。
                    //documentが存在しなかった場合の処理
                    if "\(err)".contains("No document to update") {
                        ref.setData(questionData) {err in
                            if let err = err {
                                print("setData(question) Error adding document: \(err)")
                            } else {
                                print("setData(question) Document successfully written!")
                                
                                UserDefaults.standard.set("", forKey: "question")
                                self.dismiss(animated: true, completion:nil)
                                SVProgressHUD.dismiss()
                                return
                            }
                        }
                    }
                    
                } else {
                    print("updateData(questionData) Document successfully written!:\(err)")
                    //送信成功と同時に、UserDefaultsにて"question"というkey値で保存されたデータをリセット
                    UserDefaults.standard.set("", forKey: "question")
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                    return
                }
            }
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //View以外のところに触れればdismiss
    }
    
 
    
    //画面の外を押したら閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    //編集中でも情報を送ることができた。
    func textViewDidChange(_ textView: UITextView) {
        // masterViewPointer?.profileData?.profile = self.textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let writtenText = textView.text! as NSString
        //let replaceString = writtenText.replacingCharacters(in: range, with: string)
        UserDefaults.standard.set(textView.text, forKey: "question")
        return true
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
