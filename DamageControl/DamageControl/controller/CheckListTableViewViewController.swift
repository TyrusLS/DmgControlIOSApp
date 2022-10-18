//
//  CheckListTableViewViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 28.03.22.
//

import UIKit

class CheckListTableViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var equipmentData: EquipmentData!
    
    
    var data : [String] = [
        "Vorname: ",
        "Nachname: ",
        "Rufname: ",
        "KFZ-Kennzeichen: ",
        "Organisation: ",
                ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        data[0].append(equipmentData.userdata?.vorname ?? "" )
        data[1].append(equipmentData.userdata?.nachname ?? "")
        data[2].append(equipmentData.userdata?.rufname ?? "")
        data[3].append(equipmentData.userdata?.kennzeichen ?? "")
        data[4].append(equipmentData.userdata?.organisation ?? "")
        
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath)as! ReusableCell
         cell.textView.isEditable = false
         cell.selectionStyle = .none
         cell.textView.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sturzrowheight = (equipmentData.sturzschaden?.sturzDevice!.count)! * 35 + 44
        let sonstigerrowheight = (equipmentData.sonstigerschaden?.sonstigeFunktion!.count)! * 35 + 44
        
        if (indexPath.row == 6 && (equipmentData.sturzschaden?.checked ?? false)){
            return CGFloat(sturzrowheight)
        }else
        if (indexPath.row == 5 && (equipmentData.sonstigerschaden?.checked ?? false)){
            return CGFloat(sonstigerrowheight)
        }else {
            return UITableView.automaticDimension
        }
        
    }
  
    
    @IBAction func EndFunction(_ sender: Any) {
        context.delete(equipmentData)
       do{
           try context.save()
       }catch{
           
       }
        let qr = storyboard?.instantiateViewController(withIdentifier: "devicescan") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = qr
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
}
/**/
