//
//  ReusableCell.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 16.03.22.
//

import UIKit

class ReusableCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var clicked : Bool!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

/*
 let nsFetchRequest = NSFetchRequest<EquipmentData>(entityName: "EquipmentData")
 nsFetchRequest.predicate = NSPredicate(format: "id = %@", device)
 return nsFetchRequest
 */
