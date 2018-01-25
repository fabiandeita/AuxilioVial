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
    
    
    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var paternoTF: UITextField!
    @IBOutlet weak var maternoTF: UITextField!
    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var entidadPV: UIPickerView!
    @IBOutlet weak var contrasenaTF: UITextField!
    @IBOutlet weak var contrasenaConfirmTF: UITextField!
    let alert = Alert()
    let strings = Strings()
    let sincronizador = Sincronizador()
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //let managedObjectContext = appDelegate!.persistentContainer.viewContext
        //sincronizador.managedObjectContext = appDelegate!.persistentContainer.viewContext
        let entidades = sincronizador.getEntidadesFederativas("EntidadFederativa") as? [EntidadFederativa]
        if(entidades == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else{
            for entidad in entidades!{
                pickerData.append(entidad.nombre)
            }
            pickerData.sort()
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
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print( pickerData[row])
    }
    
    @IBAction func enviarBtn(_ sender: Any) {
        let nombre: String? = nombreTF.text
        let paterno: String? = paternoTF.text
        let materno: String? = maternoTF.text
        let correo: String? = correoTF.text
        //let entidad: String? = entidadPV.text
        let contrasena: String? = contrasenaTF.text
        let confirmContrasena: String? = contrasenaConfirmTF.text
        if validacionFormulario(nombre, paterno, materno, correo, contrasena, confirmContrasena) && validacionContrasena(contrasena, confirmContrasena){
            //codigo para registrar con json
        }
        
    }
    
    func validacionFormulario(_ nombre:String?,_ paterno:String?,_ materno:String?,_ correo:String?,_ contrasena:String?,_ confirmContrasena:String?) -> Bool{
        if nombre!.isEmpty && paterno!.isEmpty && materno!.isEmpty && correo!.isEmpty && contrasena!.isEmpty && confirmContrasena!.isEmpty{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_CAPTURE_CAMPOS), animated: true, completion: nil)
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
