//
//  SummaryViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/08.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import SVProgressHUD

class SummaryViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var receiveCellViewModel:ArticleQueryData?
    
    var relatedArticleArray:[ArticleQueryData] = []
    var commentArray:[CommentData] = []
    
    //var relatedArticleCellViewModel = ListCellViewModel()
    //var relatedArticleCellViewModel_Array = [ListCellViewModel]()
    
    /*
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.delegate = self
            scrollView.bounces = true
            scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            scrollView.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height: 1600)
            //600がメイン+TableViewが1000
        }
    }*/
    
  
    
    /*
    @IBOutlet weak var webImage: UIImageView!{
        didSet{
            webImage.contentMode = UIView.ContentMode.scaleAspectFill //scaleAspectFit
            webImage.center.x = self.view.bounds.width/2
        }
    }*/
    
    /*
    @IBOutlet weak var tableHeight: NSLayoutConstraint! {
        tableHeight.constant = relatedTableView.contentSize.height
    }*/
    
    @IBOutlet weak var relatedTableView: UITableView! {
        didSet {
            relatedTableView.frame.size.height = 1000//375:200でTableViewCellを配置。関連記事は5つとして、200×5=1000
            relatedTableView.delegate = self
            relatedTableView.dataSource = self
            relatedTableView.register(R.nib.listCell)
            
            let nib2 = UINib(nibName: "SummaryCell", bundle: nil)
            relatedTableView.register(nib2, forCellReuseIdentifier: "SummaryCell")
            relatedTableView.bounces = true
            
            let nib3 = UINib(nibName: "CommentTableViewCell", bundle: nil)
            relatedTableView.register(nib3, forCellReuseIdentifier: "CommentTableViewCell")
            relatedTableView.bounces = true
            
            let nib4 = UINib(nibName: "CommentEmptyCell", bundle: nil)
            relatedTableView.register(nib4, forCellReuseIdentifier: "CommentEmptyCell")
            relatedTableView.bounces = true
            
            
            
            //relatedTableView.rowHeight = UITableView.automaticDimension
            
            /*
            relatedTableView.estimatedRowHeight = 1000
            
            //以下の２行はコメント欄を構築するに当たって書いていたコード。参考は、ReadMoreTextViewとTestComment
            //relatedTableView.estimatedRowHeight = 100
            //relatedTableView.estimatedRowHeight = 200
            relatedTableView.rowHeight = UITableView.automaticDimension
            
            //100や200だとピョンとするが、コメント欄はちゃんと動く。1000だとコメント欄がバグる。
             */
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        relatedArticleFetchCellViewModell()
        fetchComments()
        //print("受け取った記事のID:" + "\(self.receiveCellViewModel!.id)")
        //print("viewDidLoadで受け取った記事のID:" + "\(self.receiveCellViewModel!.id)")
        //print("viewDidLoadで受け取ったはずのIDたち:" + "\(self.receiveCellViewModel!.relatedArticleIDs)")
        
        /*
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateLabel.text = dateFormater.string(from: receiveDate)*/ //Date型から"yyyy/MM/dd HH:mm:ss"のString型へ
        
        //receiveImageUrl
        /*
        let urlStr = receiveCellViewModel!.imageUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if urlStr != "" {
            let url:URL = URL(string: urlStr)!
            webImage.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholder.png"))
        } else if urlStr == "" {
            webImage.image = UIImage(named: "placeholder.png")
        } else {
            webImage.image = UIImage(named: "placeholder.png")
        }*/
        
        //ボタンは後述
        // Do any additional setup after loading the view.
        
        relatedTableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        //navigationController?.navigationBar.tintColor = .white //戻るボタンは最初白
        self.navigationItem.title = "                              "//receiveCellViewModel!.titleStr //receiveTitleText
        //self.navigationItem.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .gray //clear
        navigationController?.navigationBar.tintColor = .gray  //clear
        navigationController?.navigationBar.alpha = 1 //0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //navigationController?.navigationBar.tintColor = .white
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.barTintColor = .white //なんだっけ
        //navigationController?.navigationBar.tintColor = .darkGray //戻るボタンの色は最終的に黒になる
        //navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
    }
    /*
    //コメント欄の実装のために追加。ReadMoreTextViewとTestCommentを参考。
    //あってもなくても関係がない？？
    override func viewDidLayoutSubviews() {//ViewDidLoadの後のライフサイクル…
        relatedTableView.reloadData()
    }*/
    
    
    //commentを起動させる
    @IBAction func commentButton(_ sender: Any) {
        let vc:CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        let title = "Facebook連携が必要です"
        let message = "コメント機能を利用するためにはFacebook連携を行う必要があります。ソーシャル連携のページへ移動しますか？"
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        //OK時の処理を定義。UIAlertAction.Styleがdefaultであることに注意
        let okAction = UIAlertAction(title: "はい" ,style: UIAlertAction.Style.default, handler :
        { (action:UIAlertAction) in
            //ここで処理の続行へ戻させる
             let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
             let socialNetworkViewController:SocialNetworkViewController = InfoStoryboard.instantiateViewController(withIdentifier: "SocialNetwork") as! SocialNetworkViewController
             self.navigationController?.pushViewController(socialNetworkViewController, animated: true)
             
            
        })
        alert.addAction(okAction)
        
        //キャンセル時の処理を定義。UIAlertAction.Styleがcancelであることに注意
        let cancelAction:UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
            //キャンセル時の処理を書く。ただ処理をやめるだけなら書く必要はない。
        })
        alert.addAction(cancelAction)
        
        
        if let user = Auth.auth().currentUser {
            if !user.providerData.isEmpty {
                for item in user.providerData {
                    if item.providerID == "facebook.com" {
                    Firestore.firestore().collection("users").document(user.uid).addSnapshotListener { querySnapshot, err in
                        if let err = err {
                            print("Error fetching documents: \(err)")
                            } else {
                            vc.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                                vc.receivedArticleData = self.receiveCellViewModel
                                self.present(vc, animated: true, completion: nil)
                                //self.navigationController?.pushViewController(vc, animated: true)
                            
                            }
                        }          
                    }
                }
            } else {
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    

    
    @IBAction func shareButton(_ sender: Any) {
        let shareString = "\(receiveCellViewModel!.titleStr)" + " | " + "#Sex&Life"
        var items = [] as [Any]
        if let shareUrl =  URL(string: receiveCellViewModel!.articleUrl) {
            items = [shareString, shareUrl] as [Any]
        } else {
            items = [shareString]
        }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height, width: 0, height: 0)
            //iPadではこれがないとクラッシュする。
        }
        
        let excludedActivityTypes: Array<UIActivity.ActivityType> = [
                //除外するもの
                // UIActivityType.addToReadingList,
                // UIActivityType.airDrop,
                // UIActivityType.assignToContact,
                // UIActivityType.copyToPasteboard,
                // UIActivityType.mail,
                // UIActivityType.message,
                // UIActivityType.openInIBooks,
                //UIActivity.ActivityType.postToFacebook,
                //UIActivity.ActivityType.postToFlickr,
                //UIActivity.ActivityType.postToTencentWeibo,
                //UIActivity.ActivityType.postToTwitter,
                // UIActivityType.postToVimeo,
                // UIActivityType.postToWeibo,
                // UIActivityType.print,
                // UIActivityType.saveToCameraRoll,
                // UIActivityType.markupAsPDF
        ]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    // scrollViewのデリゲートメソッド？→TableViewのoffsetを応用すればできそうに思える。
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //scrollView.contentOffset.yの値が、webImage.layer.frame.heightの値を超えるまでなだらかに色が変化し、最終的にtintColorはdarkGrey、setBackgroundImageは半透明になって欲しい。
        let alpha = scrollView.contentOffset.y/webImage.layer.frame.height
        
        
        if alpha <= 0{
            
            navigationController?.navigationBar.tintColor = .clear //戻るボタンの色は白.すでに上のviewDidAppearで宣言されている。
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //barの色は最初透明。すでに上のviewDidAppearで宣言されている。
            navigationController?.navigationBar.shadowImage = UIImage() //下の線も最初透明。すでに上のviewDidAppearで宣言されている。
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        }else if alpha < 1 && alpha > 0 {
            navigationController?.navigationBar.barTintColor = .white //なんだっけ
            navigationController?.navigationBar.tintColor = .darkGray //戻るボタンの色は最終的に黒になる
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.alpha = alpha
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
        } else if alpha >= 1 {
            navigationController?.navigationBar.barTintColor = .white //なんだっけ
            navigationController?.navigationBar.tintColor = .darkGray //戻るボタンの色は最終的に黒になる
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
        }
    }*/
    
//★★★★★★★★★★★★コメントを引っ張ってくるためのコード★★★★★★★★★★★★//
    func fetchComments() {
        if let user = Auth.auth().currentUser {
            //receiveCellViewModel!.id!がちゃんと記事のIDであれば、上手くいくはず。
            let uid = user.uid
            let ref = Firestore.firestore().collection("comments")
            //whereField(receiveCellViewModel!.id!, arrayContains: <#T##Any#>)
            ref.addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.commentArray = []
                    //print("呼ばれたよ。documentSnapshot?.documents:", querySnapshot?.documents)
                    //このsnapshotが指しているのは、key:articleID,value:mapの値だ。
                    for document in (querySnapshot?.documents)! {
                        //print("document.data()",document.data())
                        for snapshot in document.data() {
                            let commentData = CommentData(snapshot: snapshot,commenterID: document.documentID ,myId: uid)
                            if commentData.commentedArticleID == self.receiveCellViewModel!.id!{
                                self.commentArray.insert(commentData, at: 0)
                            }
                            self.commentArray.sort(by: {$0.commentLikes.count > $1.commentLikes.count}) //昇順にソート
                        }
                    }
                    self.relatedTableView.reloadData()
                    
                }
            }
        }
    }
    
    
    
//★★★★★★★★★★★★relatedDataを引っ張ってくるためのコード★★★★★★★★★★★★//
    
    func relatedArticleFetchCellViewModell() {
        //ログイン済み（uidを取得済み）であることを確認
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("articleData")
            let uid = user.uid
            
            ref.addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        let relatedArticleData = ArticleQueryData(snapshot: document, myId: uid)
                        
                        for id in self.receiveCellViewModel!.relatedArticleIDs{
                            if (relatedArticleData.id)! == id && self.relatedArticleArray.count < 5 {
                                self.relatedArticleArray.insert(relatedArticleData, at: 0)
                            }
                        }
                    }
                    
                    let before = self.relatedTableView.contentOffset.y
                    self.relatedTableView.reloadData()
                    let after = self.relatedTableView.contentOffset.y
                    
                    if before > after {
                        self.relatedTableView.contentOffset.y = before
                    }
                    SVProgressHUD.dismiss()
                    
                }
            }
        }
    }
    
    /*
    func relatedArticleFetchCellViewModell() {
        
        //relatedArticleIDs この中には5つIDがあって、そのIDに合致する記事を引っ張ってきたい。
        if Auth.auth().currentUser != nil {
            
            if self.observing == false {
            let articlesRef = Database.database().reference().child(Const.ArticlePath)
                articlesRef.observe(.childAdded, with: {snapshot in
                    //observeSingleEventは、元々のやり方とは合わなかったようだ。どういうわけかはよくわからない。
                    
                    //ArticleDataクラスを生成して受け取ったデータを設定する。
                    if let uid = Auth.auth().currentUser?.uid {
                        let relatedArticleData = ArticleData(snapshot: snapshot, myId: uid)
                        
                        for id in self.receiveCellViewModel!.relatedArticleIDs{
                            if (relatedArticleData.id)! == id/*"\((relatedArticleData.id)!)".contains("\(id)") */{
                                self.relatedArticleArray.insert(relatedArticleData, at: 0)
                            }
                        }
                        /*
                        if self.relatedArticleArray.count < 5 {
                            
                            var otherArticleDataIDs = [String]()
                            for id in self.receiveCellViewModel!.relatedArticleIDs {
                                if relatedArticleData.id != id {
                                    otherArticleDataIDs.append(relatedArticleData.id!)
                                }
                            }
                            print(otherArticleDataIDs)
                            
                            //ここで繰り返しをやると、合致しないidのセルがダブってしまう。
                            for id in otherArticleDataIDs {
                                if (relatedArticleData.id)! == id {
                                    self.relatedArticleArray.insert(relatedArticleData, at: 0)
                                }
                            }
                        }*/
                            //if self.relatedArticleArray.count < 5 { //関連記事は5つ以下ということで。
                            //
                    
                        //print(self.articleArray)
                        // TableViewを再表示する
                    self.relatedTableView.reloadData()
                    }
                })
                
                
                articlesRef.observe(.childChanged, with: { snapshot in
                    if let uid = Auth.auth().currentUser?.uid {
                        let relatedArticleData = ArticleData(snapshot: snapshot, myId: uid)
                        
                        var index: Int = 5
                        //変更があったCellのindexを取得しようとしている。
                        for article in self.relatedArticleArray {
                            if article.id == relatedArticleData.id {
                                index = self.relatedArticleArray.index(of: article)!
                                break
                            }
                        } //なかった場合、indexは0のまま…すると…relatedArticleArray[0]が消去され、relateArticleDataの[0]番目が差し込まれてしまうというわけだ。
                        if index < 5 { //現時点ではindexは4が最高だからこれで大丈夫なはず
                            self.relatedArticleArray.remove(at: index)
                            self.relatedArticleArray.insert(relatedArticleData, at:index)
                        }
                        
                        self.relatedTableView.reloadData()
                        //reloadDataを消すと、ピョンピョン移動は消えるかもしれないが、ボタンの色の変化も消えてしまう。
                        
                        /*
                        //差し替えるために一度削除
                        if index > 0 {
                        self.relatedArticleArray.remove(at: index)
                        //削除したところに更新済みのデータを追加
                        self.relatedArticleArray.insert(relatedArticleData, at:index) //おそらくこれのせいで、更新したときに、トップの記事が差し込まれることになる。
                        }*/
                        /*
                        self.relatedTableView.reloadData()
                        } else if index == 0 {
                            self.relatedTableView.reloadData()
                        } //これあかんやつや。最初の投稿のやつが削除されなくなってしまう。
                        
                        */
                    }
                })
                
                observing = true
                
            } else {
                if observing == true {
                    print("observingがtrueです")
                    relatedArticleArray = []
                    
                    relatedTableView.reloadData()
                    Database.database().reference().removeAllObservers()
                    
                    observing = false
                }
            }
        }
    }*/
        /*
        self.relatedArticleCellViewModel = ListCellViewModel()
        self.relatedArticleCellViewModel_Array = [ListCellViewModel]()
     
        let ref = Database.database().reference()
        ref.child("CellViewModel").observeSingleEvent(of: .value) { (snap,error) in
            let cellViewModelSnap = snap.value as? [String:NSDictionary]
            if cellViewModelSnap == nil {
                return //returnが押されるとそこで終了してしまう可能性があるな。
            }
            //print(cellViewModelSnap)
            for(_,cell) in cellViewModelSnap!{
                self.relatedArticleCellViewModel = ListCellViewModel()
     
                if let summary = cell["summary"] as? String{
                    self.relatedArticleCellViewModel.summary = summary
                }else{self.relatedArticleCellViewModel.summary = ""}
     
                if let titleStr = cell["titleStr"] as? String{
                    self.relatedArticleCellViewModel.titleStr = titleStr
                }else{self.relatedArticleCellViewModel.titleStr = ""}
     
                if let articleUrl = cell["articleUrl"] as? String{
                    self.relatedArticleCellViewModel.articleUrl = articleUrl
                }else{self.relatedArticleCellViewModel.articleUrl = ""}
     
                if let genreName = cell["genreName"] as? String{
                    self.relatedArticleCellViewModel.genreName = genreName
                }else{self.relatedArticleCellViewModel.genreName = ""}
     
                if let sourceName = cell["sourceName"] as? String{
                    self.relatedArticleCellViewModel.sourceName = sourceName
                }else{self.relatedArticleCellViewModel.sourceName = ""}
     
                if let date = cell["date"] as? String {
                    self.relatedArticleCellViewModel.date = date
                } else {self.relatedArticleCellViewModel.date = ""}
     
                if let imageUrl = cell["imageUrl"] as? String {
                    self.relatedArticleCellViewModel.imageUrl = imageUrl
                } else {self.relatedArticleCellViewModel.imageUrl = ""}
     
                if let clipDate = cell["clipDate"] as? Date {
                    self.relatedArticleCellViewModel.clipDate = clipDate
                } else {self.relatedArticleCellViewModel.clipDate = Date()}
                //print(self.relatedArticleCellViewModel.clipDate) →2018-10-26 14:43:54 +0000 こんな感じでコンソールに表示されていた。
     
                if let clipSumNumber = cell["clipSumNumber"] as? Int {
                    self.relatedArticleCellViewModel.clipSumNumber = clipSumNumber
                } else {self.relatedArticleCellViewModel.clipSumNumber = 0}
                
                if self.relatedArticleCellViewModel_Array.count < 5 {
                    self.relatedArticleCellViewModel_Array.append(self.relatedArticleCellViewModel)
                } //配列の数を5個までとする。
            }
            self.relatedTableView.reloadData()
        }*/
    
///★★★★★★★★★★★★rerelatedTableViewの設定★★★★★★★★★★★★//
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 //Homeボタンを入れるなら4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 { //Related
            return 60
        } else if section == 2  { //Comment
            return 60 
        } else if section == 3  { //ToHome
            return 0
        } else {
            return 0 //Summary
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 { //Related
            let headerView: UIView = UIView()
            headerView.frame.size = CGSize(width: view.frame.size.width, height: 60/*self.tableView(relatedTableView, heightForHeaderInSection: 1)*/)
            
            headerView.backgroundColor = .white
            let headerLabel = UILabel()
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = headerView.frame.size.height
            headerLabel.frame.size = CGSize(width:screenWidth/2, height:screenHeight/2)
            headerLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
            headerLabel.text = "関連コンテンツ"
            headerLabel.textColor = .black
            headerLabel.font = UIFont.systemFont(ofSize: 25)
            headerLabel.textAlignment = NSTextAlignment.center
            headerView.addSubview(headerLabel)
            return headerView
        } else if section == 1/*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/  { //Comment
            let headerView: UIView = UIView()
            headerView.frame.size = CGSize(width: view.frame.size.width, height: 60)
            headerView.backgroundColor = .white
            
            let headerLabel = UILabel()
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = headerView.frame.size.height
            headerLabel.frame.size = CGSize(width:screenWidth/2, height:screenHeight/2)
            headerLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
            if receiveCellViewModel!.isFAQ {
                headerLabel.text = "回答コメント"
            } else {
                headerLabel.text = "補足コメント"
            }
            
            headerLabel.textColor = .black
            headerLabel.font = UIFont.systemFont(ofSize: 25)
            headerLabel.textAlignment = NSTextAlignment.center
            headerView.addSubview(headerLabel)
            
            
            
            return headerView
        } else if section == 3  { //ToHome
            return UIView()
        } else {
            return UIView() //Summary
        }
    }
    

    
    //estimatedHeightRorRowAtの使い方：[UITableViewのrowHeightやestimatedRowHeightに何を設定すると良いのか](https://qiita.com/masashi-sutou/items/bb8ac89c717dcbe56123)
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 934
        } else if indexPath.section == 1/*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/ {
            return /*UITableView.automaticDimension*/ 246
        //indexPath.sectionが0,1で1000が都合が良いのは、Cellの影響があるのではないか？
        } else if indexPath.section == 3 {
            return UITableView.automaticDimension
        } else { //related
            return 1000
            
        }
    }
 

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //Summary
            return 1
        } else if section == 1/*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/ { //Comment
            //return receiveCellViewModel!.commenterIDs.count //とりあえず
            return commentArray.count
        } else if section == 3 {//ToHome
            return 1
        }else { //Summary
            return relatedArticleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { //Summary
             ///*
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
            cell.setSummaryCellInfo(articleData: receiveCellViewModel!)
            cell.clipButton.addTarget(self, action:#selector(handleButton1(sender:event:)), for:  UIControl.Event.touchUpInside)
            cell.browseButton.addTarget(self, action:#selector(browseButton(sender:event:)), for:  UIControl.Event.touchUpInside)
            cell.sourceButton.addTarget(self, action: #selector(sourceButton(sender:event:)), for: UIControl.Event.touchUpInside)
            cell.selectionStyle = .none
            return cell
            //*/
            //return UITableViewCell()
            
        } else if indexPath.section == 1 /*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/{ //Comment
            
            if commentArray.isEmpty { //CommentEmptyCell
                //以下の処理式を書いたけれど、全く反応しない。printも呼ばれない。謎。delegeteだろうか。
                print("commentArrayは、Emptyです")
                let cell:CommentEmptyCell = tableView.dequeueReusableCell(withIdentifier: "CommentEmptyCell") as! CommentEmptyCell
                //cell.setCommentTableViewCellInfo(commentData: commentArray[indexPath.row])
                
                cell.selectionStyle = .none
                return cell
                
            } else {
                let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                cell.setCommentTableViewCellInfo(commentData: commentArray[indexPath.row])
                cell.profileButton.addTarget(self, action:#selector(junpToCommenterProfile(sender:event:)), for:  UIControl.Event.touchUpInside)
                //引数をどうやって渡せばいいのだ？commentArray[indexPath.row].commenterID。もしかしたら渡すことができないのかもしれない。であれば、likeと同じようにしてみるか。
                cell.likeButton.addTarget(self, action:#selector(likeButton(sender:event:)), for:  UIControl.Event.touchUpInside)
                cell.deleteButton.addTarget(self, action:#selector(deleteButton(sender:event:)), for:  UIControl.Event.touchUpInside)
                cell.editButton.addTarget(self, action:#selector(editButton(sender:event:)), for:  UIControl.Event.touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
            
            
            /*
            //コメント欄を構築するに当たって書いていたコード。参考は、ReadMoreTextViewとTestComment
            let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
            readMoreTextView.shouldTrim = !expandedCells.contains(indexPath.row) //expandedCellは初めに宣言する必要がある。
            readMoreTextView.setNeedsUpdateTrim()
            readMoreTextView.layoutIfNeeded()*/
            
            //cell.setCommentTableViewCellInfo()
            
            
            //移植
            //let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
            /*
            readMoreTextView.onSizeChange = { [unowned tableView, unowned self] r in
                let point = tableView.convert(r.bounds.origin, from: r)
                guard let indexPath = tableView.indexPathForRow(at: point) else { return }
                if r.shouldTrim {
                    self.expandedCells.remove(indexPath.row)
                } else {
                    self.expandedCells.insert(indexPath.row)
                }
                tableView.reloadData()
            }*/
            
            

            
        } else if indexPath.section == 3 { //ToHome
            let cell = UITableViewCell()
            cell.frame.size = CGSize(width: view.frame.size.width, height: 60)
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = cell.frame.size.height
            let cellLabel = UILabel()
            cellLabel.text = "ホーム画面に戻る"
            cellLabel.frame.size = CGSize(width:screenWidth/2, height:screenHeight/2)
            cellLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/2 - 7)
            cellLabel.textColor = .gray
            cellLabel.font = UIFont.systemFont(ofSize: 15) //25は"コメント"とかと大きさが同じだな。
            cellLabel.textAlignment = NSTextAlignment.center
            cell.addSubview(cellLabel)

            return cell
            
        } else { //related
            ///*
             guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
             cell.setCellInfo(articleData: relatedArticleArray[indexPath.row])
             cell.clipButton.addTarget(self, action:#selector(handleButton2(sender:event:)), for:  UIControl.Event.touchUpInside)
             return cell
             //*/
            //return UITableViewCell()
                
        }
    }

    //各indexPathのcellが表示される直前に呼ばれる
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
        if indexPath.section == 1/*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/ {
            //コメント欄を構築するに当たって書いていたコード。参考は、ReadMoreTextViewとTestComment.expandedCellsは上で宣言する必要があ
            let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
            readMoreTextView.onSizeChange = { [unowned tableView, unowned self] r in
                let point = tableView.convert(r.bounds.origin, from: r)
                guard let indexPath = tableView.indexPathForRow(at: point) else { return }
                if r.shouldTrim {
                    self.expandedCells.remove(indexPath.row)
                } else {
                    self.expandedCells.insert(indexPath.row)
                }
            tableView.reloadData()
            }
        }*/
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 { //Summary
            //relatedTableView.allowsSelection = false //これあると確かに反応しないけれど、ここタッチした後、他のSectionのTableViewCellも反応しなくなってしまうので一旦コメントアウト→cell.selectionStyle = .noneで代用して解決。
        } else if indexPath.section == 1/*本来2だが、Commentをrelatedの上にできるか確認するために一旦1へ。*/ { //Comment
            //コメント欄を構築するに当たって書いていたコード。参考は、ReadMoreTextViewとTestComment
            let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
           // let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
            //readMoreTextView.shouldTrim = !readMoreTextView.shouldTrim
            
        } else if indexPath.section == 3 { //ToHome
            let homeVc:ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
        } else { //Related
            let cellViewModel = relatedArticleArray[indexPath.row]
            fromRelatedArticleToSummary(giveCellViewModel: cellViewModel)
        }
    }
    
    
    func fromRelatedArticleToSummary(giveCellViewModel:ArticleQueryData) {
        let giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //★★★★★★★★★★★★コメントのプロフィールをタッチした時のコード★★★★★★★★★★★★//
    @objc func junpToCommenterProfile(sender:UIButton, event:UIEvent){
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.relatedTableView)
        let indexPath = relatedTableView.indexPathForRow(at: point)
        let commentData = commentArray[indexPath!.row]
        //print()
        
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
        let profileVc: ProfileViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        profileVc.receivedUserId = commentData.commenterID!
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
    //★★★★★★★★★★★★いいね!ボタンのコード★★★★★★★★★★★★//
    
    @objc func browseButton(sender:UIButton, event:UIEvent){
        guard let url = URL(string: receiveCellViewModel!.articleUrl) else {return}
        let title = receiveCellViewModel!.titleStr
        browse(URLRequest(url: url),titleStr: title)
    }
    
    @objc func sourceButton(sender:UIButton, event:UIEvent){
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let sourceViewController:SourceViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Source") as! SourceViewController
        sourceViewController.receiveData = receiveCellViewModel!.sourceName
        //let sourceName = receiveCellViewModel!.sourceName!
        //let title = receiveCellViewModel!.titleStr
      //
            
            self.navigationController?.pushViewController(sourceViewController, animated: true)
        /*
         let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
         let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         
         let profileViewController:ProfileViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
         let summaryViewController:SummaryViewController = MainStoryboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
         */
    }
    
    /*Facebookログインしている人をタップした時の処理
    @objc func sourceButton(sender:UIButton, event:UIEvent){
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
        let profileViewController:ProfileViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        
        //let sourceName = receiveCellViewModel!.sourceName!
        //let title = receiveCellViewModel!.titleStr
        self.navigationController?.pushViewController(profileViewController, animated: true)
        /*
         let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
         let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         
         let profileViewController:ProfileViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
         let summaryViewController:SummaryViewController = MainStoryboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
         */
    }*/
    
    
    
    func browse(_ request:URLRequest, titleStr:String) {
        let vc:BrowseViewController = self.storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
        vc.browseURLRequest = request
        vc.browsePageTitle = titleStr
        vc.receivedArticleData = receiveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleButton1(sender:UIButton, event:UIEvent) {
        //let touch = event.allTouches?.first
        //let point = touch!.location(in: self.tableView)
        //let indexPath = tableView.indexPathForRow(at: point)
        let articleData = receiveCellViewModel!//relatedArticleArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                //"likes"のなかに自分のIDがあれば、いいね済み→.isLiked=trueってこと。
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1 //これは初期値はあまり関係がない？
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.index(of: likeId)!
                        //いまなぜかIDが二つあるから、indexは複数の値を持つことになるぞ。
                        break
                    }
                }
                articleData.likes.remove(at: index)
                self.receiveCellViewModel!.isLiked = false
            } else {
                articleData.likes.append(uid)
                self.receiveCellViewModel!.isLiked = true
                //なんとかなったか…
            }
            // 増えたlikesをFirebaseに保存する
            let articleRef =  Firestore.firestore().collection("articleData").document(articleData.id!)
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
    
    @objc func handleButton2(sender:UIButton, event:UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.relatedTableView)
        let indexPath = relatedTableView.indexPathForRow(at: point)
        
        let articleData = relatedArticleArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.index(of: likeId)!
                        break
                    }
                }
                print("index", index)
                articleData.likes.remove(at: index)//2つ表示されていると、一気に2つ消えることになってバグるのか。
                articleData.isLiked = false //いいね押してもisLikedの変化がないもだいがあったから、これを付け加えてみた。
            } else {
                articleData.likes.append(uid)
                articleData.isLiked = true
            }
            
            // 増えたlikesをFirebaseに保存する
            let articleRef =  Firestore.firestore().collection("articleData").document(articleData.id!)
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
    //★★★CommentCellのSerectorのコード★★★//
    @objc func deleteButton(sender:UIButton, event:UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.relatedTableView)
        let indexPath = relatedTableView.indexPathForRow(at: point)
        let commentData = commentArray[indexPath!.row]
        let commentRef = Firestore.firestore().collection("comments").document(commentData.commenterID!)
        
        //アラートを宣言
        let title = "コメントを削除してもよろしいですか？"
        let message = ""
        let okText = "OK"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        /*
          reason: 'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
         */
        
        //OK時の処理を定義。UIAlertAction.Styleがdefaultであることに注意
        let okAction = UIAlertAction(title: "はい" ,style: UIAlertAction.Style.default, handler :
            { (action:UIAlertAction) in
            //ここで処理の続行へ戻させる
            //今回はFirestoreのコメントを削除
                commentRef.updateData([
                    self.receiveCellViewModel!.id: FieldValue.delete(),
                    ])  { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    
                    self.updateCommenterIDs()
                }
            }
            
        })
        alert.addAction(okAction)
        
        //キャンセル時の処理を定義。UIAlertAction.Styleがcancelであることに注意
        let cancelAction:UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
            //キャンセル時の処理を書く。ただ処理をやめるだけなら書く必要はない。
        })
        alert.addAction(cancelAction) //addActionなのね。
        
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func updateCommenterIDs() {
        if let user = Auth.auth().currentUser {
            //"articleData"コレクションの編集。commentの数を確認できるようにするため。
            var newCommenterIDs:[String] = receiveCellViewModel!.commenterIDs
            
            if newCommenterIDs.contains(user.uid) {
                newCommenterIDs.remove(at: newCommenterIDs.index(of: user.uid)!)
            }
            
            let includingNewCommenterData = [
                "commenterIDs":newCommenterIDs
            ]
            let ref2 = Firestore.firestore().collection("articleData").document(receiveCellViewModel!.id!)
            ref2.updateData(includingNewCommenterData) { err in
                if let err = err {
                    print("updateData(includingCommenterData) Error adding document: \(err)")
                } else {
                    //documentは必ず存在するから、アップデートのみの処理で良い。
                    print("updateData(includingCommenterData) Document successfully written!")
                }
            }
        }
    }
    
    @objc func editButton(sender:UIButton, event:UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.relatedTableView)
        let indexPath = relatedTableView.indexPathForRow(at: point)
        let commentData = commentArray[indexPath!.row]
        print("commentData.commentText：",commentData.commentText)
        
        let vc:CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        let title = "Facebook連携が必要です"
        let message = "コメント機能を利用するためにはFacebook連携を行う必要があります。"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        if let user = Auth.auth().currentUser {
            if !user.providerData.isEmpty {
                for item in user.providerData {
                    if item.providerID == "facebook.com" {
                        Firestore.firestore().collection("users").document(user.uid).addSnapshotListener { querySnapshot, err in
                            if let err = err {
                                print("Error fetching documents: \(err)")
                            } else {
                                vc.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                                vc.receivedArticleData = self.receiveCellViewModel
                                vc.postedCommentData = commentData
                                self.present(vc, animated: true, completion: nil)
                                //self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                        }
                    }
                }
            } else {
                self.present(alert, animated: true, completion: nil)
                
            }
        }

        
    }
    
    @objc func likeButton(sender:UIButton, event:UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.relatedTableView)
        let indexPath = relatedTableView.indexPathForRow(at: point)
        let commentData = commentArray[indexPath!.row]
        print("likeButtonが呼ばれたよ")
        print("touch",touch)
        print("point",point)
        print("indexPath",indexPath)
        print("commentData.commentLikes",commentData.commentLikes)
        /*
         touch Optional(<UITouch: 0x10359b650> phase: Ended tap count: 1 force: 0.133 window: <UIWindow: 0x1035229e0; frame = (0 0; 375 667); gestureRecognizers = <NSArray: 0x2805c7180>; layer = <UIWindowLayer: 0x280bb10c0>> view: <UIButton: 0x10ca1d210; frame = (30 141; 60 30); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x280cd46e0>> location in window: {76.5, 416.5} previous location in window: {76.5, 416.5} location in view: {46.5, 22.5} previous location in view: {46.5, 22.5})
         point (76.5, 1142.5)
         indexPath Optional([1, 0])
         */
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if commentData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in commentData.commentLikes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = commentData.commentLikes.index(of: likeId)!
                        
                        break
                    }
                }
                commentData.commentLikes.remove(at: index)
                print("removeが呼ばれた可能性がある。at:",index)
            } else {
                commentData.commentLikes.append(uid)
                print("appendが呼ばれた可能性がある。")
            }
            
            // 増えたlikesをFirebaseに保存する
            let commentRef = Firestore.firestore().collection("comments").document(commentData.commenterID!)
            let commentlikes = [
                receiveCellViewModel?.id:[
                    "commentLikes":commentData.commentLikes,
                    "commentText":commentData.commentText,
                    "commentTime":commentData.commentTime
                    ]
                ]
            //まぁなんとかなったと言えるかなぁ。全部上書きされるけれど、とりあえず支障は無い。
            
            commentRef.updateData(commentlikes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    
    /*
     @objc func handleButton(sender:UIButton, event:UIEvent) {
     print("DEBUG_PRINT: likeボタンがタップされました。")
     
     // タップされたセルのインデックスを求める
     let touch = event.allTouches?.first
     let point = touch!.location(in: self.tableView)
     let indexPath = tableView.indexPathForRow(at: point)
     
     // 配列からタップされたインデックスのデータを取り出す
     let articleData = articleArray[indexPath!.row]
     
     // Firebaseに保存するデータの準備
     if let uid = Auth.auth().currentUser?.uid {
     if articleData.isLiked {
     // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
     var index = -1
     for likeId in articleData.likes {
     if likeId == uid {
     // 削除するためにインデックスを保持しておく
     index = articleData.likes.index(of: likeId)!
     break
     }
     }
     articleData.likes.remove(at: index)
     } else {
     articleData.likes.append(uid)
     }
     // 増えたlikesをFirebaseに保存する
     let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
     let likes = ["likes": articleData.likes]
     articleRef.updateChildValues(likes)
     
     }
     
     }
     */
    
    
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fromRelatedArticleToSummary
        (giveTitleText: relatedArticleCellViewModel_Array[indexPath.row].titleStr,
         giveSummaryText: relatedArticleCellViewModel_Array[indexPath.row].summary,
         giveArticleUrl: relatedArticleCellViewModel_Array[indexPath.row].articleUrl,
         giveGenreName: relatedArticleCellViewModel_Array[indexPath.row].genreName,
         giveSorceName: relatedArticleCellViewModel_Array[indexPath.row].sourceName,
         giveDate: relatedArticleCellViewModel_Array[indexPath.row].date,
         giveImageUrl: relatedArticleCellViewModel_Array[indexPath.row].imageUrl)
    }
    
    /*func fromRelatedArticleToSummary(giveCellViewModel:ListCellViewModel) {
        self.giveCellViewModel = giveCellViewModel*/
        
    func fromRelatedArticleToSummary(giveTitleText:String, giveSummaryText:String, giveArticleUrl:String, giveGenreName:String, giveSorceName:String, giveDate:String, giveImageUrl:String){
        self.giveTitleText = giveTitleText
        self.giveSummaryText = giveSummaryText
        self.giveArticleUrl = giveArticleUrl
        self.giveGenreName = giveGenreName
        self.giveSorceName = giveSorceName
        self.giveDate = giveDate
        self.giveImageUrl = giveImageUrl
    
        let vc:SummaryViewController = storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveTitleText = giveTitleText
        vc.receiveSummaryText = giveSummaryText
        vc.receiveArticleUrl = giveArticleUrl
        vc.receiveGenreName = giveGenreName
        vc.receiveSorceName = giveSorceName
        vc.receiveDate = giveDate
        vc.receiveImageUrl = giveImageUrl
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /*
 func fromRelatedArticleToSummary(giveTitleText:String, giveSummaryText:String, giveArticleUrl:String, giveGenreName:String, giveSorceName:String, giveDate:String, giveImageUrl:String){
 self.giveTitleText = giveTitleText
 self.giveSummaryText = giveSummaryText
 self.giveArticleUrl = giveArticleUrl
 self.giveGenreName = giveGenreName
 self.giveSorceName = giveSorceName
 self.giveDate = giveDate
 self.giveImageUrl = giveImageUrl
 
 let vc:SummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
 vc.receiveTitleText = giveTitleText
 vc.receiveSummaryText = giveSummaryText
 vc.receiveArticleUrl = giveArticleUrl
 vc.receiveGenreName = giveGenreName
 vc.receiveSorceName = giveSorceName
 vc.receiveDate = giveDate
 vc.receiveImageUrl = giveImageUrl
 
 self.navigationController?.pushViewController(vc, animated: true)
 }
 */
    */

    
}

