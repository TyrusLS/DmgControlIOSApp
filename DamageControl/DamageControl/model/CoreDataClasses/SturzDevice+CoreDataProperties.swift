//
//  SturzDevice+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 07.04.22.
//
//

import Foundation
import CoreData


extension SturzDevice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SturzDevice> {
        return NSFetchRequest<SturzDevice>(entityName: "SturzDevice")
    }

    @NSManaged public var name: String?
    @NSManaged public var sturzDeviceRel: Sturzschaden?

}

extension SturzDevice : Identifiable {

}
