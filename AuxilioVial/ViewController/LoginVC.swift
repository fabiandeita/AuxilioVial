//
//  ViewController.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 24/12/17.
//  Copyright © 2017 Iris Viridiana. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController {
    @IBOutlet weak var ingresarButton: UIButton!
    @IBOutlet weak var usuatioTF: UITextField!
    @IBOutlet weak var contrasenaTF: UITextField!
    @IBOutlet weak var btnRegistro: UIButton!
    var strings = Strings()
    var sincronizador = Sincronizador()
    var json: [String:Any]?
    let alert = Alert()
     
    
    override func viewDidLoad() {
        if(sincronizador.isCatalogosDescargados()){
            btnRegistro.isHidden = false
            ingresarButton.isHidden = false
        }else{
            btnRegistro.isHidden = true
            ingresarButton.isHidden = true
            if(Conexion.isConnectedToNetwork()){
                sincronizador.descargaCatalogos()
            }else{
                present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_INTERNET), animated: true, completion: nil)
            }
            if(sincronizador.isCatalogosDescargados()){
                btnRegistro.isHidden = false
                ingresarButton.isHidden = false
            }else{
                present(alert.mostrarAlertaSencilla(titulo : strings.MENSAJE_SIN_ACCESO_SERVIDOR, mensaje : strings.MENSAJE_SIN_CATALOGOS), animated: true, completion: nil)
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnIngresar(_ sender: UIButton) {
        if(sincronizador.isCatalogosDescargados()){
            //Se guarda en constantes las credenciales escritas desde el formulario
            let usuario: String? = usuatioTF.text
            let contrasena: String? = contrasenaTF.text
            if usuario!.isEmpty || contrasena!.isEmpty {//Se valida que ambos campos tengan algun texto
                /*let alerta = UIAlertController(title: strings.titulo_error_validacion, message: strings.mensaje_capture_credenciales, preferredStyle: .alert)
                let cancelar = UIAlertAction(title: "Aceptar", style: .default){
                    (action: UIAlertAction) -> Void in }
                alerta.addAction(cancelar)*/
                present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_CAPTURE_CREDENCIALES), animated: true, completion: nil)
                //print("Usuario o contraseña invalida!")//crear popup
            }else if self.sincronizador.existeUsuarioAlmacenado(usuario!){
                print ("Login local")
                //CODIGO DEL LOGIN LOCAL, REVISANDO USSUARIOS REGITRADOS PREVIAMENTE EN EL ARCHIVO DEFAULT
                if self.sincronizador.loginLocal(correo: usuario!, password: contrasena!) {
                    self.performSegue(withIdentifier: "pantallaTableroSegue", sender: "")
                }else{
                    print ("Login Invalido")
                    //popup
                }
            }else if self.sincronizador.existeOtroUsuarioAlmacenado(diferente:usuario!){
                if logueoServidor(usuario!, contrasena!){//logeo mediante el servidor
                    //Unicamente actualizo las carreteras y tramos del nuevo usuario
                }
            }else {
                logueoServidor(usuario!, contrasena!)
            }
        }else{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_CATALOGOS), animated: true, completion: nil)
        }
    }
    
    func actualizarUsuarioDefault(_ json: [String:Any]) -> Bool{
        self.sincronizador.asignarUsuario(json)
        print("Se agrega usuario al Default")
        return true
    }
        
    func logueoServidor (_ usuario:String, _ contrasena:String) -> Bool{
        let direccionLogin = "\(strings.servidor)\(strings.puerto)\(strings.contexto)\(strings.SERVICE_POST_ACCESO)"
        let objetoURL  = URL(string:direccionLogin)//Se crea la url del servicio
        //Se crea el json que contiene el usuario y contraseña a validar, para enviarlo en la peticion
        var jsonRequest = [String:Any]()
        jsonRequest["correo"] = usuario
        jsonRequest["contrasenia"] = contrasena
        var exito = false;
        do{
            //Se arma el cuerpo de la peticiòn a enviar y la respuesta se asignara a jsonResponse
            let jsonResponse = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
            var request = URLRequest(url: objetoURL!)
            request.httpMethod = "POST"
            request.httpBody = jsonResponse
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //Se tarea pa poder ejecutar la peticion
            let task = URLSession.shared.dataTask(with: request) { (datos, respuesta, error) in
                if error != nil {
                    //present(alert.mostrarAlertaSencilla(titulo : strings.titulo_error_validacion, mensaje : strings.mensaje_capture_credenciales), animated: true, co22mpletion: nil)
                    self.present(self.alert.mostrarAlertaSencilla(titulo : self.strings.TITULO_ERROR_VALIDACION, mensaje : self.strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
                    print(error!)//Si hay error en la conexion se imprime el error
                }else{
                    do{//Bloque para cachar errores
                        //Se almacena en un json la respuesta de la peticion o request
                        var json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        //Se toma del json el valor de la llave scces y se almacena en una constante bolelana llamada acceso
                        let acceso = json["acces"] as! Bool
                        //Se hace la validació del logueo
                        if acceso {
                            DispatchQueue.main.sync(execute: {
                                json["usuario"] = usuario
                                json["contrasena"] = contrasena
                                self.actualizarUsuarioDefault(json)
                                self.performSegue(withIdentifier: "pantallaTableroSegue", sender: json)
                                exito = true;
                            })
                        }
                    }catch {
                        print("El Procesamiento del JSON tuvo un error")
                        //mandar popup de que hubo error, :No se econtro el servidor, problema de conexino, etc
                    }
                }
            }
            task.resume()
        }catch {
            print("Error casteando la respuesta")
        }
        
        return exito
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let ussuario = sender as! String
        if segue.identifier == "pantallaTableroSegue"{
            let objPantallTablero: TableroControlVC = segue.destination as! TableroControlVC
            //objPantallTablero.json = sender as? [String : Any]!
        }
    }
    
}

