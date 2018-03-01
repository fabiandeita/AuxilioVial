//
//  RegistroVC.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 19/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import CoreData

class RegistroVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    @IBOutlet weak var nombreTF:UITextField!
    @IBOutlet weak var paternoTF: UITextField!
    @IBOutlet weak var maternoTF: UITextField!
    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var entidadPV: UIPickerView!
    @IBOutlet weak var contrasenaTF: UITextField!
    @IBOutlet weak var contrasenaConfirmTF: UITextField!
    let alert = Alert()
    let strings = Strings()
    let sincronizador = Sincronizador()
    var pickerData: [EntidadFederativa] = [EntidadFederativa]()
    var entidad:EntidadFederativa? = nil
    var urlServicioRegistro:String = ""
    
    
    override func viewDidLoad() {
        urlServicioRegistro = "\(strings.servidor)\(strings.puerto)\(strings.contexto)/\(strings.SERVICE_POST_REGISTRO)"
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //let managedObjectContext = appDelegate!.persistentContainer.viewContext
        //sincronizador.managedObjectContext = appDelegate!.persistentContainer.viewContext
        let entidades = sincronizador.getEntidadesFederativas("EntidadFederativa") as? [EntidadFederativa]
        
        if(entidades == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else{
            let sortedEntidadesFederativasArray = entidades?.sorted(by: { (entidad , entidad2) -> Bool in
                return entidad.idEntidadFederativa.int16Value < entidad2.idEntidadFederativa.int16Value
            })
            entidad = sortedEntidadesFederativasArray![0]
            for entidad in sortedEntidadesFederativasArray!{
                pickerData.append(entidad)
            }
            //pickerData.sort()
            self.entidadPV.delegate = self
            self.entidadPV.dataSource = self
        }
        
        
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].nombre
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        entidad = pickerData[row]
        print( pickerData[row])
    }
    
    @IBAction func enviarBtn(_ sender: Any) {
        if Conexion.isConnectedToNetwork(){
            let nombre: String? = nombreTF.text
            let paterno: String? = paternoTF.text
            let materno: String? = maternoTF.text
            let correo: String? = correoTF.text
            //let entidad: String? = entidadPV.text
            let contrasena: String? = contrasenaTF.text
            let confirmContrasena: String? = contrasenaConfirmTF.text
            if validacionFormulario(nombre, paterno, materno, correo, contrasena, confirmContrasena) && validacionContrasena(contrasena, confirmContrasena){
                //codigo para registrar con json
                var jsonRequest = [String:Any]()
                jsonRequest["nombre"] = nombre
                jsonRequest["ap"] = paterno
                jsonRequest["am"] = materno
                jsonRequest["correo"] = correo
                jsonRequest["contrasenia"] = contrasena
                jsonRequest["idEntidad"] = entidad!.idEntidadFederativa
                do{
                    let jsonResponse = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
                    var request = URLRequest(url: URL(string:urlServicioRegistro)!)
                    print(urlServicioRegistro)
                    request.httpMethod = "POST"
                    request.httpBody = jsonResponse
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    let task = URLSession.shared.dataTask(with: request) { (datos, respuesta, error) in
                        if error != nil {
                            print ("Error en el registro de usuario \(error!)")
                            print ("Respuesta: \(String(describing: respuesta))")
                            DispatchQueue.main.sync(execute: {
                                self.present(self.alert.mostrarAlertaSencilla(titulo : self.strings.TITULO_REGISTRO_FALLIDO, mensaje : self.strings.MENSAJE_REGISTRO_FALLIDO), animated: true, completion: nil)
                            })
                        }else{
                            do{//se convierte la respuesta del servicio en un json
                                let respuesta = try JSONSerialization.jsonObject(with: datos! , options:
                                    JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                                print(respuesta)
                                let idUsuario:Int = (respuesta["idUsuario"]! as? Int)!
                                print(idUsuario)
                                print(idUsuario)
                                DispatchQueue.main.sync(execute: {
                                    if idUsuario == 666{
                                        self.present(self.alert.mostrarAlertaSencilla(titulo : self.strings.TITULO_REGISTRO_EXITOSO, mensaje : self.strings.MENSAJE_REGISTRO_EXITOSO), animated: true, completion: nil)
                                        self.limpiarFormulario()
                                    }else{
                                        self.present(self.alert.mostrarAlertaSencilla(titulo : self.strings.TITULO_REGISTRO_FALLIDO, mensaje : self.strings.MENSAJE_REGISTRO_FALLIDO), animated: true, completion: nil)
                                    }
                                })
                            }catch {
                                print("El Procesamiento del JSON tuvo un error \(error)")
                                //mandar popup de que hubo error, :No se econtro el servidor, problema de conexino, etc
                            }
                        }
                    }
                    task.resume()
                }catch{
                    print("El Procesamiento del JSON tuvo un error 2 \(error)")
                }
            }
        }else{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ADVERTENCIA, mensaje : strings.MENSAJE_SIN_INTERNET), animated: true, completion: nil)
        }
    }
    
    func limpiarFormulario() {
        nombreTF.text = ""
        paternoTF.text = ""
        maternoTF.text = ""
        correoTF.text = ""
        //entidadPV.
        contrasenaTF.text = ""
        contrasenaConfirmTF.text = ""
        
    }
    func validacionFormulario(_ nombre:String?,_ paterno:String?,_ materno:String?,_ correo:String?,_ contrasena:String?,_ confirmContrasena:String?) -> Bool{
        if nombre!.isEmpty || paterno!.isEmpty || materno!.isEmpty || correo!.isEmpty || contrasena!.isEmpty || confirmContrasena!.isEmpty{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_CAPTURE_CAMPOS), animated: true, completion: nil)
            return false
        }
        if entidad == nil || entidad!.nombre == "Seleccione"
        {
            return false
        }
        return true
    }
    
    func validacionContrasena(_ contrasena:String?,_ confirmContrasena:String?) -> Bool{
       
        if contrasena! != confirmContrasena!{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_COINCIDENCIA_CONTRASENAS), animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
}
