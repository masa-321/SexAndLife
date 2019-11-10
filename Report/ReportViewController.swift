//
//  ReportViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/11/09.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profileData:Profile?
    var reportText:String = ""
    var commentedArticleID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "問題を報告する"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = false //黒い影が消えた。isTranslucent = trueだと透明となり、黒い背面が出るのか。
        navigationController?.navigationBar.barTintColor = .white //無事白になった。
        //navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ReportDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "reportDescriptionCell", for:indexPath) as! ReportDescriptionCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        } else {
            let cell:ReportTextCell = tableView.dequeueReusableCell(withIdentifier: "reportTextCell", for:indexPath) as! ReportTextCell
            cell.textView.text = self.reportText
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        }
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        
        //sendButtonを押した時のアラートを構築 関数の外に配置したら、navigationController?popViewControllerがうまく動かなかった。
        let alertController1 = UIAlertController(title: "報告ありがとうございました", message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertController2 = UIAlertController(title: "何らかのエラーが発生した様です", message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler :{ (action:UIAlertAction) in
            //ここで処理の続行へ戻させる
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // your code here
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        SVProgressHUD.show()
        if let user = Auth.auth().currentUser {
            let now = NSDate()
            //Firestoreに格納するために辞書型の箱を作っている
            var reportData:[String:Any] = [:]
            //一つ一つのQuestionに割り当てられるuuidを生成
            let uuid = NSUUID().uuidString
            
            
            let report = [
                uuid:[
                        "CommenterId":self.profileData?.id,
                        "commentedArticleID":self.commentedArticleID,
                        "reportText":reportText,
                        "reportTime":now
                    ]
                ]  //as! [String : Any]
            
            reportData = report
            
            let ref = Firestore.firestore().collection("reports").document(user.uid)
            ref.updateData(reportData) { err in
                if let err = err {
                    print("updateData(reportData) Error adding document:\(err)")
                    
                    SVProgressHUD.dismiss()

                    //アラートで報告への感謝
                    alertController1.addAction(okAction)
                    self.present(alertController1, animated: true, completion: nil)
                //updateDataが通用するのはすでにuser.uidに紐ついたdocumentが存在したケース。存在しない場合は新たにuser.uidに紐ついたdocumentを作成しなければならない。
                    //documentが存在しなかった場合の処理
                    if "\(err)".contains("No document to update") {
                        ref.setData(reportData) {err in
                            if let err = err {
                                print("setData(question) Error adding document: \(err)")
                                
                                SVProgressHUD.dismiss()
                                alertController2.addAction(okAction)
                                self.present(alertController2, animated: true, completion: nil)
                                
                            } else {
                                print("setData(question) Document successfully written!")
                                
                                SVProgressHUD.dismiss()
                                
                                //アラートで報告への感謝
                                alertController1.addAction(okAction)
                                self.present(alertController1, animated: true, completion: nil)
                                return
                            }
                        }
                    }
                    
                } else {
                    print("updateData(reportData) Document successfully written!:\(err)")
                    
                    SVProgressHUD.dismiss()
                    
                    //アラートで報告への感謝
                    alertController1.addAction(okAction)
                    self.present(alertController1, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}

class ReportDescriptionCell:UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!{
        didSet {
            
            textView.delegate = self
            textView.text = "あなた自身への誹謗中傷があった場合、以下のフォームからご報告お願いいたします。ご報告いただいた内容は、利用規約に照らし合わせて確認いたします。対応状況や結果についてのご連絡はいたしかねます。"
            textView.translatesAutoresizingMaskIntoConstraints = true
            textView.isEditable = false
            //textView.sizeToFit()
            
        }
    }
}

class ReportTextCell:UITableViewCell, UITextViewDelegate {
    var masterViewPointer:ReportViewController?
    
    //@IBOutlet weak var commentNumLabel: UILabel!
    
    @IBOutlet weak var textView: InspectableTextView!{
        didSet {
            
            textView.delegate = self
            textView.localizedString = "問題の詳細を200字以内でご記入ください"
            textView.translatesAutoresizingMaskIntoConstraints = true
            //textView.sizeToFit()
            
            /*
            let commentNum = textView.text.count
            //残りの文字数に応じて、ラベルの色を変える。
            if commentNum <= 69 {
                commentNumLabel.text = "残り " + String(80 - commentNum)
                commentNumLabel.textColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
            } else if commentNum > 69 && commentNum <= 80{
                commentNumLabel.text = "残り " + String(80 - commentNum)
                commentNumLabel.textColor = .orange
            } else {
                commentNumLabel.text = "残り 0"
                commentNumLabel.textColor = .red
            }*/
            
            
            // 仮のサイズでボトムにツールバー生成…いらないかも。
            let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
            
            kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
            
            // スペーサー
            let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
            
            // 閉じるボタン
            let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commitButtonTapped(sender:event:)))
            
            kbToolBar.items = [spacer, commitButton]
            textView.inputAccessoryView = kbToolBar
        }
    }
    
    @objc func commitButtonTapped (sender:UIBarButtonItem, event:UIEvent) {
        textView.resignFirstResponder()
        print("完了")
    }
    
    //画面の外を押したら閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
        //なぜかtextViewDidChangeが呼ばれない現象発生。ProfileEditViewControllerの方では問題なく呼ばれるが…
    //InspectableTextViewを継承しているために、編集中の上書きがうまくいかなかったが、togglePlaceholder()の定義をpublicにし、加えて、定義のextention部分を消去したらうまく行った。
    func textViewDidChange(_ textView: UITextView) {
        
        masterViewPointer?.reportText = self.textView.text
        self.textView.togglePlaceholder()
        print("masterViewPointer?.reportText:",masterViewPointer?.reportText)
        
    }
    
}

