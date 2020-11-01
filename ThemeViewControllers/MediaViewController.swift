//
//  MediaViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2020/09/29.
//  Copyright © 2020 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage
import SVProgressHUD

class MediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //TableViewの宣言
    var tableView:UITableView = UITableView()
    
    var articleDataArray:[ArticleQueryData] = []
    var observing = false
    
    let refreshControl = UIRefreshControl()
    
    var masterViewPointer:ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下が足りない問題はこれで応急処置ができそう。
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        tableView.backgroundColor = UIColor.white //謎の被る問題はこれであっけなく解決した。
        
        tableView.register(R.nib.listCell)
        tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "InitialTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "InitialTableViewCell")
        tableView.bounces = true
        
        let nib3 = UINib(nibName: "QuestionAnswerCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "QuestionAnswerCell")
        tableView.bounces = true
        
        let nib4 = UINib(nibName: "ChannelCell", bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: "ChannelCell")
        tableView.bounces = true
        
  
        self.view.addSubview(tableView)
        //tableView.estimatedRowHeight = 200 //まじかーーーーー！！これで解決かよ！<https://qiita.com/ShingoFukuyama/items/dc0d39bd69775f1d24a5>
        //デリゲートメソッドでまとめようと思う。
        tableView.rowHeight = UITableView.automaticDimension
        //didSetに組み込むと、今回の場合読み込まれなくなってしまうようだ。

        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refreshControl)
        
        tableView.showsVerticalScrollIndicator = false
        
        //SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.clear)//試してみた。なんか全てのページに適応になった。
        
        let initLabel = UILabel()
        
        view.addSubview(initLabel)
        
    }

    @objc func refresh(){
        //fetchArticleData()
        //fetchCellViewModell()
         //別途定義した、firebaseからデータを取ってくる関数
        tableView.reloadData()  //viewWillAppearの中でtableView.reloadData() ので、ここでは不要→viewWillAppearでなんとかなっていたLINEFirebaseBasicとは異なる。
        refreshControl.endRefreshing()//ぐるぐるを止める。こうしないとリロードが永遠に止まらなくなる。
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppearだよ")
        //なぜか初回は呼ばれないようだ。他のカラムから戻ってきたら呼ばれる。
        //fetchCellViewModell()
        //fetchArticleData(query)
        
    }
    
    //override func viewDidAppear(_ animated: Bool) {}
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func fetchArticleData(query:Query) {
        //ログイン済み（uidを取得済み）であることを確認
        
        if let user = Auth.auth().currentUser {
            let ref = query//Firestore.firestore().collection("articleData")
            let uid = user.uid
            
            ref.order(by: "date", descending: true).limit(to: 14).addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching articleData documents: \(err)")
                } else {
                    self.articleDataArray = []
                    for document in querySnapshot!.documents {
                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
                        self.articleDataArray.insert(articleData, at: 0)
                        //self.articleDataArray.sort(by: {$0.date > $1.date})
  
                    }
                    self.articleDataArray.reverse()
                    
                    print("articleData",self.articleDataArray)
                    let before = self.tableView.contentOffset.y
                    self.tableView.reloadData()
                    let after = self.tableView.contentOffset.y
  
                    if before > after {
                        self.tableView.contentOffset.y = before
                    }
                    
                    SVProgressHUD.dismiss()
                    
                   

                }
            } //ref.whereField...の終わり
        } //if let user = Auth.auth().currentUser {...の終わり
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if articleDataArray.count == 0 {
                return 1
            } else if articleDataArray.count > 0 && articleDataArray.count <= 7 {
                return articleDataArray.count
            } else {
                return 7
            }
        } else if section == 1 {
            if articleDataArray.count <= 7 {
                return 0
            } else {
                return articleDataArray.count - 7
            }
        } else if section == 2 {
            return 1 //5とかにすると、"チャンネル"のところがめっちゃダブることになる。
        } else{ //other
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 1500
        } else if indexPath.section == 1 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            if articleDataArray.count > 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
                print("indexPath.row",indexPath.row)
                print("articleDataArray.count:",articleDataArray.count)
                cell.setCellInfo(articleData: articleDataArray[indexPath.row])
                cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for:   UIControl.Event.touchUpInside)
                
                cell.selectionStyle = .none //ハイライトを消す
                cell.backgroundColor = UIColor.clear
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell") as! QuestionAnswerCell
            cell.setQuestionAnswerCellInfo(articleData: articleDataArray[indexPath.row + 7])
            cell.clipButton.addTarget(self, action: #selector(handleButton2(sender:event:)), for:   UIControl.Event.touchUpInside)
            cell.selectionStyle = .none
            return cell
            
        } else/* if indexPath.section == 3 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
             cell.setTitleLabel(string: "")
             cell.selectionStyle = .none
             return cell
             
             } else*/ {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! ChannelCell
                //cell.setCommentTableViewCellInfo()
                cell.selectionStyle = .none
                cell.channelButton1.addTarget(self, action: #selector(channelChange1(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton2.addTarget(self, action: #selector(channelChange2(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton3.addTarget(self, action: #selector(channelChange3(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton4.addTarget(self, action: #selector(channelChange4(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton5.addTarget(self, action: #selector(channelChange5(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton6.addTarget(self, action: #selector(channelChange6(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton7.addTarget(self, action: #selector(channelChange7(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.homeButton.addTarget(self, action: #selector(toHome(sender:event:)), for:   UIControl.Event.touchUpInside)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAtが呼ばれたよ")//これは呼ばれるらしい。
        if indexPath.section == 0 {
            if articleDataArray.count > 0{
                let selectCellViewModel = articleDataArray[indexPath.row]
                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
                
            } else {
                return
            }
        } else if indexPath.section == 1 {
            if articleDataArray.count > 7{
                let selectCellViewModel = articleDataArray[indexPath.row + 7]
                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
            }
        }
    }

    //以下はいいねボタンの処理。可能な限りコピペで使いまわしたい…
    @objc func handleButton(sender:UIButton, event:UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = articleDataArray[indexPath!.row]
        
        //ずれの原因はここより下にあるようだ。
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.firstIndex(of: likeId)!
                        break
                    }
                }
                articleData.likes.remove(at: index)
                print(articleData.likes)
                articleData.isLiked = false
                
            } else {
                articleData.likes.append(uid)
                print(articleData.likes)
                articleData.isLiked = true
                
            }
            //色も数値も変わるってことは、ローカル環境でのlikes配列の中に、uidが保存されているということ。問題は、それをFirebaseへアップできていない…。
            //視覚的に更新されていないだけで、実際は更新されていたというオチ。
            
            // 増えたlikesをFirebaseに保存する
            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
            let likes = ["likes": articleData.likes]

            articleRef.updateData(likes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            
            }
            //addSnapshotListenerにしてから、自動的に更新されるはずだったか、isLikedの反転とreloadDataが呼ばれないことが多発したため、あらかじめ付け加えることにした。
            tableView.reloadData()
            
        
        }
        
    }

    @objc func handleButton2(sender:UIButton, event:UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = articleDataArray[indexPath!.row + 7]
        
        //ずれの原因はここより下にあるようだ。
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.firstIndex(of: likeId)!
                        break
                    }
                }
                articleData.likes.remove(at: index)
                
            } else {
                articleData.likes.append(uid)
                
            }
            
            // 増えたlikesをFirebaseに保存する
            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
            let likes = [
                "likes": articleData.likes,
                "likesCount":articleData.likes.count
                ] as [String : Any]
            
            
            articleRef.updateData(likes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
  
    
    
    @objc func channelChange1(sender:UIButton, event:UIEvent) {
        //print("channelChange1が呼ばれたよ")
        //最初呼ばれなくてなんで？って思ったが、simulatorで所定の位置へ移動し、Debug＞View Debugging＞Capture View Hierarckyでで確認すると、Viewの大きさがおかしいことがわかった。constraintで大きさをと調整したらうまく動いた。
        //そもそもViewの大きさが怪しいのでは？って気づくことができたのは、幾たびもの実験の成果である。
        
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 1, animated: true)
        
    }
    @objc func channelChange2(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 2, animated: true)
        
    };
    @objc func channelChange3(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 3, animated: true)
        
    }
    @objc func channelChange4(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 4, animated: true)
        
    }
    @objc func channelChange5(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 5, animated: true)
        
    }
    @objc func channelChange6(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 6, animated: true)
        
    }
    @objc func channelChange7(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 7, animated: true)
    }
    
    @objc func toHome(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 0, animated: true)
        //self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}

