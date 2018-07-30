//
//  Clase+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Fabian on 24/07/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Clase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clase> {
        return NSFetchRequest<Clase>(entityName: "Clase")
    }

    @NSManaged public var idClase: Int16
    @NSManaged public var nombre: String?

}
