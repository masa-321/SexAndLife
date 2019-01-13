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

class ConsultationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore() //初期化
    let storage = Storage.storage() //初期化
    let refreshControl = UIRefreshControl()
    
    var categories:[String] = []
    //var consultationArray:[Consultation] = []
    var consultationTypeA_Array:[[String : Any]] = []
    var consultationTypeB_Array:[[String : Any]] = []
    var consultationTypeC_Array:[[String : Any]] = []
    var consultationTypeD_Array:[[String : Any]] = []
    var consultationTypeE_Array:[[String : Any]] = []
    var consultationTypeF_Array:[[String : Any]] = []
    //var consultationNameArray:[String] = []
    
    var types:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //fetchConsulation()
        
        refreshControl.attributedTitle = NSAttributedString(string: "何も表示されないときは引っ張って更新してみてください")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(){
        fetchConsulation()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "相談"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil //UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .black  //clear
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        fetchConsulation() //viewDidLoadに入れていたら、調子が悪くなったので、こちらへ移行したらうまく動くようになった。
    }
    
    func fetchConsulation() {
        types = ["typeA","typeB","typeC","typeD","typeE","typeF"]
        
        let ref = db.collection("consultations")
        db.collection("categories").document("vokXlkvJcce7W1YHvQNn").getDocument { (document, error) in
            if let document = document, document.exists {
                print(type(of: document.data()))
                for i in 0..<document.data()!.count {
                    self.categories.append(document.data()![self.types[i]] as! String)
                }
                print(self.categories) //categoriesの中に何が入っているかがこれでわかる。
            } else {
                print("Document does not exist")
            }
        }
        
        consultationTypeA_Array = []
        consultationTypeB_Array = []
        consultationTypeC_Array = []
        consultationTypeD_Array = []
        consultationTypeE_Array = []
        consultationTypeF_Array = []
            
        for type in types {
            ref.whereField("ConsultationType", isEqualTo: type).getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if type == "typeA" {
                            self.consultationTypeA_Array.append(document.data())
                        } else if type == "typeB" {
                            self.consultationTypeB_Array.append(document.data())
                        } else if type == "typeC" {
                            self.consultationTypeC_Array.append(document.data())
                        } else if type == "typeD" {
                            self.consultationTypeD_Array.append(document.data())
                        } else if type == "typeE" {
                            self.consultationTypeE_Array.append(document.data())
                        } else if type == "typeF" {
                            self.consultationTypeF_Array.append(document.data())
                        }
                    }
                    //この中であれば、self.consultationTypeA_Array.countは数値を持つ。この外でも数値を持つためには、以下のようにreloadが必要。
                    
                    self.tableView.reloadData()//これのおかげで、
                    
                }
            }
        }
    }
    
    func generateConsultations(indexPath: IndexPath) -> [Consultation] {
        
        var consultations:[Consultation] = []
        
        if indexPath.section == 0 {
            for i in 0..<self.consultationTypeA_Array.count {
                if consultationTypeA_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeA_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeA_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeA_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                    print("consultationTypeA_Array",consultation)
                }
            }
        } else if indexPath.section == 1 {
            for i in 0..<self.consultationTypeB_Array.count {
                if consultationTypeB_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeB_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeB_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeB_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                    print("consultationTypeB_Array",consultation)
                }
            }
        } else if indexPath.section == 2 {
            for i in 0..<self.consultationTypeC_Array.count {
                if consultationTypeC_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeC_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeC_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeC_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }
            }
        } else if indexPath.section == 3 {
            for i in 0..<self.consultationTypeD_Array.count {
                if consultationTypeD_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeD_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeD_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeD_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }
            }
        } else if indexPath.section == 4 {
            for i in 0..<self.consultationTypeE_Array.count {
                if consultationTypeE_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeE_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeE_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeE_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }
            }
        } else if indexPath.section == 5 {
            for i in 0..<self.consultationTypeF_Array.count {
                if consultationTypeF_Array[i]["ImageURLString"] == nil {
                    let consultation = Consultation(imageURLString: "gs://sexualhealthmedia-736f9.appspot.com/defaultImage.png", consultationName: "\(consultationTypeF_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                } else {
                    let consultation = Consultation(imageURLString: "\(consultationTypeF_Array[i]["ImageURLString"]!)", consultationName: "\(consultationTypeF_Array[i]["ConsultationName"]!)")
                    consultations.append(consultation)
                }
            }
        }
        return consultations
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultationCollectionCell") as! ConsultationCollectionCell
        print("ConsultationのcellForRowAtは呼ばれてます")
        cell.title = categories[indexPath.section]
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
