//
//  ProfileEditViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/06.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "employmentCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "occupationCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sexCell", for:indexPath)
            return cell
            
        } else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ageCell", for:indexPath)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "プロフィールを編集"
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class imageCell:UITableViewCell{
    @IBOutlet weak var profileImage: UIImageView!
    
}

class nameCell:UITableViewCell {
    @IBOutlet weak var nameTextField: UITextField!
    
}
class employmentCell:UITableViewCell {
    @IBOutlet weak var employmentTextField: UITextField!
    
}

class occupationCell:UITableViewCell {
    @IBOutlet weak var occupationTextField: UITextField!
    
}

class profileCell:UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!{
        didSet {
            textView.text = "これはほかあたかもその会得屋という事のために行かなくん。ひとまず翌日の話らもどうもその反対ますないなりに立つているたには公言しませだて、こうにもなりですなかろですた。個性を纏めだのはようやく昔にけっしてべくまします。いくら木下さんに＃「下どう意味の描いで偽りそのがた私か尊重でにおいてお就職ないならべくなと、そのほかも私か受合必竟で知らが、ネルソンさんののが他人の彼らがもう実帰着となっけれども私形でご影響に思いようにもちろんご観念を眺めたですて、まあさぞ意味に云いたておいなけれのに申し上げるたます。"
            
        }
    }
}

class sexCell:UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sexPicker: UIPickerView!
    
    override func awakeFromNib() {
        sexPicker.delegate = self
        sexPicker.dataSource = self
    }
    
    let dataList = [
        "みかん","オレンジ","いよかん","グレープフルーツ"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        //label.text = dataList[row]
    }

    
   
}

class ageCell:UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var agePicker: UIPickerView!
    
    override func awakeFromNib() {
        agePicker.delegate = self
        agePicker.dataSource = self
    }
    
    let dataList = [
        "みかん","オレンジ","いよかん","グレープフルーツ"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        //label.text = dataList[row]
    }

}

