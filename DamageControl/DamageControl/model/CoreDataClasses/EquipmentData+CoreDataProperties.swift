//
//  EquipmentData+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 31.03.22.
//
//

import Foundation
import CoreData


extension EquipmentData {

    @nonobjc public class func fetchRequest(device: String) -> NSFetchRequest<EquipmentData> {
        let nsFetchRequest = NSFetchRequest<EquipmentData>(entityName: "EquipmentData")
        nsFetchRequest.predicate = NSPredicate(format: "id = %@", device)
        return nsFetchRequest
    }

    @NSManaged public var id: String?
    @NSManaged public var sonstigerschaden: Sonstigerschaden?
    @NSManaged public var sturzschaden: Sturzschaden?
    @NSManaged public var userdata: UserData?

}

extension EquipmentData : Identifiable {

}
