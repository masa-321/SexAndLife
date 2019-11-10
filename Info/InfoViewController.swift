//
//  InfoViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/09.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import CTFeedback
import FirebaseAuth

//import CTFeedbackSwift エラーが起こるので、CTFeedbackをCarthageファイルから取り除いてみた。<https://qiita.com/y-some/items/85c2606928b0f1ef5d72>
import StoreKit //StoreKitを一度削除してみた。

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //var infoTitleBox = [String]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
            tableView.bounces = false
            //とりあえず高さを317に設定しておく。これだと余分な線が入らないようだ。
            
        }
    }
    
    
    
    //お問い合わせView
    var feedbackViewController: UINavigationController?
    
    //ViewModel
    var viewModel = InfoViewModel()
    
    //セルの高さ
    var heightAtIndexPath = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        viewModel.bind {
            DispatchQueue.mainSyncSafe { [weak self] in
                guard let `self` = self else { return }
                self.tableView.reloadData()
                
            }
        }
        initSetting()
        
        
       
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
        //tableViewの高さを初めから64下げた。また、Adjust ScrollView Insetsのチェックは入れた。そしたら黒い部分が消えた。
        //下の３つを入れた。これのせいとは考えにくいが、たまにインデントが下がる。これはおかしい。Adjust ScrollView Insetsのチェックを再度外した。すると黒い部分がまた現れる。summaryViewで見だしてから再度見るとちょうど良い感じになる。どちらにせよ固定的ではない。なぜ？
        //とりあえず、上のようにnilにして下のようにbarTintColor.whiteにして実態を確保。あと黒い影対策として、Adjust ScrollView Insetsのチェック。infoは基本開かないだろうから、とりあえずはこれでよし。
        navigationItem.title = "インフォメーション"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        //navigationController?.navigationBar.isTranslucent = true
        /*
        navigationController?.navigationBar.shadowImage = nil
        
        
        navigationController?.navigationBar.alpha = 0
        
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //レビュー促進ダイアログはなし
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.infoCellViewModel.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        //return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cellViewModel = viewModel.infoCellViewModel[indexPath.row] as? InfoCellViewModel {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.infoCell, for: indexPath)  else { return UITableViewCell() }
            cell.viewModel = cellViewModel
        /*
        guard let cell = UITableView().dequeueReusableCell(withIdentifier: "InfoCell") as? InfoCell else { return UITableViewCell()}
            cell.viewModel = cellViewModel
            //R.swiftを使用したところ、項目が表示されるようになったtので、この書き方はどこかおかしかったようだ。
        */
            //cell.delegate = self delegateは使っていないから関係ないと思われる。
            print(cell)
            return cell
        }
        
        return UITableViewCell()
    }
    
    //let reviewViewController = UIViewController()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? InfoCell,let viewModel = cell.viewModel{
            switch viewModel.type {
            case .profile:
                let profileViewController:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
                if let user = Auth.auth().currentUser {
                    profileViewController.receivedUserId = user.uid
                }
                
                self.navigationController?.pushViewController(profileViewController, animated: true)
                //性別、年齢層//プロフィール写真、カバー写真紹介文など。NewsPicks参考
            case .socialNetwork:
                let socialNetworkViewController:SocialNetworkViewController = self.storyboard?.instantiateViewController(withIdentifier: "SocialNetwork") as! SocialNetworkViewController
                self.navigationController?.pushViewController(socialNetworkViewController, animated: true)
                break //socialNetwork()
                //FacebookとTwitter。NewsPicks参考
            /*case .notification:
                break //frequentQA()
                //グノシーみたいな感じにしよう。
                //付け足したものの、まだ必要ないんじゃないか。プロフィールページは必要だと思うけれど。コメント機能を実装するのであれば…。
            */
            case .inquiry:
                /*
                let configuration = FeedbackConfiguration(toRecipients: ["matarashi@gmail.com"], usesHTML: true)
                let controller    = FeedbackViewController(configuration: configuration)
                navigationController?.pushViewController(controller, animated: true)*/
                if let navigationController = feedbackViewController {
                    present(navigationController, animated: true, completion: nil)
                }
            /*
            case .review:
                let rv = reviewViewController
                self.navigationController?.pushViewController(rv, animated: true)
                //present(rv, animated: true, completion: nil)*/

            case .privacyPolicy:
                let privacyPolicyViewController:PrivacyPolicyViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicy") as! PrivacyPolicyViewController
                self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
            case .licenseInfo:
                let licenceViewController:LicenceViewController = self.storyboard?.instantiateViewController(withIdentifier: "Licence") as! LicenceViewController
                self.navigationController?.pushViewController(licenceViewController, animated: true)
                
            }
        }
    }
    
    func initSetting() {
        
        //viewModel作成
        viewModel.createCellViewModel()
        
        
        
        //お問い合わせView作成
        if let viewController = CTFeedbackViewController(topics: CTFeedbackViewController.defaultLocalizedTopics(), localizedTopics: ["不具合報告","質問","要望","その他"]) {
            viewController.toRecipients = ["matarashi0321@gmail.com"/*Bundle.Mail(key: .inquiry)*/]
            viewController.useHTML = true
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.navigationBar.barTintColor = .white //背景色だった。darkGreyで上手くいかなかったのは、navigationbarの薄める設定を削除していたから…
            navigationController.navigationBar.tintColor = .black //darkGreyで透明に見えたのは、barTintColorと一緒の色だったからだとしたら…仮説は正しかった。
            feedbackViewController = navigationController
        }
        
    }

}
