//
//  ProfileEditViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/06.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
import SDWebImage
import SVProgressHUD

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profileData:Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "プロフィールを編集"
        // Do any additional setup after loading the view.
        print("self.profileData",self.profileData)
        /*if let user = Auth.auth().currentUser {
            //print("receiveUserId == user.uidだった")
            //print(user.uid)
            let ref = Firestore.firestore().collection("users").document("\(user.uid)")
            //ref.document(user.uid).getDocument { (document, error) in
            ref.addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.profileData = Profile(snapshot: querySnapshot!)
                }
            }
        }*/
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:ImageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for:indexPath) as! ImageCell
            if let profileData = self.profileData {
                cell.profileImage.sd_setImage(with: URL(string: profileData.pictureUrl!), placeholderImage: UIImage(named: "profile4"))
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell:IdCell = tableView.dequeueReusableCell(withIdentifier: "idCell", for:indexPath) as! IdCell
            cell.IDLabel.text = self.profileData!.id
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        }else if indexPath.row == 2 {
            let cell:NameCell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for:indexPath) as! NameCell
            cell.nameTextField.text = self.profileData!.name
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else if indexPath.row == 3 {
            let cell:EmploymentCell = tableView.dequeueReusableCell(withIdentifier: "employmentCell", for:indexPath) as! EmploymentCell
            cell.employmentTextField.text = self.profileData!.employment
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        } else if indexPath.row == 4 {
            let cell:OccupationCell = tableView.dequeueReusableCell(withIdentifier: "occupationCell", for:indexPath) as! OccupationCell
            cell.occupationTextField.text = self.profileData!.occupation
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        } else if indexPath.row == 5 {
            let cell:ProfileTextCell = tableView.dequeueReusableCell(withIdentifier: "profileTextCell", for:indexPath) as! ProfileTextCell
            cell.textView.text = self.profileData!.profile
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        } else if indexPath.row == 6 {
            let cell:SexCell = tableView.dequeueReusableCell(withIdentifier: "sexCell", for:indexPath) as! SexCell
            cell.setPicker(receivedSex: self.profileData!.sex!)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        } else if indexPath.row == 7 {
            let cell:AgeCell = tableView.dequeueReusableCell(withIdentifier: "ageCell", for:indexPath) as! AgeCell
            cell.setPicker(receivedAge: self.profileData!.age!)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.masterViewPointer = self
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            alertAction()
        }
    }
    
    func alertAction(){
        print("alertActionが呼ばれたよ")
        let alertController = UIAlertController(title: "プロフィール写真を変更", message: nil, preferredStyle: .actionSheet) // AlertContollerを初期化する。actionSheetを選択。
        //キャンセルボタンの設置。inの後には特にコードの記述は不要。
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
        })
        
        //Alertの項目を増やしていく。
        //ライブラリから画像をピックアップするためのコード
        let defaultAction1:UIAlertAction = UIAlertAction(title: "ライブラリから選択", style: UIAlertAction.Style.default,handler :{ (action:UIAlertAction) in
         //UIImagePickerController
         if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
         let picker = UIImagePickerController()
         picker.sourceType = .photoLibrary
         picker.delegate = self
         self.present(picker, animated: true, completion: nil)
         } else {
         print("この機種ではフォトライブラリが使用出来ません。")
         }
         })
        
        let defaultAction3:UIAlertAction = UIAlertAction(title: "リセット", style: UIAlertAction.Style.default,handler :{ (action:UIAlertAction) in
            //self.fileDelete()
            print("リセット")
        })
        
        
        alertController.addAction(defaultAction1)
        //alertController.addAction(defaultAction2)
        alertController.addAction(defaultAction3)
        alertController.addAction(cancelAction) //キャンセルアクションを追加した。
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        SVProgressHUD.show()
        
        let userInfo = [
            "Employment": profileData?.employment!,
            "Occupation": profileData?.occupation!,
            "Profile": profileData?.profile!,
            "性別": profileData?.sex!,
            "年齢": profileData?.age!
        ]
        
        if let user = Auth.auth().currentUser {
            let userRef = Firestore.firestore().collection("users").document("\(user.uid)")
            userRef.updateData(userInfo){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                    //navigationControllerで一つ前の画面に戻る
                    self.navigationController?.popViewController(animated: true)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
}

//UIImageを拡張し、resizedメソッドを追加する
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // 画像が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            let resizedImage = selectedImage.resized(toWidth: 60)//データの容量もしっかり削減される。
            //self.imageView.image = resizedImage
            fileupload(image:resizedImage!) //データの名前を変えなければ、その度に上書きされる。
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 画像選択がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fileupload(image: UIImage) {
        print("fileupload is called")
        SVProgressHUD.show()
        
        if let user = Auth.auth().currentUser {
            let storageRef = Storage.storage().reference(forURL: "gs://sexualhealthmedia-736f9.appspot.com/profileIcons")//ストレージへの参照を取得
            let imageRef = storageRef.child("\(user.uid).JPG")//名前はuuidにする。//ツリーの下位への参照を作成
            let imageData = image.jpegData(compressionQuality: 1.0)!
            imageRef.putData(imageData, metadata: nil){ (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print("metadata.size",size) //バイト数で表示される。
                
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Failed to download url:", error!)
                        return
                    } else {
                        //Do something with url
                        print("url",url)
                        
                        let userInfo = [
                            "pictureUrl":"\(url!)"
                        ]
                        
                        let userRef = Firestore.firestore().collection("users").document("\(user.uid)")
                        userRef.updateData(userInfo){ err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document successfully written!")
                                //navigationControllerで一つ前の画面に戻る
                                self.navigationController?.popViewController(animated: true)
                                SVProgressHUD.dismiss()
                                //self.navigationController?.popViewController(animated: false)
                            }
                        }
                        
                    }
                })
            }
        }
        
    }
    
    func fileDelete() {
        if let user = Auth.auth().currentUser {
            let storageRef = Storage.storage().reference(forURL: "gs://sexualhealthmedia-736f9.appspot.com/profileIcons")
            let imageRef = storageRef.child("\(user.uid).JPG")
            imageRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // File deleted successfully
                }
            }
        }
    }
}


class ImageCell:UITableViewCell {
    //Redundant conformance of 'ImageCell' to protocol 'UIGestureRecognizerDelegate'、このメッセージは、すでに使用しているプロトコルを、再度継承しようとした時に起こる。
    var masterViewPointer:ProfileEditViewController?
    
    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    
}

class IdCell:UITableViewCell {
    var masterViewPointer:ProfileEditViewController?
    
    @IBOutlet weak var IDLabel: UILabel!
    
}

class NameCell:UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    var masterViewPointer:ProfileEditViewController?
    
    override func awakeFromNib() {
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        nameTextField.isEnabled = false
        nameTextField.borderStyle = UITextField.BorderStyle.none
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Keyboardを閉じる
        nameTextField.resignFirstResponder()
        
        return true
        
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.nameTextField.isFirstResponder) {
            self.nameTextField.resignFirstResponder()
        }
    }
    
    //UITextFieldの編集後に処理を行う
    func textFieldDidEndEditing(_ textField: UITextField) {
        masterViewPointer?.profileData?.employment = self.nameTextField.text
    }
}

class EmploymentCell:UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var employmentTextField: UITextField!
    var masterViewPointer:ProfileEditViewController?
    
    override func awakeFromNib() {
        employmentTextField.delegate = self
        employmentTextField.returnKeyType = .done
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Keyboardを閉じる
        employmentTextField.resignFirstResponder()
        
        return true
        
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.employmentTextField.isFirstResponder) {
            self.employmentTextField.resignFirstResponder()
        }
    }
    
    //UITextFieldの編集後に処理を行う
    func textFieldDidEndEditing(_ textField: UITextField) {
        masterViewPointer?.profileData?.employment = self.employmentTextField.text
    }
    
}

class OccupationCell:UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var occupationTextField: UITextField!
    var masterViewPointer:ProfileEditViewController?
    
    override func awakeFromNib() {
        occupationTextField.delegate = self
        occupationTextField.returnKeyType = .done
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Keyboardを閉じる
        occupationTextField.resignFirstResponder()
        
        return true
        
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.occupationTextField.isFirstResponder) {
            self.occupationTextField.resignFirstResponder()
        }
    }
    
    //UITextFieldの編集後に処理を行う
    func textFieldDidEndEditing(_ textField: UITextField) {
        masterViewPointer?.profileData?.occupation = self.occupationTextField.text
    }
    
    //textFieldにdidChangeメソッドはないようだ。
}

class ProfileTextCell:UITableViewCell, UITextViewDelegate {
    var masterViewPointer:ProfileEditViewController?
    @IBOutlet weak var textView: UITextView!{
        didSet {
            
            textView.delegate = self
            textView.text = ""
            textView.translatesAutoresizingMaskIntoConstraints = true
            //textView.sizeToFit()
            
            
             // 仮のサイズでツールバー生成
             let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
             kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
             
             kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
             
             // スペーサー
             let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
             
             // 閉じるボタン
             let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commitButtonTapped(sender:event:)))
             
             kbToolBar.items = [spacer, commitButton]
             textView.inputAccessoryView = kbToolBar
        }
    }
    
    @objc func commitButtonTapped (sender:UIBarButtonItem, event:UIEvent) {
        textView.resignFirstResponder()
        print("完了")
    }
    
    //画面の外を押したら閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    //編集中でも情報を送ることができた。
    func textViewDidChange(_ textView: UITextView) {
        masterViewPointer?.profileData?.profile = self.textView.text
    }
    
}

class SexCell:UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sexPicker: UIPickerView!
    let dataList = ["未指定","男性","女性","その他"]
    var masterViewPointer:ProfileEditViewController?
    
    override func awakeFromNib() {
        sexPicker.delegate = self
        sexPicker.dataSource = self
    }
    
    func setPicker(receivedSex:String) {
        print("setPckerが呼ばれたよ")
        
        for i in 0..<dataList.count{
            if "" == receivedSex {
                sexPicker.selectRow(0, inComponent: 0, animated: false)
            } else if dataList[i] == receivedSex {
                sexPicker.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        
        masterViewPointer?.profileData?.sex = dataList[row]
    }
   
}

class AgeCell:UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var agePicker: UIPickerView!
    var masterViewPointer:ProfileEditViewController?
    
    override func awakeFromNib() {
        agePicker.delegate = self
        agePicker.dataSource = self
    }
    
    let dataList = ["未指定","19歳以下","20~24歳","25~29歳","30~39歳", "40~49歳", "50歳以上"]
    
    func setPicker(receivedAge:String) {
        for i in 0..<dataList.count{
            if "" == receivedAge {
                agePicker.selectRow(0, inComponent: 0, animated: false)
            } else if dataList[i] == receivedAge {
                agePicker.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        masterViewPointer?.profileData?.age = dataList[row]
        //label.text = dataList[row]
    }

}

