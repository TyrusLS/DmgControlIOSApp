//
//  SonstigeFunktion+CoreDataProperties.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 07.04.22.
//
//

import Foundation
import CoreData


extension SonstigeFunktion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SonstigeFunktion> {
        return NSFetchRequest<SonstigeFunktion>(entityName: "SonstigeFunktion")
    }

    @NSManaged public var name: String?
    @NSManaged public var sonstigeFunktion: Sonstigerschaden?

}

extension SonstigeFunktion : Identifiable {

}
