//
//  Tipo+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Fabian on 24/07/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Tipo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tipo> {
        return NSFetchRequest<Tipo>(entityName: "Tipo")
    }

    @NSManaged public var clase: Int16
    @NSManaged public var idTipo: Int16
    @NSManaged public var nombre: String?

}
