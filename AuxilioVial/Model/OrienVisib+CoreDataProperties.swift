//
//  OrigenVisible+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 11/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension OrienVisib {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrienVisib> {
        return NSFetchRequest<OrienVisib>(entityName: "OrienVisib")
    }

    @NSManaged public var idOrienVisib: Int16
    @NSManaged public var nombre: String?

}
