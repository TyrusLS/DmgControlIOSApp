//
//  OrgaTableViewCell.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 09.03.22.
//

import UIKit

class OrgaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
