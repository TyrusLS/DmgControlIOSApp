//
//  MainScreenTableViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 22.03.22.
//

import UIKit
import KeychainWrapper
import CoreData

class MainScreenTableViewController: UITableViewController, DidSelectOrgaDelegate{

    

    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var vornameTextField: UITextField!
    @IBOutlet weak var nachnameTextField: UITextField!
    @IBOutlet weak var rufnameTextField: UITextField!
    @IBOutlet weak var organisationCell: UITableViewCell!
    @IBOutlet weak var kennzeichenTextField: UITextField!
    @IBOutlet weak var schadensmeldungCell: UITableViewCell!
    @IBOutlet weak var organisationLabel: UILabel!
    @IBOutlet weak var DmgLabel: UILabel!
    var activeTextField: UITextField!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var equipmentData: EquipmentData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vornameTextField.delegate = self
        vornameTextField.returnKeyType = UIReturnKeyType.next
        vornameTextField.clearButtonMode = .whileEditing
        nachnameTextField.delegate = self
        nachnameTextField.returnKeyType = UIReturnKeyType.next
        nachnameTextField.clearButtonMode = .whileEditing
        rufnameTextField.delegate = self
        rufnameTextField.returnKeyType = UIReturnKeyType.next
        rufnameTextField.clearButtonMode = .whileEditing
        kennzeichenTextField.delegate = self
        kennzeichenTextField.returnKeyType = UIReturnKeyType.done
        kennzeichenTextField.clearButtonMode = .whileEditing
        equipmentData = getCurrentDevice()
        header.title?.append(contentsOf: " - "+equipmentData.id!)
        vornameTextField.text = equipmentData.userdata?.vorname
        nachnameTextField.text = equipmentData.userdata?.nachname
        rufnameTextField.text = equipmentData.userdata?.rufname
        kennzeichenTextField.text = equipmentData.userdata?.kennzeichen
        if(equipmentData.userdata?.organisation != nil){
            organisationLabel.text = equipmentData.userdata?.organisation
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGRect {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue else{return CGRect(x: 0, y: 0, width: 0, height: 0)}
        return keyboardSize
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if(activeTextField != nil){
            switch(activeTextField.restorationIdentifier)
            {
            case "vorname":
                let indexPath = IndexPath.init(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                break;
            case "nachname":
                let indexPath = IndexPath.init(row: 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                break;
            case "rufname":
                let indexPath = IndexPath.init(row: 2, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                break;
            case "kennzeichen":
                let indexPath = IndexPath.init(row: 3, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                break;
            default:
                break;
            }
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == 6){
        }
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if (cell.reuseIdentifier == "pushOrga"){
            performSegue(withIdentifier: "pushOrga", sender: cell)
        }else if
            (cell.reuseIdentifier == "pushDmg"){
            performSegue(withIdentifier: "pushDmg", sender: cell)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DmgLabel.text = "Erfassen"
        if(equipmentData.sturzschaden?.checked ?? false){
            DmgLabel.text = ""
            DmgLabel.text?.append("Sturzschaden \n")
            DmgLabel.text?.append("Sturzhöhe: " +  (equipmentData.sturzschaden?.height ?? "") + "\n")
            DmgLabel.text?.append("Beschädigte Geräte:\n")
            let device = equipmentData.sturzschaden?.sturzDevice?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [SturzDevice?]
           var tmp : String = ""
            if(device.count != 0){
                for x in device{
                tmp.append((x?.name ?? "") + ", ")
                }
                DmgLabel.text?.append(tmp + "\n")
            }
            DmgLabel.text?.append("Angegebene Details:\n")
            DmgLabel.text?.append(equipmentData.sturzschaden?.details ?? "")
        }
        if(equipmentData.sonstigerschaden?.checked ?? false){
            DmgLabel.text = ""
            DmgLabel.text?.append("Sonstigerschaden \n")
            DmgLabel.text?.append("Beschädigte Funktionen:\n")
            let function = equipmentData.sonstigerschaden?.sonstigeFunktion!.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [SonstigeFunktion?]
           var tmp : String = ""
            if(function.count != 0){
                for x in function{
                tmp.append((x?.name ?? "") + ", ")
                }
                DmgLabel.text?.append(tmp + "\n")
            }
            DmgLabel.text?.append("Angegebene Details:\n")
            DmgLabel.text?.append(equipmentData.sonstigerschaden?.details ?? "")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
            
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField){
        case vornameTextField:
            let indexPath = IndexPath.init(row: 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            textField.resignFirstResponder()
            nachnameTextField.becomeFirstResponder()
            
            break;
        case nachnameTextField:
            let indexPath = IndexPath.init(row: 2, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            textField.resignFirstResponder()
            rufnameTextField.becomeFirstResponder()
            
            break;
        case rufnameTextField:
            let indexPath = IndexPath.init(row: 3, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            textField.resignFirstResponder()
            kennzeichenTextField.becomeFirstResponder()
            
            break;
        case kennzeichenTextField:
            let indexPath = IndexPath.init(row: 4, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            textField.resignFirstResponder()
            break;
        default:
            break;
        }
           return true
          }
    
    func getCurrentDevice() -> EquipmentData?{
        var tmp : [EquipmentData]!
        var currentDeviceString : String!
        do{
            let currentDevice = try KeychainWrapper.get(account: "currentdevice")
            currentDeviceString = String(data: currentDevice!, encoding: .utf8)!
            tmp = try context.fetch(EquipmentData.fetchRequest(device:currentDeviceString))
            
        }catch{
            print(error)
        }
        if(tmp.count == 1){
            return tmp[0]
        }
        return nil
    }

    @IBAction func SendData(_ sender: Any) {
        performSegue(withIdentifier: "FinalSegue", sender: sender)
    }
    @IBAction func backToDeviceScanning(_ sender: Any) {
        let devicescanning = storyboard?.instantiateViewController(withIdentifier: "devicescan") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = devicescanning
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    func didSelectOrgaDelegate(_ OrgaName: String) {
        do{
        print(OrgaName + " in Delegate")
        equipmentData.userdata?.organisation = OrgaName
            organisationLabel.text = OrgaName
            try context.save()}catch{}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pushOrga"){
           let orgTVC = segue.destination as! OrgaTableViewViewController
            orgTVC.equipmentData = equipmentData
            orgTVC.delegate = self
        }
        if(segue.identifier == "pushDmg"){
            let next = segue.destination as! TableViewViewController
            next.cellstring = "DmgReportIDCell"
            next.data = ["Sonstigeschäden","Sturzschaden"]
            next.checkableBool = false
            next.nextViewIdentifyerString = "function"
            next.nextViewIndetifyerStringTmp = "height"
            next.equipmentData = equipmentData
            next.CoreDataAttribute = "nothing"
        }
        if(segue.identifier == "FinalSegue"){
            let next = segue.destination as! CheckListTableViewViewController
            next.equipmentData = equipmentData
           if(equipmentData.sturzschaden?.checked ?? false){
               next.data.append("Sturzhöhe: "+(equipmentData.sturzschaden?.height ?? ""))
                let device = equipmentData.sturzschaden?.sturzDevice?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [SturzDevice?]
               var tmp : String = ""
                if(device.count != 0){
                    tmp.append("beschädigte Geräte: ")
                    for x in device{
                    tmp.append("""
                    \n
                    \(x?.name ?? "")
                    """)
                    }
                    next.data.append(tmp)
                }
               next.data.append("Weitere Details: " +
                                (equipmentData.sturzschaden?.details ?? ""))
           }else if(equipmentData.sonstigerschaden?.checked ?? false){
               let function = equipmentData.sonstigerschaden?.sonstigeFunktion?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [SonstigeFunktion?]
              var tmp : String = ""
               if(function.count != 0){
                   tmp.append("beschädigte Funktion: ")
                   for x in function{
                       tmp.append("""
                       \n
                       \(x?.name ?? "")
                       """)
                   }
                   next.data.append(tmp)
               }
               next.data.append("Weitere Details: " +
                                (equipmentData.sonstigerschaden?.details ?? ""))
            }
        }
    }
}


extension MainScreenTableViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch(textField.restorationIdentifier)
        {
        case "vorname":
                do{
            equipmentData.userdata?.vorname = textField.text
                try context.save()}catch{}
            break;
        case "nachname":
                do{
            equipmentData.userdata?.nachname = textField.text
                try context.save()}catch{}
            break;
        case "rufname":
                do{
            equipmentData.userdata?.rufname = textField.text
                try context.save()}catch{}
            break;
        case "kennzeichen":
                do{
            equipmentData.userdata?.kennzeichen = textField.text
                try context.save()}catch{}
            break;
        default:
            break;
        }
        return true
    }
    
    
}

