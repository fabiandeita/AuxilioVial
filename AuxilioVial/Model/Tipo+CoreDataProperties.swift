//
//  Tipo+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 19/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Tipo {

    @NSManaged var idTipo: Int16
    @NSManaged var nombre: String?
    @NSManaged var clase: Int16

}
