//
//  Auxvial+CoreDataProperties.swift
//  AuxilioVial
//
//  Created by Fabian on 06/05/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//
//

import Foundation
import CoreData


extension Auxvial {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Auxvial> {
        return NSFetchRequest<Auxvial>(entityName: "Auxvial")
    }

    @NSManaged public var accidenteIncidente: Int16
    @NSManaged public var altitud: Double
    @NSManaged public var conversionExitosa: Bool
    @NSManaged public var danioCamino: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var durEvento: String?
    @NSManaged public var fechaConoc: NSDate?
    @NSManaged public var fechacreacion: NSDate?
    @NSManaged public var fuenteInf: String?
    @NSManaged public var icveSer: Int16
    @NSManaged public var idauxvial: Int16
    @NSManaged public var idCuerpo: Int16
    @NSManaged public var idClase: Int16
    @NSManaged public var idLado: Int16
    @NSManaged public var idOrienVisible: Int16
    @NSManaged public var idSubtipo: Int16
    @NSManaged public var idTipoEsp: Int16
    @NSManaged public var idTramo: Int16
    @NSManaged public var kmFinal: String?
    @NSManaged public var kmInicio: String?
    @NSManaged public var latitud: Double
    @NSManaged public var lesionados: Int16
    @NSManaged public var longitud: Double
    @NSManaged public var muertos: Int16
    @NSManaged public var observaciones: String?
    @NSManaged public var residenteVial: String?
    @NSManaged public var syncSer: Bool
    @NSManaged public var tiempoRespuesta: String?
    @NSManaged public var vehiculo: String?
    @NSManaged public var vehiculosInvolucrados: String?
    @NSManaged public var image: NSSet?

}


