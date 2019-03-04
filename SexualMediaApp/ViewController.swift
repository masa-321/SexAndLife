//
//  ViewController.swift
//  SexualMediaApp
//
//  Created by 新 真大 on 2018/10/04.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//追加したときは、coverflowContents = Coverflow.getSampleData() //ここで数を決めている。

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FSPagerView
import SVProgressHUD

class InitialNavigationController: UINavigationController {
    
}

class ViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    //画面遷移時に渡すviewCellModelの用意
    //var giveCellViewModel = ListCellViewModel()
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var themeLabelRight: UILabel!
    @IBOutlet weak var themeLabelLeft: UILabel!
    var themeLabel_Array = [String]()
    
    //まずはcontrollerArrayの中身の型を決めて、初期化する。これでタンスができた状態になる
    var controllerArray : [UIViewController] = []
    let controller1:Media1ViewController = Media1ViewController()
    let controller2:Media2ViewController = Media2ViewController()
    let controller3:Media3ViewController = Media3ViewController()
    let controller4:Media4ViewController = Media4ViewController()
    let controller5:Media5ViewController = Media5ViewController()
    let controller6:Media6ViewController = Media6ViewController()
    let controller7:Media7ViewController = Media7ViewController()
    let controller8:Media8ViewController = Media8ViewController()
    
    //起動画面のアニメーションで用いる。
    var launchImageView = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //起動画面のアニメーションの設定(LaucnImageと全く同じ配置で画像を配置)
        let image:UIImage = UIImage(named: "LaunchImageSet")!
        launchImageView.image = image
        launchImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height)
        launchImageView.contentMode = .scaleAspectFill
        //UIScreen.mainScreen.bounds.width
        launchImageView.center = self.view.center
        self.view.addSubview(launchImageView)
        
        /*
        navigationBar.tintColor = .white
        //leftButton.tintColor = .black
        leftButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        leftButton.setImage(UIImage(named: "menu"), for: .normal)
        
        rightButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightButton.setImage(UIImage(named: "info"), for: .normal)
        */
        
        
        //ViewControllerの画面を宣言し、初期化する。
        controller1.masterViewPointer = self
        controller1.title = "新着"
        controllerArray.append(controller1)
        themeLabel_Array.append("新着")
        
        controller2.masterViewPointer = self
        controller2.title = "体のこと"
        controllerArray.append(controller2)
        themeLabel_Array.append("体のこと")
        
        controller3.masterViewPointer = self
        controller3.title = "避妊のこと"
        controllerArray.append(controller3)
        themeLabel_Array.append("避妊のこと")
        
        controller4.masterViewPointer = self
        controller4.title = "健康のこと"
        controllerArray.append(controller4)
        themeLabel_Array.append("健康のこと")
        
        controller5.masterViewPointer = self
        controller5.title = "LGBTQ+"
        controllerArray.append(controller5)
        themeLabel_Array.append("LGBTQ+")
        
        controller6.masterViewPointer = self
        controller6.title = "ライフプランニング"
        controllerArray.append(controller6)
        themeLabel_Array.append("ライフプランニング")
        
        
        controller7.masterViewPointer = self
        controller7.title = "パートナーシップ"
        controllerArray.append(controller7)
        themeLabel_Array.append("パートナーシップ")
        
        controller8.masterViewPointer = self
        controller8.title = "セックスのこと"
        controllerArray.append(controller8)
        themeLabel_Array.append("セックスのこと")
        
        //FSPagerViewの設定
        setupCoverFlowSliderView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        fetchConsulationData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            // viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let TutorialStoryboard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
                let loginViewController = TutorialStoryboard.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController, animated: true, completion: self.controller1.tableView.reloadData)
            }
        }
        //起動時のアニメーション
        UIView.animate(withDuration: 1,
                              delay: 1.5,
                            options: UIView.AnimationOptions.curveEaseOut,
                         animations: { () in
                            //self.launchImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            self.launchImageView.alpha = 0
                            }, completion: { (Bool) in
                                self.launchImageView.removeFromSuperview()
        })
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let InfoStoryboard: UIStoryboard = UIStoryboard(name: "Info", bundle: nil)
        let infoVc: InfoViewController = InfoStoryboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        show(infoVc, sender: nil)
        
        /*let navigationVc:NavigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
         navigationController?.pushViewController(navigationVc, animated: true)*/
    }
    
    @IBAction func questionButton(_ sender: Any) {
        let QuestionStoryboard: UIStoryboard = UIStoryboard(name: "Question", bundle: nil)
        let questionVc: QuestionViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        show(questionVc, sender: nil)
        /*
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
        
        
        
        */
    }
    

    

    //summaryViewへ移動する処理
    func summaryView(giveCellViewModel:ArticleQueryData) {
        let giveCellViewModel = giveCellViewModel
        //self.giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//★★★★★★★★★★★★consultation★★★★★★★★★★★★//
    var types:[String] = []
    var giveCategories:[String] = []
    var giveDescriptions:[String] = []
    
    var giveConsultationTypeA_Array:[Consultation] = []
    var giveConsultationTypeB_Array:[Consultation] = []
    var giveConsultationTypeC_Array:[Consultation] = []
    var giveConsultationTypeD_Array:[Consultation] = []
    var giveConsultationTypeE_Array:[Consultation] = []
    var giveConsultationTypeF_Array:[Consultation] = []
    
    /*var giveConsultationTypeA_Array:[[String : Any]] = []
    var giveConsultationTypeB_Array:[[String : Any]] = []
    var giveConsultationTypeC_Array:[[String : Any]] = []
    var giveConsultationTypeD_Array:[[String : Any]] = []
    var giveConsultationTypeE_Array:[[String : Any]] = []
    var giveConsultationTypeF_Array:[[String : Any]] = []*/
    
    
    func fetchConsulationData() {
        SVProgressHUD.show()
        types = ["typeA","typeB","typeC","typeD","typeE","typeF"]
        let db = Firestore.firestore()
        //giveCategories
        giveCategories = []
        db.collection("categories").document("vokXlkvJcce7W1YHvQNn").getDocument { (document, error) in
            if let document = document, document.exists {
                //print(type(of: document.data()))
                for i in 0..<document.data()!.count {
                    self.giveCategories.append(document.data()![self.types[i]] as! String)
                }
                //print(self.giveCategories) //categoriesの中に何が入っているかがこれでわかる。
                
            } else {
                print("Document does not exist")
            }
        }
        //giveDescriptions
        giveDescriptions = []
        db.collection("categories").document("LYx7WO9HNgL9MJ21i37n").getDocument { (document, error) in
            if let document = document, document.exists {
                //print(type(of: document.data()))
                for i in 0..<document.data()!.count {
                    self.giveDescriptions.append(document.data()![self.types[i]] as! String)
                }
                //print(self.Descriptions) //categoriesの中に何が入っているかがこれでわかる。
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        
        
        giveConsultationTypeA_Array = []
        giveConsultationTypeB_Array = []
        giveConsultationTypeC_Array = []
        giveConsultationTypeD_Array = []
        giveConsultationTypeE_Array = []
        giveConsultationTypeF_Array = []
        
        for type in types {
            db.collection("consultations").whereField("ConsultationType", isEqualTo: type).getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if type == "typeA" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeA_Array.append(consultation)
                        } else if type == "typeB" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeB_Array.append(consultation)
                            //self.giveConsultationTypeB_Array.append(document.data())
                        } else if type == "typeC" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeC_Array.append(consultation)
                            //self.giveConsultationTypeC_Array.append(document.data())
                        } else if type == "typeD" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeD_Array.append(consultation)
                            //self.giveConsultationTypeD_Array.append(document.data())
                        } else if type == "typeE" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeE_Array.append(consultation)
                            //self.giveConsultationTypeE_Array.append(document.data())
                        } else if type == "typeF" {
                            let consultation = Consultation(snapshot: document)
                            self.giveConsultationTypeF_Array.append(consultation)
                            //self.giveConsultationTypeF_Array.append(document.data())
                        }
                    }
                    //この中であれば、self.consultationTypeA_Array.countは数値を持つ。この外でも数値を持つためには、以下のようにreloadが必要。
                    //self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    @IBAction func consultationButton(_ sender: Any) {
        let ConsultationStoryboard: UIStoryboard = UIStoryboard(name: "Consultation", bundle: nil)
        let consultationVc: ConsultationViewController = ConsultationStoryboard.instantiateViewController(withIdentifier: "ConsultationViewController") as! ConsultationViewController
        print("giveCategories", giveCategories)
        
        
        consultationVc.receivedCategories = self.giveCategories
        consultationVc.receivedDescriptions = self.giveDescriptions
        consultationVc.receivedConsultationTypeA_Array = self.giveConsultationTypeA_Array
        consultationVc.receivedConsultationTypeB_Array = self.giveConsultationTypeB_Array
        consultationVc.receivedConsultationTypeC_Array = self.giveConsultationTypeC_Array
        consultationVc.receivedConsultationTypeD_Array = self.giveConsultationTypeD_Array
        consultationVc.receivedConsultationTypeE_Array = self.giveConsultationTypeE_Array
        consultationVc.receivedConsultationTypeF_Array = self.giveConsultationTypeF_Array
        
        if !giveCategories.isEmpty {
            navigationController?.pushViewController(consultationVc, animated: true)
        } else {
            let title = "ロード中です！"
            let message = "ロード完了まで数秒お待ちください"
            let okText = "OK"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okayButton)
            
            present(alert, animated: true, completion: nil)
        }
        
        
        //show(consultationVc, sender: nil)
        
        /*let navigationVc:NavigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
         navigationController?.pushViewController(navigationVc, animated: true)*/
    }
    
    

    
//★★★★★★★★★★★★modalView★★★★★★★★★★★★//
    
    @IBOutlet weak var coverFlowSliderView: FSPagerView!{
        didSet {
            self.coverFlowSliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
        
    fileprivate var coverflowContents: [Coverflow] = [] {
        didSet {
            self.coverFlowSliderView.reloadData()
        }
    }
    
    @IBOutlet weak var fsPagerViewBackGroundView: UIView!
    
    var thumbnail1:UIImage = UIImage()
    
    private func setupCoverFlowSliderView() {
        coverFlowSliderView.delegate = self
        coverFlowSliderView.dataSource = self
        coverFlowSliderView.isInfinite = true
        //coverFlowSliderView.itemSize = CGSize(width: 375, height: 515) //width:172に当初してた
        if UIScreen.main.bounds.size.height < 600 { //iPhone5, 5s, 5c, SEを想定：568
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height - 50) //SEは-50で良い感じになった。
        } else if UIScreen.main.bounds.size.height > 600 && UIScreen.main.bounds.size.height < 700 {//iPhone8：667
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height + 60) //140で合格 クリアしたはずだったんだが、どうもおかしい
        } else if UIScreen.main.bounds.size.height > 700 && UIScreen.main.bounds.size.height < 800 { //iPhone8 Plus：736
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height + 130)
        } else if UIScreen.main.bounds.size.height > 800 && UIScreen.main.bounds.size.height < 900 { //iPhoneX：812
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height + 160)
        } else if UIScreen.main.bounds.size.height > 900 {//iPad Mini、iPad Air：1024
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height + 400)
        }
        coverFlowSliderView.interitemSpacing = 250 //もともと16
        //coverFlowSliderView.automaticSlidingInterval = 20 //試してみる→autoモードだ。
        coverFlowSliderView.transformer = FSPagerViewTransformer(type: .overlap)
        coverflowContents = Coverflow.getSampleData() //ここで数を決めている。
        
        /*
        for i in 0...(coverflowContents.count - 1) {
            coverflowContents[i].thumbnail = thumbnail_Array[i]
        }*/
        
        //tableViewのscrollのインジケーターを消して、白いヘッダーをつければ重なりは克服できるのではないか
    }
    
    //以下の２つのボタンは、ボタンによる左右へのスライドの実現を行なっている。
    @IBAction func leftSideButton(_ sender: Any) {
        let prevIndex = coverFlowSliderView.currentIndex > 0 ? coverFlowSliderView.currentIndex - 1 : numberOfItems(in:self.coverFlowSliderView) - 1 //変数 =  条件式 ? (真の時の処理) : (偽の時の処理) ?は三項演算子の?
        coverFlowSliderView.scrollToItem(at: prevIndex, animated: true)
        //<https://github.com/WenchaoD/FSPagerView/issues/53>
    }
    
    @IBAction func rightSideButton(_ sender: Any) {
        let nextIndex = coverFlowSliderView.currentIndex + 1 < numberOfItems(in:self.coverFlowSliderView) ? coverFlowSliderView.currentIndex + 1 : 0
        coverFlowSliderView.scrollToItem(at: nextIndex, animated: true)
    }
    
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        //左右にスクロールした時に伴う処理を記述している。
        
        let maxIndex = controllerArray.count - 1
        
        if pagerView.currentIndex == maxIndex {
            themeLabelRight.text = themeLabel_Array[pagerView.currentIndex - 1]
            currentLabel.text = themeLabel_Array[pagerView.currentIndex]
            themeLabelLeft.text = themeLabel_Array[0]
        } else if pagerView.currentIndex == 0 {
            themeLabelRight.text = themeLabel_Array[maxIndex]
            currentLabel.text = themeLabel_Array[0]
            themeLabelLeft.text = themeLabel_Array[1]
        } else {
            themeLabelRight.text = themeLabel_Array[pagerView.currentIndex - 1]
            currentLabel.text = themeLabel_Array[pagerView.currentIndex]
            themeLabelLeft.text = themeLabel_Array[pagerView.currentIndex + 1]
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return coverflowContents.count
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.contentView.addSubview(controllerArray[index].view)
        //このcontrollerArrayを引数にしたaddSubviewによって、ViewControllerをFSPagerViewCellにすることができる！
        

        cell.contentView.layer.shadowOpacity = 0.4 //0.4
        cell.contentView.layer.opacity = 1 //0.86
            
        //cell.imageView?.image = coverflow.thumbnail
        //cell.imageView?.layer.cornerRadius = 4
        ///cell.imageView?.contentMode = .scaleAspectFit //scaleAspectFillは短い辺を合わせる。Fitは長い辺を合わせる
        ////.scaleAspectFit と組み合わせると、cornerRadiusがうまくいかない。
        //cell.imageView?.clipsToBounds = true
            
        return cell
    }

    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}
