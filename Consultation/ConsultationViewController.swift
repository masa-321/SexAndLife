//
//  ConsultationViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/31.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseFirestore
import SDWebImage
import SVProgressHUD

class ConsultationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore() //初期化
    let storage = Storage.storage() //初期化
    let refreshControl = UIRefreshControl()
    
    var receivedCategories:[String] = []
    //var consultationArray:[Consultation] = []
    var receivedConsultationTypeA_Array:[Consultation] = []
    var receivedConsultationTypeB_Array:[Consultation] = []
    var receivedConsultationTypeC_Array:[Consultation] = []
    var receivedConsultationTypeD_Array:[Consultation] = []
    var receivedConsultationTypeE_Array:[Consultation] = []
    var receivedConsultationTypeF_Array:[Consultation] = []
    /*var receivedConsultationTypeA_Array:[[String : Any]] = []
    var receivedConsultationTypeB_Array:[[String : Any]] = []
    var receivedConsultationTypeC_Array:[[String : Any]] = []
    var receivedConsultationTypeD_Array:[[String : Any]] = []
    var receivedConsultationTypeE_Array:[[String : Any]] = []
    var receivedConsultationTypeF_Array:[[String : Any]] = []*/
    //var consultationNameArray:[String] = []
    
    var types:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //refreshControl.attributedTitle = NSAttributedString(string: "何も表示されないときは引っ張って更新してみてください")
        //refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        //tableView.addSubview(refreshControl)
    }
    /*
    @objc func refresh(){
        fetchConsulation()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }*/
    

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "相談窓口"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil //UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .black  //clear
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        //fetchConsulation() //viewDidLoadに入れていたら、調子が悪くなったので、こちらへ移行したらうまく動くようになった。
        /*if receivedCategories.isEmpty || receivedConsultationTypeA_Array.isEmpty {
            fetchConsulation()
        }*/
    }
    
    
    /*func fetchConsulation() {
        types = ["typeA","typeB","typeC","typeD","typeE","typeF"]
        
        let ref = db.collection("consultations")
        db.collection("categories").document("vokXlkvJcce7W1YHvQNn").getDocument { (document, error) in
            if let document = document, document.exists {
                print(type(of: document.data()))
                for i in 0..<document.data()!.count {
                    self.receivedCategories.append(document.data()![self.types[i]] as! String)
                }
                //print(self.receivedCategories) //categoriesの中に何が入っているかがこれでわかる。
            } else {
                print("Document does not exist")
            }
        }
        
        receivedConsultationTypeA_Array = []
        receivedConsultationTypeB_Array = []
        receivedConsultationTypeC_Array = []
        receivedConsultationTypeD_Array = []
        receivedConsultationTypeE_Array = []
        receivedConsultationTypeF_Array = []
            
        for type in types {
            ref.whereField("ConsultationType", isEqualTo: type).getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if type == "typeA" {
                            self.receivedConsultationTypeA_Array.append(document.data())
                        } else if type == "typeB" {
                            self.receivedConsultationTypeB_Array.append(document.data())
                        } else if type == "typeC" {
                            self.receivedConsultationTypeC_Array.append(document.data())
                        } else if type == "typeD" {
                            self.receivedConsultationTypeD_Array.append(document.data())
                        } else if type == "typeE" {
                            self.receivedConsultationTypeE_Array.append(document.data())
                        } else if type == "typeF" {
                            self.receivedConsultationTypeF_Array.append(document.data())
                        }
                    }
                    //この中であれば、self.consultationTypeA_Array.countは数値を持つ。この外でも数値を持つためには、以下のようにreloadが必要。
                    
                    self.tableView.reloadData()//これのおかげで、
                    
                }
            }
        }
    }*/
    
    func generateConsultations(indexPath: IndexPath) -> [Consultation] {
        
        var consultations:[Consultation] = []

        if indexPath.section == 0 {
            for i in 0..<self.receivedConsultationTypeA_Array.count {
                let consultation = self.receivedConsultationTypeA_Array[i]
                consultations.append(consultation)
                
                /*
                if receivedConsultationTypeA_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeA_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeA_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeA_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                    print("receivedConsultationTypeA_Array",consultation)
                }*/
            }
        } else if indexPath.section == 1 {
            for i in 0..<self.receivedConsultationTypeB_Array.count {
                let consultation = self.receivedConsultationTypeB_Array[i]
                consultations.append(consultation)
                /*
                if receivedConsultationTypeB_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeB_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeB_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeB_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                    print("receivedConsultationTypeB_Array",consultation)
                }*/
            }
        } else if indexPath.section == 2 {
            for i in 0..<self.receivedConsultationTypeC_Array.count {
                let consultation = self.receivedConsultationTypeC_Array[i]
                consultations.append(consultation)
                /*if receivedConsultationTypeC_Array[i]["ImageURLString"] == nil {
                    
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeC_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeC_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeC_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }*/
            }
        } else if indexPath.section == 3 {
            for i in 0..<self.receivedConsultationTypeD_Array.count {
                let consultation = self.receivedConsultationTypeD_Array[i]
                consultations.append(consultation)
                /*if receivedConsultationTypeD_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeD_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeD_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeD_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }*/
            }
        } else if indexPath.section == 4 {
            for i in 0..<self.receivedConsultationTypeE_Array.count {
                let consultation = self.receivedConsultationTypeE_Array[i]
                consultations.append(consultation)
                /*if receivedConsultationTypeE_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeE_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeE_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeE_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }*/
            }
        } else if indexPath.section == 5 {
            for i in 0..<self.receivedConsultationTypeF_Array.count {
                let consultation = self.receivedConsultationTypeF_Array[i]
                consultations.append(consultation)
                /*if receivedConsultationTypeF_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/placeholderImage.jpg", consultationName: "\(receivedConsultationTypeF_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(receivedConsultationTypeF_Array[i]["ImageURLString"]!)", consultationName: "\(receivedConsultationTypeF_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }*/
            }
        }
        return consultations
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return receivedCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultationCollectionCell") as! ConsultationCollectionCell
        print("ConsultationのcellForRowAtは呼ばれてます")
        cell.title = receivedCategories[indexPath.section]
        cell.consultations = generateConsultations(indexPath: indexPath)
        
        cell.masterViewPointer = self //まーじか。
        //print("テスト：\(consultationTypeA_Array.count)")
        return cell
    }
    
    func setScrollPosition(position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }
    
    func nextDetail(giveConsultation:Consultation) {
        /*let giveCellViewModel = giveCellViewModel
        //self.giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel*/
        let vc:ConsultationDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConsultationDetail") as! ConsultationDetailViewController
        vc.receiveConsultation = giveConsultation
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
