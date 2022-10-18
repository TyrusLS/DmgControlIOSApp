//
//  OrgaTableViewViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 09.03.22.

import UIKit
import CoreAudio
import CoreData

protocol DidSelectOrgaDelegate {
    func didSelectOrgaDelegate(_ OrgaName: String)
}

class OrgaTableViewViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView:
    UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
   
    
    var delegate: DidSelectOrgaDelegate!
    let orga = LoadorgaData
    var selectedString: String!
    var filteredData: [String]! = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var equipmentData: EquipmentData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* self.navigationItem.titleView = searchBar
        searchBar.delegate = self*/
        filteredData =  orgaToFiltered()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "Wählen sie eine Organisation!"
        self.navigationItem.searchController?.searchBar.placeholder = "Organisations Suche"
        self.navigationItem.searchController?.searchBar.tintColor = .white
        
        
    }
}


extension OrgaTableViewViewController: UITableViewDelegate {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelectOrgaDelegate(filteredData[indexPath.row])
        do{
            equipmentData?.userdata?.organisation = (filteredData[indexPath.row])
            tableView.reloadData()
            try context.save()
        }catch{print(error)}
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrgaTableViewViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt
                   indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrgaCell") as! OrgaTableViewCell
        
        if (filteredData[indexPath.row] == equipmentData?.userdata?.organisation ?? ""){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = filteredData[indexPath.row]
        
        return cell
    }
    
    //MARK: Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       filteredData = []
        
        if searchText == "" {
            filteredData = orgaToFiltered()
        }
        for organisation in orga {
            if organisation.organisation.lowercased().contains(searchText.lowercased()){
                
                filteredData.append(organisation.organisation)
            }
        }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredData = []
        filteredData = orgaToFiltered()
        self.tableView.reloadData()
    }
    
    
    
    func orgaToFiltered() -> [String]{
        
        for i in 0...orga.count-1 {
            filteredData.append(orga[i].organisation)
            
        }
        
        return filteredData
    }
    
    
    
}
