//
//  Tramo+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 19/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Tramo {

    @NSManaged var idTramo: Int16
    @NSManaged var origen: String?
    @NSManaged var destino: String?
    @NSManaged var idCarretera: NSNumber
    @NSManaged var relationship: Carretera?

}
