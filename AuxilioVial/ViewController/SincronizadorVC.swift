//
//  SincronizadorVC.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 17/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit

class SincronizadorVC: UIViewController {
    var json: [String:Any]?
    var hayIncidenciasParaSinc:Bool = false
    var auxVialDAO = AuxilioVialDAO()
    let alert = Alert()
    let strings = Strings()
    var total:Int16 = 0
    var incSincronizadas:Int16 = 0
    var incPorSinc:Int16 = 0
    var accSincronizados:Int16 = 0
    var accPorSinc:Int16 = 0
    var totalInc:Int16 = 0
    var totalAc:Int16 = 0
    
    @IBOutlet weak var incSincronizadasLabel: UILabel!
    @IBOutlet weak var incPorSincronizarLabel: UILabel!
    @IBOutlet weak var incTotalesLabel: UILabel!
    
    @IBOutlet weak var accSincronizadosLabel: UILabel!
    @IBOutlet weak var accPorSincronizarLabel: UILabel!
    @IBOutlet weak var accTotaltesLabel: UILabel!
    @IBOutlet weak var sincronizarUIBtn: UIButton!
    
    @IBAction func sincronizarBtn(_ sender: Any) {
        if Conexion.isConnectedToNetwork(){
            
        }else{
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ADVERTENCIA, mensaje : strings.MENSAJE_SIN_INTERNET), animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cargaEstadisticas()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargaEstadisticas(){
        for auxilio in (auxVialDAO.getAuxiliovial()  as? [Auxvial])!{
            print(auxilio.kmInicio)
            print("Imagenes: \(auxilio.image?.count)")
            
        }
        
        incSincronizadas = auxVialDAO.findAuxvial(true,1)!;
        incPorSinc = auxVialDAO.findAuxvial(false,1)!;
        
        accSincronizados = auxVialDAO.findAuxvial(true,2)!;
        accPorSinc = auxVialDAO.findAuxvial(false,2)!;
        
        totalInc = incSincronizadas + incPorSinc
        totalAc = accSincronizados + accPorSinc
        
        incSincronizadasLabel.text = incSincronizadas.description
        incPorSincronizarLabel.text = incPorSinc.description
        incTotalesLabel.text = totalInc.description
        
        accSincronizadosLabel.text = accSincronizados.description
        accPorSincronizarLabel.text = accPorSinc.description
        accTotaltesLabel.text = totalAc.description
        
        if (incPorSinc +  accPorSinc) > 0{
            sincronizarUIBtn.isEnabled = true;
        }
        else{
            sincronizarUIBtn.isEnabled = false;
        }
        
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
