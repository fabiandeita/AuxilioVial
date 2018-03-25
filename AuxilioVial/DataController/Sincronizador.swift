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
    var auxvialDAO:AuxilioVialDAO = AuxilioVialDAO()
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
    
    func getIdEntidadFederativa() -> Int{
        return UserDefaults.standard.integer(forKey: "idEntidad")
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
            if(!descargaEntidadesFederativas()){
                return false
            }
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "OrienVisib"){
            if(!descargaOrigenVisible()){
                return false
            }
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Lado"){
            if(!descargaLado()){
                return false
            }
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Clase"){
            if(!descargaClase()){
                return false
            }
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "TipoEsp"){
            //descargaTipoEsp()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Cuerpo"){
            if(!descargaCuerpo()){
                return false
            }
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Tipo"){
            //descargaTipo()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "SubTipo"){
            //descargaSubTipos()
        }
        
        var localizacion:Localizacion?
        localizacion = Localizacion()
        return false
    }
    
    func isCatalogosDescargados () -> Bool{
        //el metodo isCatalogoDescargado devuelve true o false, si ya existe en los defaults del usuario, el nombre de algun catalogo descargado. el siguiente IF se repite para cada catalogo, solo se cambia el tipo de entidad a sincronizar
        if !isCatalogoDescargado(estaAlmacenado: "EntidadFederativa"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "OrienVisib"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Lado"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Clase"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "TipoEsp"){
            //descargaTipoEsp()
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Cuerpo"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "Tipo"){
            return false
        }
        
        if !isCatalogoDescargado(estaAlmacenado: "SubTipo"){
            return false
        }
        return true
    }
    
    
    func descargaAuxvialByEntidad(_ entidadId:Int){
        let urlAuxvial = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_AUXVIAL)"
        let objetoURL  = URL(string:urlAuxvial)//Se crea la url del servicio
        //print ("Se descargaran Subtipos")
        //Se crea el json que contiene la entidad que se enviara para solicitar los tramos, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["identidad"] =  "\(entidadId)"  
        jsonRequest["nombre"] =  ""
        jsonRequest["clave"] =  ""
        jsonRequest["activo"] =  nil
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
                    print ("Error en la consulta de Auxvial \(error!)")
                    print ("Respuesta: \(respuesta)")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let auxvialesJson = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran Auxvial
                        let auxiliovialEntity = NSEntityDescription.entity(forEntityName: "Auxvial", in: self.managedObjectContext)!
                        for auxJson in auxvialesJson {
                            let aux = self.auxvialDAO.getAuxvialByIdAuxvial(auxJson["idauxvial"]! as! Int16)
                            if aux?.count == 0{
                                //Se genera un Auxvial de Core Data - Auxvial.swift y se rellena con la info del json
                                let auxilioVial = Auxvial(entity: auxiliovialEntity, insertInto: self.managedObjectContext)
                                auxilioVial.altitud = auxJson["altitud"]! as! Double
                                auxilioVial.danioCamino = auxJson["danioCamino"]! as? String
                                auxilioVial.descripcion = auxJson["descripcion"]! as? String
                                auxilioVial.durEvento = auxJson["durEvento"]! as? String
                                auxilioVial.fechaConoc = auxJson["fechaConoc"]! as? Date
                                auxilioVial.fechacreacion = auxJson["fechacreacion"]! as? Date
                                auxilioVial.fuenteInf = auxJson["fuenteInf"]! as? String
                                auxilioVial.idCuerpo = auxJson["idCuerpo"]! as! Int16
                                auxilioVial.idLado = auxJson["idLado"]! as! Int16
                                auxilioVial.idOrienVisible = auxJson["idOrienVisible"]! as! Int16
                                auxilioVial.idSubtipo = auxJson["idSubtipo"]! as! Int16
                                auxilioVial.idTipoEsp = auxJson["idTipoEsp"]! as! Int16
                                auxilioVial.idTramo = auxJson["idTramo"]! as! NSNumber
                                auxilioVial.idauxvial = auxJson["idauxvial"]! as! Int16
                                auxilioVial.kmFinal = auxJson["kmFinal"]! as? String
                                auxilioVial.kmInicio = auxJson["kmInicio"]! as? String
                                auxilioVial.latitud = auxJson["latitud"]! as! Double
                                auxilioVial.lesionados = auxJson["lesionados"]! as? String
                                auxilioVial.longitud = auxJson["longitud"]! as! Double
                                auxilioVial.muertos = auxJson["muestos"]! as? String
                                auxilioVial.observaciones = auxJson["observaciones"]! as? String
                                auxilioVial.residenteVial = auxJson["residenteVial"]! as? String
                                auxilioVial.vehiculo = auxJson["vehiculo"]! as? String
                                auxilioVial.vehiculosInvolucrados = auxJson["vehiculosInvolucrados"]! as? String
                            }
                            //print ("Auxvial: \(auxJson)")
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                            UserDefaults.standard.set(true, forKey: "Auxvial")
                        } catch {
                            UserDefaults.standard.set(false, forKey: "Auxvial")
                            fatalError("Failure to save context in Auxvial, with error: \(error)")
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
        
    }
    
    func descargaSubTipos(_ clase:Clase){
        let urlTipos = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_SUBTIPO)"
        let objetoURL  = URL(string:urlTipos)//Se crea la url del servicio
        //print ("Se descargaran Subtipos")
        //Se crea el json que contiene la entidad que se enviara para solicitar los tramos, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["idclase"] =  clase.idClase
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
                    print ("Error en la consulta de los subtipos \(error!)")
                    print ("Respuesta: \(respuesta)")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let subtiposJson = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran tipos
                        let subtipoEntity = NSEntityDescription.entity(forEntityName: "SubTipo", in: self.managedObjectContext)!
                        //print ("carreteras: \(carreteras)")
                        for subtipoJson in subtiposJson {
                            //Se genera un aentidad de Core Data - Carretera.swift y se rellena con la info del json
                            let subtipo = SubTipo(entity: subtipoEntity, insertInto: self.managedObjectContext)
                            subtipo.idSubtipo = subtipoJson["idsubtipo"]! as! Int16
                            subtipo.nombre = subtipoJson["nombre"]! as! String
                            subtipo.clase = subtipoJson["clase"]! as! Int16
                            print ("SubTipo: \(subtipo.nombre)")
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                            UserDefaults.standard.set(true, forKey: "SubTipo")
                        } catch {
                            UserDefaults.standard.set(false, forKey: "SubTipo")
                            fatalError("Failure to save context in Tipo, with error: \(error)")
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
        
    }
    
    func descargaTipoEspecifico(_ tipo:Tipo){
        let urlTipos = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_TIPO_ESPECIFICO)"
        let objetoURL  = URL(string:urlTipos)//Se crea la url del servicio
        //print ("Se descargaran TipoEspecifico")
        //Se crea el json que contiene la entidad que se enviara para solicitar los tramos, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["idtipo"] =  tipo.idTipo
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
                    print ("Error en la consulta de los TipoEspecifico \(error!)")
                    print ("Respuesta: \(respuesta)")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let tiposEspecificosJson = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran tipos
                        let tipoEspEntity = NSEntityDescription.entity(forEntityName: "TipoEsp", in: self.managedObjectContext)!
                        //print ("carreteras: \(carreteras)")
                        for tipoEspecificoJson in tiposEspecificosJson {
                            //Se genera un aentidad de Core Data - Carretera.swift y se rellena con la info del json
                            let tipoEsp = TipoEsp(entity: tipoEspEntity, insertInto: self.managedObjectContext)
                            tipoEsp.idtipoEsp = tipoEspecificoJson["idtipoEsp"]! as! Int16
                            tipoEsp.tipo = tipoEspecificoJson["tipo"]! as! Int16
                            tipoEsp.nombre = tipoEspecificoJson["nombre"]! as! String
                            print ("TipoEsp: \(tipoEsp.nombre)")
                            print ("tipo: \(tipoEsp.nombre)")
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                            UserDefaults.standard.set(true, forKey: "TipoEsp")
                        } catch {
                            UserDefaults.standard.set(false, forKey: "TipoEsp")
                            fatalError("Failure to save context in Tipo, with error: \(error)")
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
        
    }
    
    func descargaTipos(_ clase:Clase){
        let urlTipos = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_TIPO)"
        let objetoURL  = URL(string:urlTipos)//Se crea la url del servicio
        //print ("Se descargaran TIPOS")
        //Se crea el json que contiene la entidad que se enviara para solicitar los tramos, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["idclase"] =  clase.idClase
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
                    print ("Error en la consulta de los tipos \(error!)")
                    print ("Respuesta: \(respuesta)")
                }else{
                    do{//se convierte la respuesta del servicio en un json
                        let tiposJson = try JSONSerialization.jsonObject(with: datos! , options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                        //Se le dice a CoreData que se almacenaran tipos
                        let tipoEntity = NSEntityDescription.entity(forEntityName: "Tipo", in: self.managedObjectContext)!
                        //print ("carreteras: \(carreteras)")
                        for tipoJson in tiposJson {
                            //Se genera un aentidad de Core Data - Carretera.swift y se rellena con la info del json
                            let tipo = Tipo(entity: tipoEntity, insertInto: self.managedObjectContext)
                            tipo.idTipo = tipoJson["idtipo"]! as! NSNumber
                            tipo.clase = tipoJson["clase"]! as! NSNumber
                            tipo.nombre = tipoJson["nombre"] as! String
                            self.descargaTipoEspecifico(tipo)
                            print ("Tipo: \(tipo.nombre)")
                        }
                        // Save
                        do {
                            try self.managedObjectContext.save()
                            UserDefaults.standard.set(true, forKey: "Tipo")
                        } catch {
                            UserDefaults.standard.set(false, forKey: "Tipo")
                            fatalError("Failure to save context in Tipo, with error: \(error)")
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
        
    }
   
    func descargaClase () ->  Bool{
        var exito = false
        let urlServicioClase = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_CLASE)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioClase!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta de CLASE")
            }else{
                do{
                    //Casteamos el resultado a un diccionario, para despues recorrerlo
                    let clasesJ = try JSONSerialization.jsonObject(with: datos! , options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    let claseEntity = NSEntityDescription.entity(forEntityName: "Clase", in: self.managedObjectContext)!
                    for claseJ in clasesJ {
                        let clase = Clase(entity: claseEntity, insertInto: self.managedObjectContext)
                        clase.idClase = claseJ["idclase"]! as! NSNumber
                        clase.nombre = claseJ["nombre"]! as? String
                        print("Clase: \(clase.nombre)")
                        self.descargaTipos(clase)
                        self.descargaSubTipos(clase)
                    }
                    // Save
                    do {
                        try self.managedObjectContext.save()
                        print("Clase sincronizados")
                        UserDefaults.standard.set(true, forKey: "Clase")
                        exito=true
                    } catch {
                        UserDefaults.standard.set(false, forKey: "Clase")
                        fatalError("Failure to save context in Clase, with error: \(error)")
                    }
                }catch{
                    print("error: ")
                    print(error)
                }
            }
            
        }
        tarea.resume()
        return exito
    }
    
    
    func descargaLado ()-> Bool {
        var exito=false
        let urlServicioLado = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_LADO)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioLado!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta de Lado")
            }else{
                do{
                    let lados = try JSONSerialization.jsonObject(with: datos! , options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    let ladoEntity = NSEntityDescription.entity(forEntityName: "Lado", in: self.managedObjectContext)!
                    for ladoJ in lados {
                        let lado = Lado(entity: ladoEntity, insertInto: self.managedObjectContext)
                        lado.idLado = ladoJ["idlado"]! as! Int16
                        lado.nombre = ladoJ["nombre"]! as! String
                    }
                    // Save
                    do {
                        try self.managedObjectContext.save()
                        print("Lados sincronizados")
                        UserDefaults.standard.set(true, forKey: "Lado")
                        exito=true
                    } catch {
                        UserDefaults.standard.set(false, forKey: "Lado")
                        fatalError("Failure to save context in Lado, with error: \(error)")
                    }
                }catch{
                    print("error: ")
                    print(error)
                }
            }
            
        }
        tarea.resume()
        return exito
    }
    
    func descargaCuerpo ()-> Bool {
        var exito = false
        let urlServicioCuerpo = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_CUERPO)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioCuerpo!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta de Cuerpo")
            }else{
                do{
                    //Casteamos el resultado a un diccionario, para despues recorrerlo
                    let cuerposJ = try JSONSerialization.jsonObject(with: datos! , options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    let cuerpoEntity = NSEntityDescription.entity(forEntityName: "Cuerpo", in: self.managedObjectContext)!
                    for cuerpoJ in cuerposJ {
                        let cuerpo = Cuerpo(entity: cuerpoEntity, insertInto: self.managedObjectContext)
                        cuerpo.idCuerpo = cuerpoJ["idcuerpo"]! as! Int16
                        cuerpo.nombre = cuerpoJ["nombre"]! as! String
                    }
                    // Save
                    do {
                        try self.managedObjectContext.save()
                        print("Cuerpo sincronizados")
                        UserDefaults.standard.set(true, forKey: "Cuerpo")
                        exito=true
                    } catch {
                        UserDefaults.standard.set(false, forKey: "Cuerpo")
                        fatalError("Failure to save context in Cuerpo, with error: \(error)")
                    }
                }catch{
                    print("error: ")
                    print(error)
                }
            }
            
        }
        tarea.resume()
        return exito
    }
    
    func isCatalogoDescargado(estaAlmacenado nombre: String) -> Bool{
        return UserDefaults.standard.bool(forKey: nombre)
           
    }
    
    func descargaOrigenVisible () ->Bool{
        var exito = false;
        let urlServicioOrigenVisib = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_ORIENVISIB)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioOrigenVisib!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta del origen")
            }else{
                do{
                    let origenesVisibles = try JSONSerialization.jsonObject(with: datos! , options:
                        JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    let origenVisibleEntity = NSEntityDescription.entity(forEntityName: "OrienVisib", in: self.managedObjectContext)!
                    for origen in origenesVisibles {
                        let origenVisible = OrienVisib(entity: origenVisibleEntity, insertInto: self.managedObjectContext)
                        origenVisible.idOrienVisib = origen["orienVisib"]! as! Int16
                        origenVisible.nombre = origen["nombre"]! as! String
                        print(origenVisible.nombre)
                    }
                    // Save
                    do {
                        try self.managedObjectContext.save()
                        UserDefaults.standard.set(true, forKey: "OrienVisib")
                        print("OrienVisib sincronizados")
                        return true;
                    } catch {
                        UserDefaults.standard.set(false, forKey: "OrienVisib")
                        fatalError("Failure to save context in OrigenVisible, with error: \(error)")
                    }
                }catch{
                    print("error: ")
                    print(error)
                }
            }
            
        }
        tarea.resume()
        return exito;
    }
    
    
    func descargaEntidadesFederativas () -> Bool{
        var exito = false
        let urlServicioEntidades = URL(string: "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_GET_ENTIDADFEDERATIVA)" );
        let tarea = URLSession.shared.dataTask(with: urlServicioEntidades!){
            (datos, respuesta, error) in
            if error != nil {
                print ("Error en la consulta de las entidades")
                exito =  false
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
                        print("EntidadFederativa sincronizados")
                        exito =  true
                    } catch {
                        UserDefaults.standard.set(false, forKey: "EntidadFederativa")
                        fatalError("Failure to save context in Entidades Federativas, with error: \(error)")
                        exito =  false
                    }
                }catch{
                    print(error)
                    exito =  false
                }
            }
        }
        tarea.resume()
        
        return exito
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
                            self.descargaTramo(urlServicioTramos, idCarretera)
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
                            tramo.origen = tramoJson["origen"]! as? String
                            tramo.destino = tramoJson["destino"]! as? String
                            
                            print ("idTramo: \(tramo.idTramo)")
                            print ("Tramo: \(tramo.origen)")
                            print ("idCarretera: \(tramo.idCarretera)")
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
        let entitys = try! managedObjectContext.fetch(fetchRequest)
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
    
    func getAnyEntity (_ nombreEntidad:String) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:nombreEntidad)
        //userFetch.fetchLimit = 1
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func getCarreterasByEntidad (_ entidad:EntidadFederativa) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Carretera")
        //userFetch.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "idEntidadFederativa == %@", entidad.idEntidadFederativa)
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func getTramosByCarretera (_ carretera:Carretera) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Tramo")
        //userFetch.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "idCarretera == %@", carretera.idCarretera)
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
  
    func getTiposByClase (_ clase:Clase) ->[AnyObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Tipo")
        //userFetch.fetchLimit = 1//clase deberia llamarse idClase
        fetchRequest.predicate = NSPredicate(format: "clase == %@", clase.idClase)
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }

    func getTipoEspByTipo(tipo:Tipo) ->[AnyObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"TipoEsp")
        //userFetch.fetchLimit = 1//clase deberia llamarse idClase
        fetchRequest.predicate = NSPredicate(format: "tipo == %@", tipo.idTipo)
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
    func getSubTipoByClase(clase:Clase) ->[AnyObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"SubTipo")
        //userFetch.fetchLimit = 1//clase deberia llamarse idClase
        fetchRequest.predicate = NSPredicate(format: "clase == %@", clase.idClase)
        let entitys = try! managedObjectContext.fetch(fetchRequest)
        return entitys
    }
    
}
