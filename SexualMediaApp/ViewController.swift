//
//  ViewController.swift
//  SexualMediaApp
//
//  Created by 新 真大 on 2018/10/04.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//追加したときは、coverflowContents = Coverflow.getSampleData() //ここで数を決めている。

import UIKit
import Firebase
import FirebaseAuth
import FSPagerView

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
        
        if Auth.auth().currentUser != nil { //効果なし
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
            
            //FSPagerViewの設定
            setupCoverFlowSliderView()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            // viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: self.controller1.tableView.reloadData)
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

    //summaryViewへ移動する処理
    func summaryView(giveCellViewModel:ArticleData) {
        let giveCellViewModel = giveCellViewModel
        //self.giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
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
        if UIScreen.main.bounds.size.height < 600 { //iPhone5sを想定：568
            coverFlowSliderView.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.fsPagerViewBackGroundView.frame.size.height + 50) //50で合格
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
