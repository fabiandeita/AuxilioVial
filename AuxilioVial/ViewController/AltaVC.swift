//
//  AltaVC.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 03/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import AVFoundation

class AltaVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var entidadPickerView: UIPickerView!
    @IBOutlet weak var carreteraPickerView: UIPickerView!
    @IBOutlet weak var tramoPickerView: UIPickerView!
    @IBOutlet weak var clasePickerView: UIPickerView!
    @IBOutlet weak var tipoPickerView: UIPickerView!
    @IBOutlet weak var tipoEspPickerView: UIPickerView!
    @IBOutlet weak var subTipoPickerView: UIPickerView!
    @IBOutlet weak var cuerpoPickerView: UIPickerView!
    @IBOutlet weak var ladoPickerView: UIPickerView!
    @IBOutlet weak var orienVisibPickerView: UIPickerView!
    
    
    @IBOutlet weak var latitudTF: UITextField!
    @IBOutlet weak var longitudTF: UITextField!
    @IBOutlet weak var altitudTF: UITextField!
    @IBOutlet weak var descripcionTF: UITextField!
    @IBOutlet weak var kmInicialTF: UITextField!
    @IBOutlet weak var kmFinalTF: UITextField!
    @IBOutlet weak var informacionTF: UITextField!
    @IBOutlet weak var lesionadosTF: UITextField!
    @IBOutlet weak var muertosTF: UITextField!
    @IBOutlet weak var vehiculoTF: UITextField!
    @IBOutlet weak var vehiculosInvolucradosTF: UITextField!
    @IBOutlet weak var danioCaminoTF: UITextField!
    @IBOutlet weak var vialidadTF: UITextField!
    @IBOutlet weak var respuestaTF: UITextField!
    @IBOutlet weak var actuacionesTF: UITextField!
    @IBOutlet weak var guardarBoton: UIButton!
    
    
    
    
    let alert = Alert()
    let strings = Strings()
    let sincronizador = Sincronizador()
    var pickerDataEntidad: [EntidadFederativa] = [EntidadFederativa]()
    var pickerDataCarretera: [Carretera] = [Carretera]()
    var pickerDataTramo: [Tramo] = [Tramo]()
    var pickerDataClase: [Clase] = [Clase]()
    var pickerDataTipo: [Tipo] = [Tipo]()
    var pickerDataTipoEsp: [TipoEsp] = [TipoEsp]()
    var pickerDataSubTipo: [SubTipo] = [SubTipo]()//Causa
    var pickerDataCuerpo: [Cuerpo] = [Cuerpo]()
    //Se contruye array de obetos del tipo LADO
    var pickerDataLado: [Lado] = [Lado]()
    var pickerDataOrienVisib: [OrienVisib] = [OrienVisib]()
    
    //Current values
    var entidad:EntidadFederativa? = nil
    var carretera:Carretera? = nil
    var tramo:Tramo? = nil
    var clase:Clase? = nil
    var tipo:Tipo? = nil
    var tipoEsp:TipoEsp? = nil
    var subTipo:SubTipo? = nil //Causa
    var cuerpo:Cuerpo? = nil
    //
    var lado:Lado? = nil
    var orienVisib:OrienVisib? = nil
    
    var urlServicioRegistro:String = ""
    var idEntidadFederativaUsuario: NSNumber = 0
    var auxilio : Auxvial?
    
    @IBAction func tomarFoto(_ sender: Any) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let image = UIImagePickerControllerSourceType.photoLibrary
            print("Accedio a la library")
        }else{
            print("No accedio a la library")
        }
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
            if granted {
                DispatchQueue.main.async {
                    UIImagePickerControllerSourceType.camera 
                }
            }
        })
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let image = UIImagePickerControllerSourceType.camera
        }else{
            print("No accedio a la camara")
        }
    }
    
    
    @IBAction func guardarBtn(_ sender: Any) {
        if validacionFormulario(){
            //Implementas el guardado
            auxilio?.idCuerpo = (cuerpo?.idCuerpo)!
            auxilio?.idTipoEsp = (tipoEsp?.idtipoEsp)!
            auxilio?.idSubtipo = (subTipo?.idSubtipo)!
            auxilio?.idLado = (lado?.idLado)!
            auxilio?.idTramo = (tramo?.idTramo)!
            auxilio?.idOrienVisible = (orienVisib?.idOrienVisib)!
            auxilio?.descripcion = (descripcionTF.text)!
            auxilio?.kmInicio = (kmInicialTF.text)!
            auxilio?.kmFinal = (kmFinalTF.text)!
            auxilio?.fuenteInf = (informacionTF.text)!
            auxilio?.residenteVial = (vialidadTF.text)!
            auxilio?.lesionados = (lesionadosTF.text)!
            auxilio?.muertos = (muertosTF.text)!
            auxilio?.vehiculo = (vehiculoTF.text)!
            auxilio?.vehiculosInvolucrados = (vehiculosInvolucradosTF.text)!
            auxilio?.danioCamino = (danioCaminoTF.text)!
            auxilio?.tiempoRespuesta = (respuestaTF.text)!
            auxilio?.observaciones = (actuacionesTF.text)!
            
        }
    }
    
    func validacionFormulario() -> Bool{
        
        if (descripcionTF.text?.isEmpty)!{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_DESCRIPCION), animated: true, completion: nil)
            return false
        }
        if (kmInicialTF.text?.isEmpty)!{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_KM_INICIO), animated: true, completion: nil)
            return false
        }
        if (kmFinalTF.text?.isEmpty)!{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_KM_FINAL), animated: true, completion: nil)
            return false
        }
        if (informacionTF.text?.isEmpty)!{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_FUENTE_INFO), animated: true, completion: nil)
            return false
        }
        if (lesionadosTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_LESIONADOS), animated: true, completion: nil)
            return false
        }
        if (muertosTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_MUERTOS), animated: true, completion: nil)
            return false
        }
        if (vehiculoTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_VEHICULO), animated: true, completion: nil)
            return false
        }
        if (vehiculosInvolucradosTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_VEHICULOS_INVOLUCRADOS), animated: true, completion: nil)
            return false
        }
        if (danioCaminoTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_DANIO_CAMINO), animated: true, completion: nil)
            return false
        }
        if (vialidadTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_RESIDENTE_VIAL), animated: true, completion: nil)
            return false
        }
        if (respuestaTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_TIEMPO_RESPUESTA), animated: true, completion: nil)
            return false
        }
        if (actuacionesTF.text?.isEmpty)!{
             present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_POR_FAVOR, mensaje : strings.MENSAJE_OBSERVACION), animated: true, completion: nil)
            return false
        }
        
        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if  entidadPickerView == pickerView{
            return pickerDataEntidad.count
        }
        if carreteraPickerView == pickerView{
            return pickerDataCarretera.count
        }
        if tramoPickerView == pickerView{
            return pickerDataTramo.count
        }
        if clasePickerView == pickerView{
            return pickerDataClase.count
        }
        if  tipoPickerView == pickerView{
            return pickerDataTipo.count
        }
        if tipoEspPickerView == pickerView{
            return pickerDataTipoEsp.count
        }
        if subTipoPickerView == pickerView{
            return pickerDataSubTipo.count
        }
        if cuerpoPickerView == pickerView{
            return pickerDataCuerpo.count
        }
        if ladoPickerView == pickerView{
            return pickerDataLado.count
        }
        if orienVisibPickerView == pickerView{
            return pickerDataOrienVisib.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == entidadPickerView{
            return pickerDataEntidad[row].nombre
        }
        if pickerView == carreteraPickerView{
            if pickerDataCarretera.count == 0{
                return ""
            }
            return pickerDataCarretera[row].origen + " - " + pickerDataCarretera[row].destino
        }
        if pickerView == tramoPickerView{
            if pickerDataTramo.count == 0{
                return ""
            }
            return pickerDataTramo[row].origen! + " - " + pickerDataTramo[row].destino!
        }
        if pickerView == clasePickerView{
            return pickerDataClase[row].nombre
        }
        if pickerView == tipoPickerView{
            return pickerDataTipo[row].nombre
        }
        if pickerView == tipoEspPickerView{
            return pickerDataTipoEsp[row].nombre
        }
        if pickerView == subTipoPickerView{
            return pickerDataSubTipo[row].nombre
        }
        if pickerView == cuerpoPickerView{
            return pickerDataCuerpo[row].nombre
        }
        if pickerView == ladoPickerView{
            return pickerDataLado[row].nombre
        }
        if pickerView == orienVisibPickerView{
            return pickerDataOrienVisib[row].nombre
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == entidadPickerView{
            pickerDataCarretera.removeAll()
            pickerDataTramo.removeAll()
            entidad = pickerDataEntidad[row]
            loadCarreteras(entidad!)
            //loadTramos(carretera!)
        }
        if pickerView == carreteraPickerView{
            pickerDataTramo.removeAll()
            if pickerDataCarretera.count > 0{
                carretera = pickerDataCarretera[row]
                loadTramos(carretera!)
            }
            
        }
        if pickerView == tramoPickerView{
            if pickerDataTramo.count > 0{
                tramo = pickerDataTramo[row]
            }
        }
        if pickerView == clasePickerView{
            if pickerDataClase.count > 0{
                clase = pickerDataClase[row]
                pickerDataTipo.removeAll()
                loadTipo(papa: clase!)
                loadSubTipo(papa: clase!)
                
            }
        }
        if pickerView == tipoPickerView{
            if pickerDataTipo.count > 0{
                tipo = pickerDataTipo[row]
            }
        }
        if pickerView == tipoEspPickerView{
            if pickerDataTipoEsp.count > 0{
                tipoEsp = pickerDataTipoEsp[row]
            }
        }
        if pickerView == subTipoPickerView{
            if pickerDataSubTipo.count > 0{
                subTipo = pickerDataSubTipo[row]
            }
        }
        if pickerView == cuerpoPickerView{
            if pickerDataCuerpo.count > 0{
                cuerpo = pickerDataCuerpo[row]
            }
        }
        if pickerView == ladoPickerView{
            if pickerDataLado.count > 0{
                lado = pickerDataLado[row]
                print (lado!.nombre)
            }
        }
        if pickerView == orienVisibPickerView{
            if pickerDataOrienVisib.count > 0{
                orienVisib = pickerDataOrienVisib[row]
            }
        }
        
    }
    
    override func viewDidLoad() {
        idEntidadFederativaUsuario = sincronizador.getIdEntidadFederativa() as NSNumber
        // Do any additional setup after loading the view.
        loadEntidades()
        loadClase()
        loadLado()
        loadOrienVisib()
        loadCuerpo()
        var localizacion:Localizacion?
        localizacion = Localizacion()
        guardarBoton.isEnabled = false
        super.viewDidLoad()
    }
    
    func loadSubTipo(papa clase:Clase){
        pickerDataSubTipo.removeAll()
        let subTipos = sincronizador.getSubTipoByClase(clase: clase) as? [SubTipo]
        if(subTipos == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if subTipos?.count != 0{
            let sortedSubTipoArray = subTipos?.sorted(by: { (subTipo , subTipo2) -> Bool in
                return subTipo.nombre! < subTipo2.nombre!
            })
            subTipo = sortedSubTipoArray![0]
            for subTipoTemp in sortedSubTipoArray!{
                pickerDataSubTipo.append(subTipoTemp)
            }
            //pickerData.sort()
            self.subTipoPickerView.delegate = self
            self.subTipoPickerView.dataSource = self
        }
    }
    
    func loadOrienVisib(){
        let orienVisibs = sincronizador.getAnyEntity("OrienVisib") as? [OrienVisib]
        if(orienVisibs == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if orienVisibs?.count != 0{
            let sortedOrienVisibsArray = orienVisibs?.sorted(by: { (orien , orien2) -> Bool in
                return orien.nombre! < orien2.nombre!
            })
            orienVisib = sortedOrienVisibsArray![0]
            for orienTemp in sortedOrienVisibsArray!{
                pickerDataOrienVisib.append(orienTemp)
            }
            //pickerData.sort()
            self.orienVisibPickerView.delegate = self
            self.orienVisibPickerView.dataSource = self
        }
    }
    
    func loadLado(){
        let lados = sincronizador.getAnyEntity("Lado") as? [Lado]
        if(lados == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if lados?.count != 0{
            let sortedLadoArray = lados?.sorted(by: { (Lado , Lado2) -> Bool in
                return Lado.nombre! < Lado2.nombre!
            })
            lado = sortedLadoArray![0]
            for LadoTemp in sortedLadoArray!{
                pickerDataLado.append(LadoTemp)
            }
            //pickerData.sort()
            self.ladoPickerView.delegate = self
            self.ladoPickerView.dataSource = self
        }
    }
    
    func loadCuerpo(){
        let cuerpos = sincronizador.getAnyEntity("Cuerpo") as? [Cuerpo]
        if(cuerpos == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if cuerpos?.count != 0{
            let sortedCuerpoArray = cuerpos?.sorted(by: { (cuerpo , cuerpo2) -> Bool in
                return cuerpo.nombre! < cuerpo2.nombre!
            })
            cuerpo = sortedCuerpoArray![0]
            for cuerpoTemp in sortedCuerpoArray!{
                pickerDataCuerpo.append(cuerpoTemp)
            }
            //pickerData.sort()
            self.cuerpoPickerView.delegate = self
            self.cuerpoPickerView.dataSource = self
        }
    }
    
    func loadClase(){
        let clases = sincronizador.getAnyEntity("Clase") as? [Clase]
        if(clases == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if clases?.count != 0{
            let sortedClasesArray = clases?.sorted(by: { (clase , clase2) -> Bool in
                return clase.nombre! < clase2.nombre!
            })
            clase = sortedClasesArray![0]
            loadTipo(papa: clase!)
            //cargar tipo
            for claseTemp in sortedClasesArray!{
                pickerDataClase.append(claseTemp)
            }
            //pickerData.sort()
            loadSubTipo(papa: clase!)
            self.clasePickerView.delegate = self
            self.clasePickerView.dataSource = self
        }
    }
   
    func loadTipo(papa clase:Clase){
        let tipos = sincronizador.getTiposByClase(clase) as? [Tipo]
        if(tipos == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if tipos?.count != 0{
            let sortedTiposArray = tipos?.sorted(by: { (tipo , tipo2) -> Bool in
                return tipo.nombre! < tipo2.nombre!
            })
            tipo = sortedTiposArray![0]
            for tipoTemp in sortedTiposArray!{
                pickerDataTipo.append(tipoTemp)
            }
            //pickerData.sort()
            loadTipoEsp(papa: tipo!)
            self.tipoPickerView.delegate = self
            self.tipoPickerView.dataSource = self
        }
    }
    
    func loadTipoEsp(papa tipo:Tipo){
        pickerDataTipoEsp.removeAll()
        let tipoEsps = sincronizador.getTipoEspByTipo(tipo:tipo) as? [TipoEsp]
        if(tipoEsps == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if tipoEsps?.count != 0{
            let sortedTipoEspArray = tipoEsps?.sorted(by: { (tipoEsp , tipoEsp2) -> Bool in
                return tipoEsp.nombre! < tipoEsp2.nombre!
            })
            tipoEsp = sortedTipoEspArray![0]
            for tipoEspTemp in sortedTipoEspArray!{
                pickerDataTipoEsp.append(tipoEspTemp)
            }
            //pickerData.sort()
            self.tipoEspPickerView.delegate = self
            self.tipoEspPickerView.dataSource = self
        }
    }
    
    func loadTramos(_ carretera:Carretera){
        pickerDataTramo.removeAll()
        let tramos = sincronizador.getTramosByCarretera(carretera) as? [Tramo]
        if(tramos == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if tramos?.count != 0{
            let sortedTramosArray = tramos?.sorted(by: { (tramo , tramo2) -> Bool in
                return tramo.origen! < tramo2.origen!
            })
            tramo = sortedTramosArray![0]
            for tramoTemp in sortedTramosArray!{
                pickerDataTramo.append(tramoTemp)
            }
            //pickerData.sort()
            self.tramoPickerView.delegate = self
            self.tramoPickerView.dataSource = self
        }
    }
    
    func loadCarreteras(_ entidad:EntidadFederativa){
        //let carreteras = sincronizador.getAnyEntity("Carretera") as? [Carretera]
        pickerDataCarretera.removeAll()
        let carreteras = sincronizador.getCarreterasByEntidad(entidad) as? [Carretera]
        if(carreteras == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else if carreteras?.count == 0{
            pickerDataCarretera.removeAll()
            pickerDataTramo.removeAll()
            carretera = nil
            tramo = nil
            
        }else if carreteras?.count != 0{
            let sortedCarreterasArray = carreteras?.sorted(by: { (carretera , carretera2) -> Bool in
                return carretera.idCarretera.int16Value < carretera.idCarretera.int16Value
            })
            carretera = sortedCarreterasArray![0]
            for carreteraTemp in sortedCarreterasArray!{
                pickerDataCarretera.append(carreteraTemp)
                loadTramos(carreteraTemp)
            }
            //pickerData.sort()
            self.carreteraPickerView.delegate = self
            self.carreteraPickerView.dataSource = self
        }
    }
    func loadEntidades(){
        let entidades = sincronizador.getEntidadesFederativas("EntidadFederativa") as? [EntidadFederativa]
        
        if(entidades == nil){
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_ACCESO_SERVIDOR), animated: true, completion: nil)
        }else{
            let sortedEntidadesFederativasArray = entidades?.sorted(by: { (entidad , entidad2) -> Bool in
                return entidad.idEntidadFederativa.int16Value < entidad2.idEntidadFederativa.int16Value
            })
            var c:Int = 0
            var posicion:Int = 0
            for entidadF in sortedEntidadesFederativasArray!{
                pickerDataEntidad.append(entidadF)
                if entidadF.idEntidadFederativa == idEntidadFederativaUsuario{
                    entidad = entidadF
                    posicion = c
                }
                c += 1
            }
            //pickerData.sort()
            self.entidadPickerView.delegate = self
            self.entidadPickerView.dataSource = self
            print(entidad!.idEntidadFederativa)
            print(entidad!.idEntidadFederativa as! Int)
            self.entidadPickerView.selectRow(posicion,inComponent: 0,  animated: true)
        }
        loadCarreteras(entidad!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
