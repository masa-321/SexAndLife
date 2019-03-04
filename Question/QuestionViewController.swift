//
//  QuestionViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/02/21.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sectionTitles = [String]()
    var questionArray:[QuestionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationControllerの設定はinfoViewController.swiftを参考にした
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "質問箱"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        sectionTitles = ["Ask Form","Questions"]
        
        fetchQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //★Questionsを引っ張ってくるためのコード
    func fetchQuestions() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let ref = Firestore.firestore().collection("questions")
            
            ref.addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error fetching questions documents: \(err)")
                } else {
                    self.questionArray = [] //まずはquestionArrayを初期化
                    
                    for document in (querySnapshot?.documents)! {
                        for snapshot in document.data() {
                            let questionData = QuestionData(snapshot: snapshot, questionerID: document.documentID, myId: uid)
                            self.questionArray.insert(questionData, at: 0) //コメントと違って、記事のIDとの紐つけでスクリーニングする必要はない。
                            
                            self.questionArray.sort(by: {$0.questionLikes.count > $1.questionLikes.count})//いいねの数順にソート
                            print("self.questionArray","\(self.questionArray)") //デバッグ用
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            //tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
            tableView.bounces = false
            //tableView.estimatedRowHeight = 90
            //tableView.rowHeight = UITableView.automaticDimension
            //コメントCellの高さは、CommentTableViewCell.swiftを参考にすれば高さ可変になると思われる。
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 { //投稿のためのCell部分のHeader
            return 50
        } else { //if section == 1 質問が溜まっていく部分のHeader
            return 50
        }
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { //投稿のためのCell部分のHeaderの中身
            let headerView = UIView()
            headerView.backgroundColor = .gray
            return headerView
        } else { //section == 1 質問が溜まっていく部分のHeaderの中身
            let headerView = UIView()
            return headerView
        }
    }*/
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else { //if section == 1
            print("questionArray.count:","\(questionArray.count)")
            return questionArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AskCell", for: indexPath)
            return cell
        } else { //indexPath.section == 1

            print("cellForRowAtは呼ばれているよ！")
            let cell:QuestionCell = tableView.dequeueReusableCell(withIdentifier: "AskedCell", for: indexPath) as! QuestionCell
            cell.setQuestionCellInfo(questionData: questionArray[indexPath.row])
            cell.selectionStyle = .none
            //cell.profileButton.addTarget()
            //cell.textView.text = "テスト"
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc:QuestionFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionForm") as! QuestionFormViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            
        }
    }
    
    //ボタンは現時点では設置していない。
    @IBAction func QuestionFormButton(_ sender: Any) {
        let vc:QuestionFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionForm") as! QuestionFormViewController
        self.present(vc, animated: true, completion: nil)
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
