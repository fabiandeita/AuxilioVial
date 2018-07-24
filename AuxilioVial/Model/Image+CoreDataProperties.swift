//
//  Image+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Fabian on 06/05/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var idImage: Int16
    @NSManaged public var value: String?
    @NSManaged public var auxvial: Auxvial?

}
