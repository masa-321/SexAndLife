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
    
    @IBOutlet weak var sortingView: UIView!{
        didSet {
            sortingView.alpha = 0
        }
    }
    
    @IBOutlet weak var typeALabel: UILabel!
    @IBOutlet weak var typeACheckImageView: UIImageView!
    
    @IBOutlet weak var typeBLabel: UILabel!
    @IBOutlet weak var typeBCheckImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationControllerの設定はinfoViewController.swiftを参考にした
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "匿名質問箱"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        sectionTitles = ["","Ask Form"," Questions"]
        
        if UserDefaults.standard.object(forKey: "sortingMode") == nil || (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeA" {
            typeACheckImageView.isHidden = false
            typeBCheckImageView.isHidden = true
            typeALabel.font = UIFont.boldSystemFont(ofSize: 17)
            
        } else if (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeB" {
            typeACheckImageView.isHidden = true
            typeBCheckImageView.isHidden = false
            typeBLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        fetchQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        fetchQuestions()
        
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
                            
                            if UserDefaults.standard.object(forKey: "sortingMode") == nil || (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeA" {
                                self.questionArray.sort(by: {$0.questionLikes.count > $1.questionLikes.count})//いいねの数順にソート
                            } else if (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeB" {
                                self.questionArray.sort(by: {$0.questionTime! > $1.questionTime!}) //"Binary operator '>' cannot be applied to two 'Date?' operands"というエラーが出ていたが、オプショナルを解除したらうまくいった。
                            }
                            
                            //print("self.questionArray","\(self.questionArray)") //デバッグ用
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
        if section == 0 { //説明のためのCell部分のHeader
            return 0
        } else if section == 1 { //投稿のためのCell部分のHeader
            return 0
        } else { //if section == 1 質問が溜まっていく部分のHeader
            return 50
        }
    }
    
    //普通にheaderを設置すると、下にスクロールするときに、上のheaderが残って気持ち悪い。それをなくすためのちょっとした工夫。要は一番上のSectionのFooterを次のSectionのHeaderの代わりとして使う。
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 { //説明のためのCell部分のHeader
            return 50
        } else if section == 1 { //投稿のためのCell部分のHeader
            return 0
        } else { //if section == 1 質問が溜まっていく部分のHeader
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0||section == 1 { //DescriptionとAskのHeader設定。どのみちheightが0で外からは見えない。
            return UIView()
        } else { //section == 2 質問が溜まっていく部分のHeaderの中身
            let section2HeaderView = UIView()
            section2HeaderView.backgroundColor = UIColor.groupTableViewBackground
            
            //TitleLabelを作成し追加する
            let section2TitleLabel = UILabel()
            section2TitleLabel.text = "Questions"
            section2TitleLabel.font = UIFont.boldSystemFont(ofSize: 17) //太字にした。
            section2TitleLabel.frame = CGRect(x:15, y:10, width:160, height:30)
            section2HeaderView.addSubview(section2TitleLabel)
            
            //Buttonを作成し追加する
            let sortButton = UIButton()
            sortButton.backgroundColor = .clear
            sortButton.translatesAutoresizingMaskIntoConstraints = false //これを追加しないと、表示されなかった。
            section2HeaderView.addSubview(sortButton)
            sortButton.addTarget(self, action: #selector(popupSortingView(_:)), for: UIControl.Event.touchUpInside)
            
            
            //AutoLayout
            sortButton.widthAnchor.constraint(equalToConstant: 120).isActive = true //widthとheightはAutoLayoutの前でも問題ない。
            sortButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            sortButton.centerYAnchor.constraint(equalTo: section2HeaderView.centerYAnchor).isActive = true
            sortButton.trailingAnchor.constraint(equalTo: section2HeaderView.trailingAnchor, constant: -20.0).isActive = true
            
            //ImageViewを作成し追加する
            let sortImageView = UIImageView()
            sortImageView.image = UIImage.init(named: "sort")
            sortImageView.translatesAutoresizingMaskIntoConstraints = false
            section2HeaderView.addSubview(sortImageView)
            
            //AutoLayout
            sortImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true //widthとheightはAutoLayoutの前でも問題ない。
            sortImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            sortImageView.centerYAnchor.constraint(equalTo: section2HeaderView.centerYAnchor).isActive = true
            sortImageView.trailingAnchor.constraint(equalTo: section2HeaderView.trailingAnchor, constant: -20.0).isActive = true
            
            //SortingModeのLabelを設置
            let sortingModeLabel = UILabel()
            sortingModeLabel.translatesAutoresizingMaskIntoConstraints = false
            if UserDefaults.standard.object(forKey: "sortingMode") == nil || (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeA" {
                sortingModeLabel.text = "Popular"
            } else if (UserDefaults.standard.object(forKey: "sortingMode") as? String) == "sortingTypeB" {
                sortingModeLabel.text = "Recent"
            }
            sortingModeLabel.font = UIFont.boldSystemFont(ofSize: 16)
            sortingModeLabel.textAlignment = NSTextAlignment.right
            section2HeaderView.addSubview(sortingModeLabel)
            
            //AutoLayout
            sortingModeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            sortingModeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            sortingModeLabel.centerYAnchor.constraint(equalTo: section2HeaderView.centerYAnchor).isActive = true
            sortingModeLabel.trailingAnchor.constraint(equalTo: sortImageView.leadingAnchor, constant: 0.0).isActive = true
            
            return section2HeaderView
            
        }
    }
    
    @objc func popupSortingView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortingView.alpha = 1.0
            }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let section1HeaderView = UIView()
            section1HeaderView.backgroundColor = UIColor.groupTableViewBackground
            
            //TitleLabelを作成し追加する
            let section1TitleLabel = UILabel()
            section1TitleLabel.text = "Ask Form"
            section1TitleLabel.font = UIFont.boldSystemFont(ofSize: 17) //太字にした。
            section1TitleLabel.frame = CGRect(x:15, y:10, width:160, height:30)
            section1HeaderView.addSubview(section1TitleLabel)
            
            return section1HeaderView
            
        } else { //section == 1,2 どのみちheightは0で外からは見えない。
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0||section == 1 { //DescriptionとAskのRowの数
            return 1
        } else { //if section == 1
            //print("questionArray.count:","\(questionArray.count)") デバッグ用
            return questionArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AskCell", for: indexPath)
            return cell
        } else { //indexPath.section == 1

            let cell:QuestionCell = tableView.dequeueReusableCell(withIdentifier: "AskedCell", for: indexPath) as! QuestionCell
            cell.setQuestionCellInfo(questionData: questionArray[indexPath.row])
            cell.selectionStyle = .none
            cell.likeButton.addTarget(self, action: #selector(likeButton(sender:event:)), for: UIControl.Event.touchUpInside)
            //cell.profileButton.addTarget()
            //cell.textView.text = "テスト"
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            let vc:QuestionFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionForm") as! QuestionFormViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            
        }
    }
    
    //ボタンでも記入できるようにする
    @IBAction func QuestionFormButton(_ sender: Any) {
        let vc:QuestionFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionForm") as! QuestionFormViewController
        self.present(vc, animated: true, completion: nil)
    }

    
    
    @objc func likeButton(sender:UIButton, event:UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let questionData = questionArray[indexPath!.row]
        
        if let uid = Auth.auth().currentUser?.uid {
            if questionData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in questionData.questionLikes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = questionData.questionLikes.index(of: likeId)!
                        
                        break
                    }
                }
                questionData.questionLikes.remove(at: index)
            } else {
                questionData.questionLikes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let questionRef = Firestore.firestore().collection("questions").document(questionData.questionerID!)
            let questionlikes = [
                questionData.questionID:[
                    "questionLikes":questionData.questionLikes,
                    "questionText":questionData.questionText,
                    "questionTime":questionData.questionTime
                ]
            ]
            
            questionRef.updateData(questionlikes){ err in
                if let err = err {
                    print("Error adding questionLikes document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
    
    //★★★sortingするパート★★★//
    
    @IBAction func okButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortingView.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func sortingTypeA(_ sender: Any) {
        UserDefaults.standard.set("sortingTypeA", forKey: "sortingMode")
        typeACheckImageView.isHidden = false
        typeALabel.font = UIFont.boldSystemFont(ofSize: 17)
            
        typeBCheckImageView.isHidden = true
        typeBLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.fetchQuestions()
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortingView.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func sortingTypeB(_ sender: Any) {
        UserDefaults.standard.set("sortingTypeB", forKey: "sortingMode")
        typeACheckImageView.isHidden = true
        typeALabel.font = UIFont.systemFont(ofSize: 17)
        
        typeBCheckImageView.isHidden = false
        typeBLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.fetchQuestions()
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortingView.alpha = 0.0
        }, completion: nil)
    }

}
