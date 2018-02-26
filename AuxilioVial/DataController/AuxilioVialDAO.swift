//
//  AuxilioVialDAO.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 17/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AuxilioVialDAO {
    var strings = Strings()
    var managedObjects:[NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var alert = Alert()
    var appDelegate:AppDelegate
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func getAnyEntity (_ nombreEntidad:String) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:nombreEntidad)
        //userFetch.fetchLimit = 1
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func getAuxVialCount() -> Int16{
        return 0;
    }
    
    func findIncidentesPorSinc() -> Int16?{
        let query = "select a.* from AUXVIAL as a  INNER JOIN Tipo_Esp AS TE ON A.icveTipoEsp = TE.icve " +
        " INNER JOIN Tipo AS T ON TE.icvetipo = T.icve " +
        " where a.syncser <> 1 AND T.icveclase = 1 ";
        
        let countExpressionDesc = NSExpressionDescription()
        countExpressionDesc.name = "countAnimals"
        countExpressionDesc.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "syncSer")])
        countExpressionDesc.expressionResultType = NSAttributeType.integer32AttributeType
        
        let request = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        
        request.propertiesToFetch = [ "syncSer", countExpressionDesc]
        request.propertiesToGroupBy = ["syncSer", "syncSer"]
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.predicate = NSPredicate(format: "accidenteIncidente == %@", 0)
        
        let results = try! managedObjectContext.execute(request)
        //print( "Resultado: \(results)" )
        if let results = results as? [NSDictionary] {
            print( "Resultado: \(results)" )
        }
         
        return 0;
    }
    
    func findIncidentesSincronizados() -> Int16?{
        let query = "select a.* from AUXVIAL as a  INNER JOIN Tipo_Esp AS TE ON A.icveTipoEsp = TE.icve " +
        " INNER JOIN Tipo AS T ON TE.icvetipo = T.icve " +
        " where a.syncser = 1 AND T.icveclase = 1 ";
        return 0;
    }
    
    func findAccidentesPorSinc() -> Int16?{
    let query = "select a.* from AUXVIAL as a  INNER JOIN Tipo_Esp AS TE ON A.icveTipoEsp = TE.icve " +
    " INNER JOIN Tipo AS T ON TE.icvetipo = T.icve " +
    " where a.syncser = 1 AND T.icveclase = 2 ";
        return 0;
    }
    
    func findAccidentesSincronizados() -> Int16?{
    let query = "select a.* from AUXVIAL as a  INNER JOIN Tipo_Esp AS TE ON A.icveTipoEsp = TE.icve " +
    " INNER JOIN Tipo AS T ON TE.icvetipo = T.icve " +
    " where a.syncser <> 1 AND T.icveclase = 2 ";
        return 0;
    }

}
