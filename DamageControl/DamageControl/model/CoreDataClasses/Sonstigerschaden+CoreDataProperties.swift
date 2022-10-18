//
//  Sonstigerschaden+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 07.04.22.
//
//

import Foundation
import CoreData


extension Sonstigerschaden {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sonstigerschaden> {
        return NSFetchRequest<Sonstigerschaden>(entityName: "Sonstigerschaden")
    }

    @NSManaged public var details: String?
    @NSManaged public var checked: Bool
    @NSManaged public var equipmentData: EquipmentData?
    @NSManaged public var sonstigeFunktion: NSSet?

}

// MARK: Generated accessors for sonstigeFunktion
extension Sonstigerschaden {

    @objc(addSonstigeFunktionObject:)
    @NSManaged public func addToSonstigeFunktion(_ value: SonstigeFunktion)

    @objc(removeSonstigeFunktionObject:)
    @NSManaged public func removeFromSonstigeFunktion(_ value: SonstigeFunktion)

    @objc(addSonstigeFunktion:)
    @NSManaged public func addToSonstigeFunktion(_ values: NSSet)

    @objc(removeSonstigeFunktion:)
    @NSManaged public func removeFromSonstigeFunktion(_ values: NSSet)

}

extension Sonstigerschaden : Identifiable {

}
