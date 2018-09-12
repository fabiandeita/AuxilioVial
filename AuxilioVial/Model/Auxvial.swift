//
//  Auxvial+CoreDataClass.swift
//  AuxilioVial
//
//  Created by Fabian on 06/05/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


public class Auxvial: NSManagedObject {

}

// MARK: Generated accessors for image
extension Auxvial {
    
    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Image)
    
    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Image)
    
    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)
    
    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)
    
}
