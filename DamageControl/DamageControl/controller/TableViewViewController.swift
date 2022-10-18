//
//  TableViewViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 16.03.22.
//

import UIKit
import CoreData
import CoreMedia

class TableViewViewController: UITableViewController {
    
    struct cellstruct{
        var name : String
        var checked : Bool
    }
    
    
    var cellstring: String!
    var data: [String]! = []
    var celldata: [cellstruct]! = []
    var checkableBool : Bool!
    
    var nextViewIdentifyerString: String!
    var nextViewIndetifyerStringTmp: String!
    var CoreDataAttribute: String!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var equipmentData: EquipmentData!
    
    var function : [SonstigeFunktion?]!
    var device : [SturzDevice?]!
    
    var selectedString : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        for i in 0 ... data.count-1{
            fillCellStruct(i: i)
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmp = celldata[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellstring, for: indexPath)as! ReusableCell
        cell.textLabel?.text = tmp.name
        if(tmp.checked){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var celldataentry = celldata[indexPath.row]
        switch(CoreDataAttribute){
        case "height":
            do{
                let oldIndex = data.firstIndex(of: equipmentData.sturzschaden?.height ?? "")
                if(oldIndex == nil || oldIndex != indexPath.row){
                    celldataentry.checked = !celldataentry.checked
                    celldata[indexPath.row] = celldataentry
                }
                if (oldIndex != nil){
                    let oldIndexPath =  IndexPath.init(row: oldIndex!, section: 0)
                    celldata[oldIndex!].checked = false
                    tableView.reloadRows(at: [indexPath,oldIndexPath], with: .fade)
                }else {
                    tableView.reloadRows(at: [indexPath], with: .fade)                }
                equipmentData.sturzschaden?.height = celldataentry.name
                NextIsTableView(index: indexPath.row)
                try context.save()}catch{print(error)}
            break;
        case "device":
            do{
                if(celldataentry.checked){
                    for x in device{
                        if (x!.name == data[indexPath.row]){
                            device.remove(at: device.firstIndex(of: x)!)
                            break;
                        }
                    }
                }else{
               
                    let newDevice = NSEntityDescription.insertNewObject(forEntityName: "SturzDevice", into:context) as! SturzDevice
                    newDevice.name = data[indexPath.row]
                    device.append(newDevice)
                }
                celldataentry.checked = !celldataentry.checked
                celldata[indexPath.row] = celldataentry
                tableView.reloadRows(at: [indexPath], with: .fade)
                try context.save()
            }
            catch
            {
                print(error)
            }
            break;
        case "function":
            do{
                if(celldataentry.checked){
                    for x in function{
                        if (x!.name == data[indexPath.row]){
                            function.remove(at: function.firstIndex(of: x)!)
                            break;
                        }
                    }
                }else{
               
                    let newFunction = NSEntityDescription.insertNewObject(forEntityName: "SonstigeFunktion", into:context) as! SonstigeFunktion
                    newFunction.name = data[indexPath.row]
                    function.append(newFunction)
                }
                celldataentry.checked = !celldataentry.checked
                celldata[indexPath.row] = celldataentry
                tableView.reloadRows(at: [indexPath], with: .fade)
                try context.save()
            }
            catch
            {
                print(error)
            }
            break;
        case "nothing":
            do{
                let oldIndex = data.firstIndex(of: selectedString)
                if(oldIndex == nil || oldIndex != indexPath.row){
                    
                    celldataentry.checked = !celldataentry.checked
                    celldata[indexPath.row] = celldataentry
                }
                if (oldIndex != nil){
                    let oldIndexPath =  IndexPath.init(row: oldIndex!, section: 0)
                    celldata[oldIndex!].checked = false
                    tableView.reloadRows(at: [indexPath,oldIndexPath], with: .fade)
                }else {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                    selectedString =  celldataentry.name
                    
                   
                    try context.save()}
                
            }
                catch{print(error)}
            if(indexPath.row == 0){
                equipmentData.sonstigerschaden?.checked  = true
                equipmentData.sturzschaden?.checked = false
            }else if(indexPath.row == 1){
                equipmentData.sonstigerschaden?.checked  = false
                equipmentData.sturzschaden?.checked = true
                }
            NextIsTableView(index: indexPath.row)
            break;
        default:
            break;
        }
        
        
        
        
        
    }
    
    
    
    func NextIsTableView(index : Int) {
        if(nextViewIndetifyerStringTmp == nil){
                performSegue(withIdentifier: nextViewIdentifyerString, sender: nil)
        }
        else{
            if(index == 0){
                
                performSegue(withIdentifier: nextViewIdentifyerString, sender: nil)
                
            }
            else {
                
                performSegue(withIdentifier: nextViewIndetifyerStringTmp, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier){
        case "device":
            let next = segue.destination as! TableViewViewController
            
            let equipment = LoadequipmentData
            var tmp: [String]! = []
            for i in 0...LoadequipmentData.count-1{
                tmp.append(equipment[i].equipname)
            }
            next.equipmentData = equipmentData
            next.data = tmp
            next.cellstring = "DmgReportIDCell"
            next.checkableBool = true
            next.nextViewIdentifyerString = "SturzDetails"
            next.CoreDataAttribute = "device"
            
            
            break;
        case "SonstigeDetails":
            do{
            equipmentData.sonstigerschaden?.removeFromSonstigeFunktion((equipmentData.sonstigerschaden?.sonstigeFunktion)!)
        
            for x in function{
                    equipmentData.sonstigerschaden?.addToSonstigeFunktion(x!)
                }
            try context.save()
            }catch{print(error)}
            let next = segue.destination as! EditDetailViewController
            next.label = "sonstige details"
            next.equipmentData = equipmentData
            next.casing = "sonstige"
            
            break;
        case "height":
            
            let next = segue.destination as! TableViewViewController
            let height = LoadheightData
            var tmp: [String]! = []
            next.equipmentData = equipmentData
            for i in 0...LoadheightData.count-1{
                tmp.append(height[i].height)
            }
            next.data = tmp
            next.cellstring = "DmgReportIDCell"
            next.checkableBool = false
            next.nextViewIdentifyerString = "device"
            next.CoreDataAttribute = "height"
            
            
            
            break;
        case "function":
            
            let next = segue.destination as! TableViewViewController
            let function = LoadfunctionData
            var tmp: [String]! = []
            next.equipmentData = equipmentData
            for i in 0...function.count-1{
                tmp.append(function[i].function)
            }
            next.data = tmp
            next.cellstring = "DmgReportIDCell"
            next.checkableBool = true
            next.nextViewIdentifyerString = "SonstigeDetails"
            next.CoreDataAttribute = "function"
            
            
            break;
        case "sturzDetails":
            do{
                equipmentData.sturzschaden?.removeFromSturzDevice((equipmentData.sturzschaden?.sturzDevice)!)
                for x in device{
                    equipmentData.sturzschaden?.addToSturzDevice(x!)
                }
                try context.save()
            }catch{print(error)}
            let next = segue.destination as! EditDetailViewController
            next.label = "sturz details"
            next.equipmentData = equipmentData
            next.casing = "sturz"
            
            break;
        default:
            break;
        }
    }
    
    func clearsturz(){
        equipmentData.sturzschaden?.checked = false
        equipmentData.sturzschaden?.height = ""
        equipmentData.sturzschaden?.sturzDevice = nil
        equipmentData.sturzschaden?.details = ""
    }
    func clearsonstige(){
        equipmentData.sonstigerschaden?.checked = false
        equipmentData.sonstigerschaden?.sonstigeFunktion = nil
        equipmentData.sonstigerschaden?.details = ""
    }
    
    
    func fillCellStruct(i:Int){
        
        switch(CoreDataAttribute){
        case"height":
            clearsonstige()
            if (data[i] == equipmentData.sturzschaden?.height){
                celldata.insert(cellstruct(name: data[i], checked: true), at: i)
            }else{
                celldata.insert(cellstruct(name: data[i], checked: false), at: i)
            }
            break;
        case "function":
            clearsturz()
            function = equipmentData.sonstigerschaden?.sonstigeFunktion?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [SonstigeFunktion?]
            if(function != nil && function.count != 0){
                var tmp: [String] = []
                for x in function{
                    tmp.append(x?.name ?? "")
                }
                if(tmp.firstIndex(of: data[i]) != nil){
                celldata.insert(cellstruct(name: data[i], checked: true), at: i)}else{
                    celldata.insert(cellstruct(name: data[i], checked: false), at: i)}}else{
                        celldata.insert(cellstruct(name: data[i], checked: false), at: i)
                    }

            break;
        case "device":
            device = equipmentData.sturzschaden?.sturzDevice?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [SturzDevice?]
            if(device != nil && device.count != 0){
                var tmp: [String] = []
                for x in device{
                    tmp.append(x?.name ?? "")
                }
                if(tmp.firstIndex(of: data[i]) != nil){
                celldata.insert(cellstruct(name: data[i], checked: true), at: i)}else{
                    celldata.insert(cellstruct(name: data[i], checked: false), at: i)}}else{
                        celldata.insert(cellstruct(name: data[i], checked: false), at: i)
                    }
            break;
        case "nothing":
            if (equipmentData.sonstigerschaden?.checked ?? false){
                selectedString = "Sonstigeschäden"
            }else if (equipmentData.sturzschaden?.checked ?? false){
                selectedString = "Sturzschaden"
            }else{selectedString = ""}
            if (data[i] == selectedString){
                celldata.insert(cellstruct(name: data[i], checked: true), at: i)
            }else{
                celldata.insert(cellstruct(name: data[i], checked: false), at: i)
            }
           
            
            break;
        default:
            celldata.insert(cellstruct(name: data[i], checked: false), at: i)
            break;
        }
        
    }
    

    
}

