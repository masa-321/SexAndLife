//
//  ConsultationCollectionCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/05.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit



class ConsultationCollectionCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var masterViewPointer:ConsultationViewController?
    
    //var receivedConsultationArray:[[String : Any]] = []
    
    //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //tap.cancelsTouchesInView = false
        //collectionView.addGestureRecognizer(tap)
        collectionView.isUserInteractionEnabled = true
    }
    
    
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var consultations: [Consultation] = [Consultation]() {
        didSet {
            collectionView.reloadData()
        }
    }
}

extension ConsultationCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    //UICollectionViewDelegateを追加したら呼ばれるようになった。
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consultations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsultationItemCell", for: indexPath) as! ConsultationItemCell
        cell.consultation = consultations[indexPath.item]
        /*if indexPath.section == 0 {
            print("cellForItemAt0",consultations[indexPath.item])
        } else if indexPath.section == 1 {
            print("cellForItemAt1",consultations[indexPath.item])
        }*/
        
        //print(cell.consultation)
        //print("cellForItemAtは呼ばれたよ")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsultationItemCell", for: indexPath) as! ConsultationItemCell
        /*let nextButton = UIButton(frame: CGRect(x:0, y:0,
                                                width:cell.frame.width, height:cell.frame.height))
        nextButton.backgroundColor = UIColor.init(
            red:0.9, green: 0.9, blue: 0.9, alpha: 1)
        nextButton.addTarget(self, action: #selector(nextDetail(sender:event:)), for: UIControl.Event.touchUpInside)
        cell.addSubview(nextButton)*/
        print(masterViewPointer) //nilってどういうことだ？どういう意味や？tableViewのcellForRowAt？にcell.masterPointer = selfとしたら中身が入るようになった。解決。
        let consultation = consultations[indexPath.item]
        masterViewPointer?.nextDetail(giveConsultation: consultation)
        print("CollectionViewのItemがタップされたよ")
    }

    
    /*
    @objc func nextDetail(segue: UIStoryboardSegue,sender:UIButton, event:UIEvent){
        let consultationDetailViewController:ConsultationDetailViewController = UIStoryboard.instantiateViewController(withIdentifier: "ConsultationDetail") as! ConsultationDetailViewController
        performSegue(withIdentifier: "next", sender: nil)
        if segue.identifier == "nextDetail" {
            nextVC.selectedNumber = count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextDetail" {
            let nextVC:NextViewController = segue.destination as! NextViewController
            nextVC.selectedNumber = count
        }
    }*/
    /*
    @objc func nextDetail(sender:UIButton, event:UIEvent){
        let consultationDetailViewController:ConsultationDetailViewController = UIStoryboard.instantiateViewController(withIdentifier: "ConsultationDetail") as! ConsultationDetailViewController
        
        self.navigationController?.pushViewController(consultationDetailViewController, animated: true)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "nextDetail") {
            let subVC: SubViewController = (segue.destination as? SubViewController)!
            
            // SubViewController のselectedImgに選択された画像を設定する
            subVC.selectedImg = selectedImage
        }
    }*/
}

/*
 表示されない問題は、 delegateとdatasourceの接続の問題だった。
 delegateとdatasource、tableViewとの併用だとどうすればいいのかよくわからなかった。
 Collection Viewを、２段階上位のConsultaionCollectionCellへとつなげたら解決した。
 
 
 */
