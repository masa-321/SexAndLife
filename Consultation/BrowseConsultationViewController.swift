//
//  BrowseConsultationViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/25.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import SVProgressHUD

class BrowseConsultationViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var browseURLRequest:URLRequest!
    var browsePageTitle = ""
    var webView: WKWebView!
    var receivedArticleData:ArticleQueryData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if browseURLRequest.url != nil {
            let req = URLRequest(url:browseURLRequest.url!)
            webView.load(req)
            view.addSubview(webView)
            view.sendSubviewToBack(webView)
        }else {
            print("There is no URLRequest")
        }
        
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = browsePageTitle
        navigationController?.navigationBar.setBackgroundImage(UIImage()/*nil*/, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .gray  //clear
        navigationController?.navigationBar.alpha = 1 //0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Webのロード完了後に実行されるメソッド。WKNavigationDelegateのdelegateを通しておくことを忘れないこと
        SVProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
        let alertController = UIAlertController(title: "接続不良のようです", message: "また時間をおいてお試しください", preferredStyle: .alert)
        /*
         let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
         //キャンセル時の処理を書く。ただ処理をやめるだけなら書く必要はない。
         })*/
        
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler :{ (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        
        //alertControllerがiPadだとエラーになる問題を解決。
        if UIDevice.current.userInterfaceIdiom == .pad{
            let screenSize = UIScreen.main.bounds
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        //alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var safari: UIBarButtonItem!{
        didSet {
            safari.tintColor = .gray
        }
    }
    
    @IBAction func safari(_ sender: Any) {
        if UIApplication.shared.canOpenURL(browseURLRequest.url!) {
            UIApplication.shared.open(browseURLRequest.url!)
        }
    }
    

}
