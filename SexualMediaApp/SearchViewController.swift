//
//  SearchViewController.swift
//  SexualMediaApp
//
//  Created by 新 真大 on 2018/10/07.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage
import SVProgressHUD

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.text = ""
        }
    }
    
    
    var receiveCellViewModel:ArticleQueryData?
    
    let refreshControl = UIRefreshControl()

    var searchArticleArray:[ArticleQueryData] = []
    var preArticleArray:[ArticleQueryData] = []
    var conditions = [(ArticleQueryData) -> Bool]()
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.delegate = self
            searchBar.showsCancelButton = true
            searchBar.placeholder = "区切り文字は半角スペースで"
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 200
            tableView.register(R.nib.listCell) //なんか謎のエラー<Cannot invoke 'register' with an argument list of type '(_R.nib._ListCell)'>が出るようになったので、R.swiftを使わないで書く方法へ以降
            //tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        }
    }
    
    //var viewModel = NewsSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //以下はClip記事のnavigationControllerの設定をコピーしてみた。
        //→searchは解決！何が原因だったのだろう…
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "記事を探す"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() //nill
        navigationController?.navigationBar.isTranslucent = true //こいつが原因の模様
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func initSetting() {
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(){
        searchBarSearchButtonClicked(searchBar) //デリゲートメソッドを関数の中に持ってこれるのね。
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchArticleArray.removeAll()
        
        self.view.endEditing(true)
        
        if let word = searchBar.text {
            if(word == "") {
                tableView.reloadData()
                return
            } else if word.contains(" ") {
                let words:[String] = word.components(separatedBy: " ")
                searchFetchArticleData(searchWords:words)
                SVProgressHUD.show()
                print(words)
            } else {
                searchFetchArticleData(searchWords:[word])
                SVProgressHUD.show()
            }
        }
    }
    
//★★★★★★★★★★Firebaseからデータを取ってくる★★★★★★★★★★★//
    func searchFetchArticleData(searchWords:[String]) {
        
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("articleData")
            let uid = user.uid
            //.order(by: "likesCount", descending: false) //order(by:)を使うと、取得する記事数が限られるらしい。
            ref.addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.searchArticleArray = []
                    self.preArticleArray = [] //こっちも初期化しないと増えていってしまう。
                    self.conditions = [(ArticleQueryData) -> Bool]() //こっちも初期化しないと、検索するたびにconditionsが増えていってしまうらしい。
                    
                    
                    for document in querySnapshot!.documents {
                        
                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
                        print("title:",articleData.titleStr)
                        self.preArticleArray.insert(articleData, at: 0)
                        self.preArticleArray.sort(by: {$0.likes .count > $1.likes.count}) //昇順にソート
                    }
                    //preArticleArrayの中に14記事入るはずが、11記事しか入っていないように見える。いくつかの記事が取得できていない…？
                    
                    print("self.preArticleArray：",self.preArticleArray)
                    print("searchWords",searchWords)
                   //preArticleArrayの要素一つ一つに対してcondition（Bool）がある。elementがwordを含んでいたらTrueになる。
                    //var conditions = [(ArticleQueryData) -> Bool]()における、(ArticleQueryData)の部分が$0に入ってくる。
                    for word in searchWords {
                        print("word",word)
                        //OR条件のクロージャーをArrayとしておいている
                        self.conditions.append { $0.titleStr.contains(word) || $0.summary.contains(word) || $0.tags!.contains(word) }
                        
                    }
                    
                    
                    self.searchArticleArray = self.preArticleArray.filter { article in
                        self.conditions.reduce(true) { $0 && $1 (article) }
                    }
                    print("self.searchArticleArray：",self.searchArticleArray)
                    
                    //reduceでは何度も処理がループする
                    //(true)は初期値で、$0に最初に入る値。
                    //conditions[0]が$1に入り、$0 = $0 && $1といった処理が順々に行われていく。
                    //今回の場合は、検索文字が3つでも、articleの文字に全て含まれれば、conditions = [true,true,true]といった感じになるはず。
                    //3つ目の検索文字がarticleの文字に含まれない場合、conditions = [true,true,false]という感じになる。
                    //reduceのところの処理は、conditionsの配列中にfalseが一つでもあった瞬間に、畳み込みから外れることになる。
                    //処理自体はとても素晴らしい。増えてしまう問題の根本は別のところにあるようだ。
                    
                    if self.searchArticleArray.isEmpty {
                        self.resultLabel.text = "検索条件に一致する記事は見つかりませんでした。"
                    }
                    
                    let before = self.tableView.contentOffset.y
                    self.tableView.reloadData()
                    let after = self.tableView.contentOffset.y
                    
                    if before > after {
                        self.tableView.contentOffset.y = before
                    }
                    
                    SVProgressHUD.dismiss()
                }
            }
        
        }
        
        /*
        print("funcが呼ばれたよ")
        if Auth.auth().currentUser != nil {
            
            if self.observing == false {
                let articlesRef = Database.database().reference().child(Const.ArticlePath)
                
                articlesRef.observe(.childAdded, with: {snapshot in
                    //observeSingleEventは、元々のやり方とは合わなかったようだ。どういうわけかはよくわからない。

                    //ArticleDataクラスを生成して受け取ったデータを設定する。
                    if let uid = Auth.auth().currentUser?.uid {
                        let searchArticleData = ArticleData(snapshot: snapshot, myId: uid)
                        //print("articleData:" + "\(searchArticleData)")
                        if searchWords.count == 1 {
                            if searchArticleData.titleStr!.contains(searchWords[0]) ||  searchArticleData.summary!.contains(searchWords[0])||searchArticleData.tags!.contains(searchWords[0]){
                                print("D")
                                if self.searchArticleArray.count < 30 { //検索記事も30以下ということで。
                                    self.searchArticleArray.insert(searchArticleData, at: 0)
                                }
                            }
                        } else if searchWords.count == 2 {
                            if searchArticleData.titleStr!.contains(searchWords[0]) ||  searchArticleData.summary!.contains(searchWords[0])||searchArticleData.tags!.contains(searchWords[0]){
                                if searchArticleData.titleStr!.contains(searchWords[1]) || searchArticleData.summary!.contains(searchWords[1])||searchArticleData.tags!.contains(searchWords[1]) {
                                    if self.searchArticleArray.count < 30 { //検索記事も30以下ということで。
                                        self.searchArticleArray.insert(searchArticleData, at: 0)
                                    }
                                }
                            }
                        } else if searchWords.count == 3 {
                            if searchArticleData.titleStr!.contains(searchWords[0]) ||  searchArticleData.summary!.contains(searchWords[0])||searchArticleData.tags!.contains(searchWords[0]){
                                if searchArticleData.titleStr!.contains(searchWords[1]) || searchArticleData.summary!.contains(searchWords[1])||searchArticleData.tags!.contains(searchWords[1]){
                                    
                                    if searchArticleData.titleStr!.contains(searchWords[2]) || searchArticleData.summary!.contains(searchWords[2])||searchArticleData.tags!.contains(searchWords[2]){
                                        if self.searchArticleArray.count < 30 { //検索記事も30以下ということで。
                                            self.searchArticleArray.insert(searchArticleData, at: 0)
                                        }
                                    }
                                }
                            }
                        } else if searchWords.count == 4 {
                            if searchArticleData.titleStr!.contains(searchWords[0]) ||  searchArticleData.summary!.contains(searchWords[0])||searchArticleData.tags!.contains(searchWords[0]){
                                if searchArticleData.titleStr!.contains(searchWords[1]) || searchArticleData.summary!.contains(searchWords[1])||searchArticleData.tags!.contains(searchWords[1]){
                                    
                                    if searchArticleData.titleStr!.contains(searchWords[2]) || searchArticleData.summary!.contains(searchWords[2])||searchArticleData.tags!.contains(searchWords[2]){
                                        if searchArticleData.titleStr!.contains(searchWords[3]) || searchArticleData.summary!.contains(searchWords[3])||searchArticleData.tags!.contains(searchWords[3]){
                                                if self.searchArticleArray.count < 30 { //検索記事も30以下ということで。
                                                self.searchArticleArray.insert(searchArticleData, at: 0)
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            self.resultLabel.text = "検索キーワードが5つ以上のようです。\n4つ以下に減らして再度お試しください。"
                            SVProgressHUD.dismiss()
                            print("E")
                            return
                        }
                        //一応このシンプルな方法で検索が実現できた。
                        
                        
                        //print(self.articleArray)
                        // TableViewを再表示する
                        if self.searchArticleArray.count == 0 {
                            self.resultLabel.text = "該当する検索結果がりませんでした。\n他のキーワードで再度お試しください。\n\nまた、単語と単語の間を半角スペース以外で\n区切るとうまく検索できませんので\nご注意ください。"
                        } else {
                            self.resultLabel.text = ""
                        }
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        
                    }
                })
                articlesRef.observe(.childChanged, with: { snapshot in
                    if let uid = Auth.auth().currentUser?.uid {
                        let searchArticleData = ArticleData(snapshot: snapshot, myId: uid)
                        
                        var index: Int = 0
                        for article in self.searchArticleArray {
                            if article.id == searchArticleData.id {
                                index = self.searchArticleArray.index(of: article)!
                                break
                            }
                        }
                        //差し替えるために一度削除
                        self.searchArticleArray.remove(at: index)
                        //削除したところに更新済みのデータを追加
                        self.searchArticleArray.insert(searchArticleData, at:index)
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                })
                
                observing = false
                
            }/* else { //うわ。一度消去される現象にまた悩まされた。
                if observing == true {
                    searchArticleArray = []
                    tableView.reloadData()
                    Database.database().reference().removeAllObservers()
                    
                    observing = false
                }
            }*/
     }*/
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.resultLabel.text = ""
        searchArticleArray.removeAll()
        tableView.reloadData()
        SVProgressHUD.dismiss()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultLabel.text = ""
    }
    
    
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    //★★★★★★★★★テーブルビューの設定★★★★★★★★★//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArticleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()} //なんか謎のエラー<Cannot convert value of type '_R.nib._ListCell' to expected argument type 'String'>が出るようになったから、R.nib.listCellを使わない形式へ。
        cell.setCellInfo(articleData: searchArticleArray[indexPath.row])
        cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapされました")
        let cellViewModel = searchArticleArray[indexPath.row]
        fromSearchToSummaryView(giveCellViewModel: cellViewModel)
    }
    
    func fromSearchToSummaryView(giveCellViewModel:ArticleQueryData) {
        let giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleButton(sender:UIButton, event:UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = searchArticleArray[indexPath!.row]
        
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
    

   // ★★★★★★searchの古いコード★★★★★★
    /*
    func searchFetchCellViewModell(searchWord:String) {
        if
            self.searchCellViewModel = ListCellViewModel()
        self.searchCellViewModel_Array = [ListCellViewModel]()
        
        let ref = Database.database().reference()
        ref.child("CellViewModel").observeSingleEvent(of: .value) { (snap,error) in
            let cellViewModelSnap = snap.value as? [String:NSDictionary]
            if cellViewModelSnap == nil {
                return //returnが押されるとそこで終了してしまう可能性があるな。
            }
            //print(cellViewModelSnap)
            for(_,cell) in cellViewModelSnap!{
                self.searchCellViewModel = ListCellViewModel()//これをしておかないと、同じCellが表示されてしまうみたい…？理由はなんでだろうね…
                
                if let summary = cell["summary"] as? String{
                    self.searchCellViewModel.summary = summary
                }else{self.searchCellViewModel.summary = ""}
                
                if let titleStr = cell["titleStr"] as? String{
                    self.searchCellViewModel.titleStr = titleStr
                }else{self.searchCellViewModel.titleStr = ""}
                
                if let articleUrl = cell["articleUrl"] as? String{
                    self.searchCellViewModel.articleUrl = articleUrl
                }else{self.searchCellViewModel.articleUrl = ""}
                
                if let genreName = cell["genreName"] as? String{
                    self.searchCellViewModel.genreName = genreName
                }else{self.searchCellViewModel.genreName = ""}
                
                if let sourceName = cell["sourceName"] as? String{
                    self.searchCellViewModel.sourceName = sourceName
                }else{self.searchCellViewModel.sourceName = ""}
                
                if let date = cell["date"] as? String {
                    self.searchCellViewModel.date = date
                } else {self.searchCellViewModel.date = ""}
                
                if let imageUrl = cell["imageUrl"] as? String {
                    self.searchCellViewModel.imageUrl = imageUrl
                } else {self.searchCellViewModel.imageUrl = ""}
                print(self.searchCellViewModel.imageUrl)
                
                if let clipDate = cell["clipDate"] as? Date {
                    self.searchCellViewModel.clipDate = clipDate
                } else {self.searchCellViewModel.clipDate = Date()}
                print(self.searchCellViewModel.clipDate)
                
                if let clipSumNumber = cell["clipSumNumber"] as? Int {
                    self.searchCellViewModel.clipSumNumber = clipSumNumber
                } else {self.searchCellViewModel.clipSumNumber = 0}
                
                
                if self.searchCellViewModel.titleStr.contains(searchWord) || self.searchCellViewModel.summary.contains(searchWord) {
                    self.searchCellViewModel_Array.append(self.searchCellViewModel)
                }
            }
            self.tableView.reloadData()
        }
    }*/
    
    
    
    
    /*
    /// 入力されたテキストから記事を検索する
    func searchText() {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            return
        }
        viewModel.searchWord = text
        SVProgressHUD.show()
        viewModel.reload(word: text, completion: { [weak self] in
            guard let `self` = self else { return }
            self.nonArticleView.isHidden = self.viewModel.isNonArticleViewHidden
        })
    }
 */

}


/*
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
 
    cell.selectionStyle = .none //ハイライトを消す
    cell.backgroundColor = UIColor.clear
    //cell.textLabel?.text = searchResult[indexPath.row]
 
    cell.textLabel?.text = searchCellViewModel_Array[indexPath.row].titleStr
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell.textLabel?.textColor = UIColor.black
 
    cell.detailTextLabel?.text = searchCellViewModel_Array[indexPath.row].summary
    cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    cell.detailTextLabel?.textColor = UIColor.black
 
    let urlStr = searchCellViewModel_Array[indexPath.row].imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    if urlStr != "" {
    let url:URL = URL(string: urlStr!)!
    cell.imageView?.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholder.png"))
    } else if urlStr == "" {
    cell.imageView?.image = UIImage(named: "placeholder.png")
    } else {
    cell.imageView?.image = UIImage(named: "placeholder.png")
    }
    return cell
 }
 */

