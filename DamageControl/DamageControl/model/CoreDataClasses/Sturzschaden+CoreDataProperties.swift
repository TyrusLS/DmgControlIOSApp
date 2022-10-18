//
//  Sturzschaden+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 07.04.22.
//
//

import Foundation
import CoreData


extension Sturzschaden {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sturzschaden> {
        return NSFetchRequest<Sturzschaden>(entityName: "Sturzschaden")
    }

    @NSManaged public var details: String?
    @NSManaged public var height: String?
    @NSManaged public var checked: Bool
    @NSManaged public var equipmentdata: EquipmentData?
    @NSManaged public var sturzDevice: NSSet?

}

// MARK: Generated accessors for sturzDevice
extension Sturzschaden {

    @objc(addSturzDeviceObject:)
    @NSManaged public func addToSturzDevice(_ value: SturzDevice)

    @objc(removeSturzDeviceObject:)
    @NSManaged public func removeFromSturzDevice(_ value: SturzDevice)

    @objc(addSturzDevice:)
    @NSManaged public func addToSturzDevice(_ values: NSSet)

    @objc(removeSturzDevice:)
    @NSManaged public func removeFromSturzDevice(_ values: NSSet)

}

extension Sturzschaden : Identifiable {

}
