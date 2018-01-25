//
//  Carretera+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 18/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Carretera {

    @NSManaged var idCarretera: NSNumber
    @NSManaged var origen: String
    @NSManaged var destino: String
    @NSManaged var idEntidadFederativa: NSNumber

}
