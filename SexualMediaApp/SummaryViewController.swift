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
import FirebaseDatabase
import SVProgressHUD

class SummaryViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var receiveCellViewModel:ArticleData?
    
    var relatedArticleArray:[ArticleData] = []
    var request:URLRequest?
    var titleStr:String?
    var observing = false
    
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
            
            relatedTableView.estimatedRowHeight = 1000
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        relatedArticleFetchCellViewModell()
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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let shareString = "\(receiveCellViewModel!.titleStr!)" + " | " + "#sexualhealthmedia"
        var items = [] as [Any]
        if let shareUrl =  URL(string: receiveCellViewModel!.articleUrl!) {
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
    
//★★★★★★★★★★★★relatedDataを引っ張ってくるためのコード★★★★★★★★★★★★//

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
    }
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
        return 4
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
        if section == 1 { //Related
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
        } else if section == 2  { //Comment
            let headerView: UIView = UIView()
            headerView.frame.size = CGSize(width: view.frame.size.width, height: 60)
            headerView.backgroundColor = .white
            let headerLabel = UILabel()
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = headerView.frame.size.height
            headerLabel.frame.size = CGSize(width:screenWidth/2, height:screenHeight/2)
            headerLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
            headerLabel.text = "コメント"
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //Summary
            return 1
        } else if section == 2 { //Comment
            return 1 //とりあえず
        } else if section == 3 {//ToHome
            return 1
        }else { //Summary
            return relatedArticleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { //Summary
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
            cell.setSummaryCellInfo(articleData: receiveCellViewModel!)
            cell.clipButton.addTarget(self, action:#selector(handleButton1(sender:event:)), for:  UIControl.Event.touchUpInside)
            cell.browseButton.addTarget(self, action:#selector(browseButton(sender:event:)), for:  UIControl.Event.touchUpInside)
            cell.sourceButton.addTarget(self, action: #selector(sourceButton(sender:event:)), for: UIControl.Event.touchUpInside)
            cell.selectionStyle = .none
            return cell
            
            
            
        } else if indexPath.section == 2 { //Comment
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            cell.setCommentTableViewCellInfo()
            cell.selectionStyle = .none
            return cell
            
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
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
            cell.setCellInfo(articleData: relatedArticleArray[indexPath.row])
            cell.clipButton.addTarget(self, action:#selector(handleButton2(sender:event:)), for:  UIControl.Event.touchUpInside)
            
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 { //Summary
            //relatedTableView.allowsSelection = false //これあると確かに反応しないけれど、ここタッチした後、他のSectionのTableViewCellも反応しなくなってしまうので一旦コメントアウト→cell.selectionStyle = .noneで代用して解決。
        } else if indexPath.section == 2 { //Comment
            //relatedTableView.allowsSelection = false
        } else if indexPath.section == 3 { //ToHome
            let homeVc:ViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
        } else { //Related
            let cellViewModel = relatedArticleArray[indexPath.row]
            fromRelatedArticleToSummary(giveCellViewModel: cellViewModel)
        }
    }
    
    
    func fromRelatedArticleToSummary(giveCellViewModel:ArticleData) {
        let giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //★★★★★★★★★★★★いいね!ボタンのコード★★★★★★★★★★★★//
    
    @objc func browseButton(sender:UIButton, event:UIEvent){
        guard let url = URL(string: receiveCellViewModel!.articleUrl!) else {return}
        let title = receiveCellViewModel!.titleStr
        browse(URLRequest(url: url),titleStr: title!)
    }
    
    @objc func sourceButton(sender:UIButton, event:UIEvent){
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let sourceViewController:SourceViewController = InfoStoryboard.instantiateViewController(withIdentifier: "Source") as! SourceViewController
        sourceViewController.receiveData = receiveCellViewModel!.sourceName!
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
        self.request = request
        self.titleStr = titleStr
        let vc:BrowseViewController = self.storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
        vc.browseURLRequest = request
        vc.browsePageTitle = titleStr
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
            let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
            let likes = ["likes": articleData.likes]
            articleRef.updateChildValues(likes)
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
                articleData.likes.remove(at: index)//2つ表示されていると、一気に2つ消えることになってバグるのか。
            } else {
                articleData.likes.append(uid)
            }
            // 増えたlikesをFirebaseに保存する
            let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
            let likes = ["likes": articleData.likes]
            articleRef.updateChildValues(likes)
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

