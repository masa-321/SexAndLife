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
    //blockしてるユーザーのID:Stringが格納される配列を宣言
    var receivedBlockedUserIds:[String] = []
   
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
            
            print("receivedBlockedUserIds",self.receivedBlockedUserIds)
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
    }

    
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
        
        //コメント済みのアラート
        let title2 = "コメント済みです"
        let message2 = "コメントを再編集する際は、自身のコメントの右下の編集ボタンから編集できます"
        
        let alert2 = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
        let okAction2 = UIAlertAction(title: "はい" ,style: UIAlertAction.Style.default, handler :
        { (action:UIAlertAction) in
            
        })
        alert2.addAction(okAction2)
        
        if let user = Auth.auth().currentUser {
            if !user.providerData.isEmpty {
                for item in user.providerData {
                    if item.providerID == "facebook.com" {
                        if !receiveCellViewModel!.commenterIDs.contains(user.uid){
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
                        } else {
                            //すでに投稿していたケース。
                            self.present(alert2, animated: true, completion: nil)
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
                            //
                            //block中のユーザーのコメントを非表示に。blockedUserIdsにcommenterIDが"含まれていない"ことを条件としている
                            if commentData.commentedArticleID == self.receiveCellViewModel!.id! && !self.receivedBlockedUserIds.contains(commentData.commenterID!){
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
        } else if section == 1 { //Comment
            let headerView: UIView = UIView()
            //comment欄のheaderの大きさと色を設定
            headerView.frame.size = CGSize(width: view.frame.size.width, height: 60)
            headerView.backgroundColor = .white
            
            //headerに載せるUILabelを設定
            let headerLabel = UILabel()
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = headerView.frame.size.height
            headerLabel.frame.size = CGSize(width:screenWidth/2, height:screenHeight/2)
            headerLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
            if receiveCellViewModel!.isFAQ {
                headerLabel.text = "回答"
            } else {
                headerLabel.text = "補足"
            }
            headerLabel.textColor = .black
            headerLabel.font = UIFont.systemFont(ofSize: 25)
            headerLabel.textAlignment = NSTextAlignment.center
            
            //headerViewへ追加
            headerView.addSubview(headerLabel)
            
            //headerに載せるimageViewを設定
            let professionalImageView = UIImageView()
                professionalImageView.image = UIImage(named: "star")
                professionalImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
                professionalImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
                professionalImageView.translatesAutoresizingMaskIntoConstraints = false
            let doctorImageView = UIImageView()
                doctorImageView.image = UIImage(named: "star2")
                doctorImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
                doctorImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
                doctorImageView.translatesAutoresizingMaskIntoConstraints = false
            let youthProImageView = UIImageView()
                youthProImageView.image = UIImage(named: "star3")
                youthProImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
                youthProImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
                youthProImageView.translatesAutoresizingMaskIntoConstraints = false
            
            //headerに載せるLabelを設定
            let professionalDescriptionLabel = UILabel()
                professionalDescriptionLabel.text = "性の健康教育の実践家"
                professionalDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
                professionalDescriptionLabel.textColor = UIColor.darkGray
                professionalDescriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                professionalDescriptionLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
                professionalDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let doctorDescriptionLabel = UILabel()
                doctorDescriptionLabel.text = "医師"
                doctorDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
                doctorDescriptionLabel.textColor = UIColor.darkGray
                doctorDescriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                doctorDescriptionLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
                doctorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let youthProDescriptionLabel = UILabel()
                youthProDescriptionLabel.text = "ピア・エデュケーター"
                youthProDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
                youthProDescriptionLabel.textColor = UIColor.darkGray
                youthProDescriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                youthProDescriptionLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
                youthProDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            //headerViewへ載せる
            headerView.addSubview(professionalImageView)
            headerView.addSubview(doctorImageView)
            headerView.addSubview(youthProImageView)
            headerView.addSubview(professionalDescriptionLabel)
            headerView.addSubview(doctorDescriptionLabel)
            headerView.addSubview(youthProDescriptionLabel)
            
            //AutoLayout
            //まずはdoctorのAutoLayoutを設定（headerViewの縦の真ん中、）
            doctorImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            doctorDescriptionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            doctorImageView.trailingAnchor.constraint(equalTo: doctorDescriptionLabel.leadingAnchor, constant: 0).isActive = true
            doctorDescriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 10).isActive = true
            
            //残りのAutoLayoutの設定。X中心を揃え、その後上下の距離感を設定する
            professionalImageView.centerXAnchor.constraint(equalTo: doctorImageView.centerXAnchor).isActive = true
            youthProImageView.centerXAnchor.constraint(equalTo: doctorImageView.centerXAnchor).isActive = true
            professionalDescriptionLabel.centerXAnchor.constraint(equalTo: doctorDescriptionLabel.centerXAnchor).isActive = true
            youthProDescriptionLabel.centerXAnchor.constraint(equalTo: doctorDescriptionLabel.centerXAnchor).isActive = true
            
            professionalImageView.bottomAnchor.constraint(equalTo:doctorImageView.topAnchor, constant: 0.0).isActive = true
            professionalDescriptionLabel.bottomAnchor.constraint(equalTo:doctorDescriptionLabel.topAnchor, constant: 0.0).isActive = true
            youthProImageView.topAnchor.constraint(equalTo:doctorImageView.bottomAnchor, constant: 0.0).isActive = true
            youthProDescriptionLabel.topAnchor.constraint(equalTo: doctorDescriptionLabel.bottomAnchor, constant: 0.0).isActive = true
            
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
            //commentの数＋indexPath.row:0のコメント入力のCellの分で+1している
            return commentArray.count + 1
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
            
            if indexPath.row == 0 {
                let cell:CommentEmptyCell = tableView.dequeueReusableCell(withIdentifier: "CommentEmptyCell") as! CommentEmptyCell
                if receiveCellViewModel!.isFAQ {
                    cell.formLabel.text = "回答コメントを追加する"
                } else {
                    cell.formLabel.text = "補足コメントを追加する"
                }
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                cell.setCommentTableViewCellInfo(commentData: commentArray[indexPath.row - 1])
                //ここで親と紐つけている
                cell.myVC = self
                
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
        } else if indexPath.section == 1{ //Comment
            if indexPath.row == 0 {
                //以下の★〜★まではcommentButtonのコードを丸コピペ
                //★
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
                
                //コメント済みのアラート
                let title2 = "コメント済みです"
                let message2 = "コメントを再編集する際は、自身のコメントの右下の編集ボタンから編集できます"
                
                let alert2 = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
                let okAction2 = UIAlertAction(title: "はい" ,style: UIAlertAction.Style.default, handler :
                { (action:UIAlertAction) in
                    
                })
                alert2.addAction(okAction2)
                
                if let user = Auth.auth().currentUser {
                    if !user.providerData.isEmpty {
                        for item in user.providerData {
                            if item.providerID == "facebook.com" {
                                if !receiveCellViewModel!.commenterIDs.contains(user.uid){
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
                                } else {
                                    //すでに投稿していたケース。
                                    self.present(alert2, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        //Facebook連携済みではなかったケース
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                //★
            } else {
                //これいる？？
                let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            }
            
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
        
        let commentData = commentArray[indexPath!.row - 1] //最初の１つ目のCellは入力欄になったので-1して整える
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
                        index = articleData.likes.firstIndex(of: likeId)!
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
                        index = articleData.likes.firstIndex(of: likeId)!
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
        let commentData = commentArray[indexPath!.row - 1]//indexPath.rowの0は記入欄だから、1のズレを修正する必要あり。
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
                newCommenterIDs.remove(at: newCommenterIDs.firstIndex(of: user.uid)!)
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
        let commentData = commentArray[indexPath!.row - 1]//indexPath.rowの0は記入欄だから、1のズレを修正する必要あり。
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
        let commentData = commentArray[indexPath!.row - 1]//indexPath.rowの0は記入欄だから、1のズレを修正する必要あり。
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if commentData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in commentData.commentLikes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = commentData.commentLikes.firstIndex(of: likeId)!
                        
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
    
}

