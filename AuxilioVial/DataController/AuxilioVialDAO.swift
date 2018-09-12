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
        
        
        let keypathExp = NSExpression(forKeyPath: "syncSer") // can be any column
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSDictionary>(entityName:"Auxvial")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["syncSer"]
        request.propertiesToFetch = ["syncSer", countDesc]
        request.predicate = NSPredicate(format: "idClase == 1 and syncSer == false")
        request.resultType = .dictionaryResultType
        
        let results = try! managedObjectContext.fetch(request)
        /*print( "Resultado: \(results.description)" )
        for data in results as! [NSManagedObject] {
            print(data.value(forKey: "username") as! String)
        }*/
        
        return 0;
    }
    
    func findAuxvial(_ sincServ:Bool, _ clase:Int16 ) -> Int16?{
        
        
        let keypathExp = NSExpression(forKeyPath: "syncSer") // can be any column
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSDictionary>(entityName:"Auxvial")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["syncSer"]
        request.propertiesToFetch = ["syncSer", countDesc]
        request.predicate = NSPredicate(format: "idClase == \(clase) and syncSer == \(sincServ)")
        request.resultType = .dictionaryResultType
        
        let results = try! managedObjectContext.fetch(request)
        //print( "Resultado: \(results.description)" )
        if(results.count > 0){
            let r = results[0]
            if(results.count > 0){
                //print( "Resultado: \( r.value(forKey: "count"))" )
                return r.value(forKey: "count") as! Int16
            }
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
    
    func getAuxiliovial() ->[AnyObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        //userFetch.fetchLimit = 1
        let entitys = try! managedObjectContext?.fetch(fetchRequest)
        return entitys!
    }
    
    func getAuxiliovialConsulta(incidentes:Bool, accidentes:Bool,_ dateTextFieldInicial:String,_ dateTextFieldFinal:String) ->[AnyObject]?{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        // Add Predicates
        var predicate1 : NSPredicate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        
        var predicates = [NSPredicate]()
        if(incidentes && accidentes){
            predicate1 = NSPredicate(format: "idClase == 1 or idClase == 2")
            predicates.append(predicate1);
        }else if(!incidentes && !accidentes){
            predicate1 = NSPredicate(format: "idClase != 1 and idClase != 2")
            predicates.append(predicate1);
        }else if(accidentes){
            predicate1 = NSPredicate(format: "idClase == 2")
            predicates.append(predicate1);
        }else if(incidentes){
            predicate1 = NSPredicate(format: "idClase == 1")
            predicates.append(predicate1);
        }
        if(!dateTextFieldInicial.isEmpty){
            var newDate = dateFormatter.date(from: dateTextFieldInicial)
            let predicate3 = NSPredicate(format: "fechacreacion >= %@", newDate! as NSDate)
            predicates.append(predicate3);
        }
        if(!dateTextFieldFinal.isEmpty){
            var newDate = dateFormatter.date(from: dateTextFieldFinal)
            let predicate4 = NSPredicate(format: "fechacreacion <= %@", newDate! as NSDate)
            predicates.append(predicate4);
        }
        if(predicates.isEmpty || predicates.count > 0){
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func findAllAuxiliovial() ->[AnyObject]?{ 
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    } 
    
    func getAuxvialByIdAuxvial (_ idAuxvial:Int16) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        // Add Predicate
        let predicate1 = NSPredicate(format: "idauxvial == \(idAuxvial)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        
        
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func getAuxvialByIcveSer (icveSer:Int16) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Auxvial")
        // Add Predicate
        let predicate1 = NSPredicate(format: "icveSer == \(icveSer)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        
        
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }

}
