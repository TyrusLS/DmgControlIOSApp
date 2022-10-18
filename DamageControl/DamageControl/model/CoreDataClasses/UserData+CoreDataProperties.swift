//
//  UserData+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 31.03.22.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var kennzeichen: String?
    @NSManaged public var nachname: String?
    @NSManaged public var organisation: String?
    @NSManaged public var rufname: String?
    @NSManaged public var vorname: String?
    @NSManaged public var equipmentdata: EquipmentData?

}

extension UserData : Identifiable {

}
