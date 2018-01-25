//
//  Sincronizador.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 13/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Sincronizador {
    var strings = Strings()
    var managedObjects:[NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var alert = Alert()
    var appDelegate:AppDelegate
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    //Sincroniza la parte del usuario, localmente, almacenandolo por primera vez, para evitar loguearse siempre usando la web
    func asignarUsuario(_ json: [String:Any]) -> Bool{
        do{
            let usuario = json["usuario"] as! String
            let contrasena = json["contrasena"] as! String
            let estatus = json["estatus"] as! Int
            let acces = json["acces"] as! Bool
            let idEntidad = json["idEntidad"] as! Int
            
            //Se almacenan los datos default del usuario que se logea
            UserDefaults.standard.set(usuario, forKey: "usuario")
            UserDefaults.standard.set(contrasena, forKey: "contrasena")
            UserDefaults.standard.set(estatus, forKey: "estatus")
            UserDefaults.standard.set(acces, forKey: "acces")
            
            //Si el usuario
            if UserDefaults.standard.integer(forKey: "idEntidad") != idEntidad {
                print ("Descargando catálogo Carretera")
                UserDefaults.standard.set(idEntidad, forKey: "idEntidad")
                descargaCarreteras()
            }
            UserDefaults.standard.set(idEntidad, forKey: "idEntidad")
        }catch{
            return false
        }
        return true
    }
    
    func loginLocal(correo usuario:String, password contrasena: String) -> Bool{
        /*print ( usuario )
        print ( contrasena )
        print (UserDefaults.standard.string(forKey: "usuario")!)
        print (UserDefaults.standard.string(fodescargarrKey: "contrasena")!)*/
        if UserDefaults.standard.string(forKey: "usuario") != nil && UserDefaults.standard.string(forKey: "contrasena") != nil
            && UserDefaults.standard.string(forKey: "usuario")! == usuario && UserDefaults.standard.string(forKey: "contrasena")! == contrasena {
            return true
        }else{
            return false
        }
    }
        
    func existeUsuarioAlmacenado (_ usuario:String) -> Bool{
        if UserDefaults.standard.string(forKey: "usuario") != nil && UserDefaults.standard.string(forKey: "usuario")! == usuario {
            return true
        }else{
            return false
        }
    }
    
    func existeOtroUsuarioAlmacenado (diferente usuario:String) -> Bool{
        //PREGUNTO AL ARCHIVO DONDE GUARDE EL USUARIO Y CONTRASE, SI YA HAY UN USUARIO GUARDADO DIFERENTE AL QUE LE PASO
        //POR EL FORMULARIO
        if UserDefaults.standard.string(forKey: "usuario") != nil && UserDefaults.standard.string(forKey: "usuario")! != usuario {
            return true
        }else{
            return false
        }
    }
    //Descarga de catálogos
    
    func descargaCatalogos () -> Bool{
        //el metodo isCatalogoDescargado devuelve true o false, si ya existe en los defaults del usuario, el nombre de algun catalogo descargado. el siguiente IF se repite para cada catalogo, solo se cambia el tipo de entidad a sincronizar
        if !isCatalogoDescargado(estaAlmacenado: "EntidadFederativa"){
            //print ("Descargando catálogo EntidadFederativa")
            //Servicio que descarga EntidadesFederativas
            descargaEntidadesFederativas()
        }
        
        //Aqui le sigues Viri
        if !isCatalogoDescargado(estaAlmacenado: "OrigenVisible"){
            //descargaOrigenVisible()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Lado"){
            //descargaLado()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Clase"){
            //descargaClase()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "TipoEsp"){
            //descargaTipoEsp()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Cuerpo"){
            //descargaCuerpo()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Tipo"){
            //descargaTipo()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "ESubTipo"){
            //descargaSubTipo()
        }
        
        
        
        /*Estos catalogos se descargaran cuando se loge el usuario, ya que hasta ese punto sabremos de que entidad es, igualmente si se logea otro usuario se actualizaran las tablas de carretera y tramo.
       if !isCatalogoDescargado(estaAlmacenado: "Carretera"){
            print ("Descargando catálogo Carretera")
            descargaCarreteras()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Tramo"){
            print ("Descargando catálogo Tramo")
            descargaTramos()
        }
        */
        //Continua la descarga de catalogos, revisar codigo fuente para desarga de catalogos por post y por get, ya que cambia el código
        
        return false
    }
    
    func isCatalogoDescargado(estaAlmacenado nombre: String) -> Bool{
        if UserDefaults.standard.bool(forKey: nombre){
            return true;
        }
        return false;
    }
    
    func descargaOrigenVisible () -> Bool{
        let urlServicioOrigenVisib = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_ORIENTACION)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioOrigenVisib!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta del origen")
            }else{
            }
            
        }
        return false
    }
            
            
            
            
    
    func descargaEntidadesFederativas () -> Bool{
        let urlServicioEntidades = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_ENTIDADFEDERATIVA)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioEntidades!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta de las entidades")
            }else{
                do{
                    let entidades = try JSONSerialization.jsonObject(with: datos! , options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    let entidadFederativaEntity = NSEntityDescription.entity(forEntityName: "EntidadFederativa", in: self.managedObjectContext)!
                    for entidad in entidades {
                        let entidadFederativa = EntidadFederativa(entity: entidadFederativaEntity, insertInto: self.managedObjectContext)
                        entidadFederativa.idEntidadFederativa = entidad["identidad"]! as! NSNumber
                        entidadFederativa.nombre = entidad["nombre"]! as! String
                    }
                    // Save
                    do {
                        try self.managedObjectContext.save()
                        UserDefaults.standard.set(true, forKey: "EntidadFederativa")
                    } catch {
                        UserDefaults.standard.set(false, forKey: "EntidadFederativa")
                        fatalError("Failure to save context in Entidades Federativas, with error: \(error)")
                    }
                }catch{
                    print("error: ")
                    print(error)
                }
            }
        }
        tarea.resume()
        
        return true
    }
    
    func descargaCarreteras () -> Bool{
        let urlServicioCarreteras = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_CARRETERA)"
        let objetoURL  = URL(string:urlServicioCarreteras)//Se crea la url del servicio
        print ("Se descargaran carreteras")
        //Se crea el json que contiene la entidad que se enviara para solicitar las carreteras, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["identidad"] = "18"
        var exito = false;
        do{
            //Se arma el cuerpo de la peticiòn a enviar y la respuesta se asignara a jsonResponse
            let jsonResponse = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
            var request = URLRequest(url: objetoURL!)
            request.httpMethod = "POST"
            request.httpBody = jsonResponse
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            // tarea para poder ejecutar la peticion
            let task = URLSession.shared.dataTask(with: request) { (datos, respuesta, error) in
                if error != nil {
                    print ("Error en la consulta de las carreteras \(error!)")
                    print ("Respuesta: \(String(describing: respuesta))")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let carreteras = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran Carreteras
                        let carreteraEntity = NSEntityDescription.entity(forEntityName: "Carretera", in: self.managedObjectContext)!
                        //print ("carreteras: \(carreteras)")
                        let urlServicioTramos = "\(self.strings.servidor)\(self.strings.puerto)\(self.strings.contexto)\(self.strings.SERVICE_POST_TRAMO)"
                        var idCarretera: NSNumber = 0
                        UserDefaults.standard.set(true, forKey: "Carretera")
                        for car in carreteras {
                            //Se almacena el id de la carretera
                            idCarretera = car["idcarretera"]! as! NSNumber
                            //print ("Se descarga carretera - JSON: \(car)")
                            //print ("Se descarga carretera: \(idCarretera)")
                            //Se descargan os tramos de dicha carretera
                            //self.descargaTramo(urlServicioTramos, idCarretera)
                            //Se genera un aentidad de Core Data - Carretera.swift y se rellena con la info del json
                            //let carretera = NSManagedObject(entity: carreteraEntity, insertInto: managedObjectContext)
                            let carretera = Carretera(entity: carreteraEntity, insertInto: self.managedObjectContext)
                            carretera.idCarretera = car["idcarretera"]! as! NSNumber
                            carretera.origen = car["origen"]! as! String
                            carretera.destino = car["destino"]! as! String
                            carretera.idEntidadFederativa = UserDefaults.standard.integer(forKey: "idEntidad") as! NSNumber
                            
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            UserDefaults.standard.set(false, forKey: "Carretera")
                            fatalError("Failure to save context in Carretera, with error: \(error)")
                        }
                        
                    }catch {
                        print("El Procesamiento del JSON tuvo un error \(error)")
                        //mandar popup de que hubo error, :No se econtro el servidor, problema de conexino, etc
                    }
                }
            }
            task.resume()
        }catch {
            print("Error casteando la respuesta")
        }
        return true
    }
    
    func descargaTramo (_ urlServicioTramos:String, _ idCarretera:NSNumber) -> Bool{
        let objetoURL  = URL(string:urlServicioTramos)//Se crea la url del servicio
        print ("Se descargaran tramos")
        //Se crea el json que contiene la entidad que se enviara para solicitar los tramos, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["idcarretera"] =  idCarretera
        var exito = false;
        do{
            //Se arma el cuerpo de la peticiòn a enviar y la respuesta se asignara a jsonResponse
            let jsonResponse = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
            var request = URLRequest(url: objetoURL!)
            request.httpMethod = "POST"
            request.httpBody = jsonResponse
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            // tarea para poder ejecutar la peticion
            let task = URLSession.shared.dataTask(with: request) { (datos, respuesta, error) in
                if error != nil {
                    print ("Error en la consulta de los tramos \(error!)")
                    print ("Respuesta: \(respuesta)")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let tramosJson = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran Carreteras
                        let tramoEntity = NSEntityDescription.entity(forEntityName: "Tramo", in: self.managedObjectContext)!
                        //print ("carreteras: \(carreteras)")
                        for tramoJson in tramosJson {
                            //Se genera un aentidad de Core Data - Carretera.swift y se rellena con la info del json
                            print ("Se descarga tramo - JSON: \(tramoJson)")
                            print ("Se descarga carretera: \(idCarretera)")
                            
                            let tramo = Tramo(entity: tramoEntity, insertInto: self.managedObjectContext)
                            tramo.idCarretera = tramoJson["carretera"]! as! NSNumber
                            tramo.idTramo = tramoJson["idtramo"]! as! NSNumber
                            tramo.origen = tramoJson["origen"]! as! String
                            tramo.destino = tramoJson["destino"]! as! String
                            print ("Tramo: \(tramo.origen)")
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                            UserDefaults.standard.set(true, forKey: "Tramo")
                        } catch {
                            UserDefaults.standard.set(false, forKey: "Tramo")
                            fatalError("Failure to save context in Tramo, with error: \(error)")
                        }
                    }catch {
                        print("El Procesamiento del JSON tuvo un error \(error)")
                        //mandar popup de que hubo error, :No se econtro el servidor, problema de conexino, etc
                    }
                }
            }
            task.resume()
        }catch {
            print("Error casteando la respuesta")
        }
        return true
        
    }
    
    
    func getEntidadesFederativas (_ nombreEntidad:String) ->[AnyObject]?{
        
        //Leer las entidades de la base
        //let userFetch = NSFetchRequest<EntidadFederativa>(entityName: entidad)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:nombreEntidad)
        //userFetch.fetchLimit = 1
        let entitys = try! managedObjectContext.fetch(fetchRequest) as? [AnyObject]
        return entitys
        
        /*var entidades :[AnyObject]? = nil
         do{
         entidades = try managedObjectContext.fetch(EntidadFederativa.fetchRequest()) as? [AnyObject]
         //print(entidades!)
         for e in entidades!{
         print ("Objeto:  \(entidades!)")
         }
         return entidades
         }catch{
         return entidades
         }*/
    }
    
    
    
}
