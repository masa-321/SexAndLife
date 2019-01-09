//
//  ConsultaionViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/31.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage

class ConsultaionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore() //初期化
    let storage = Storage.storage() //初期化
    @IBOutlet weak var imageView: UIImageView!
    
    var categories = ["避妊・妊娠"/*, "デートDV", "リベンジポルノ被害", "性被害", "性的搾取", "加害者相談窓口"*/]
    //var consultationArray:[Consultation] = []
    var consultationArray:[Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchConsulation()
        fetchConsultationImages()
    }
    //var db = Firestore.firestore()でもいいのか。
    
    
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
    }
    
    func fetchConsulation() {
        //consulationArray = []
        let ref = db.collection("consultations")//.document("8v8zUMBSTxeYpfz8qqng")
        ref.getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //self.consultationArray.insert(document.data(), at: 0)
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        print("テスト")
        print(consultationArray)
    }
    
    func fetchConsultationImages() {
        let gsReference = storage.reference(forURL: "gs://sexualhealthmedia-736f9.appspot.com/consultationImages/ninshinsostokyo.jpg")
        //let pathReference = storage.reference(withPath: "consultationImages/ninshinsostokyo.jpg")

         // UIImageView in your ViewController
         //let imageView: UIImageView = self.imageView
         
         // Placeholder image
         //let placeholderImage = UIImage(named: "placeholder.jpg")
         
         // Load the image using SDWebImage
         self.imageView.sd_setImage(with: gsReference/*, placeholderImage: placeholderImage*/)
    }
   
    
    func generateConsultations(indexPath: IndexPath) -> [Consultation] {
        var consultations: [Consultation] = []
        if indexPath.section == 0 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
            }
        } else if indexPath.section == 1 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
            }
        } else if indexPath.section == 2 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
            }
        } else if indexPath.section == 3 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
            }
        } else if indexPath.section == 4 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
            }
        } else if indexPath.section == 5 {
            for i in 0..<5 {
                let consultation = Consultation(imageName: "defaultImage", consultationTitle: "defalutTitle\(i)")
                consultations.append(consultation)
                /*
                 let travel = Travel(imageName: "travel_\(indexPath.section)_\(i)", rating: Int(arc4random_uniform(10)+1))
                 travels.append(travel)
                 */
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultationCollectionCell") as! ConsultaionCollectionCell
        cell.title = categories[indexPath.section]
        cell.consultations = generateConsultations(indexPath: indexPath)
        
        return cell
    }
    
    func setScrollPosition(position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }
    
}
