//
//  DetailVC.swift
//  AuxilioVial
//
//  Created by Fabian on 11/09/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    var auxilio : Auxvial?
    
    @IBOutlet weak var entidadPV: UIPickerView!
    @IBOutlet weak var carreteraPV: UIPickerView!
    @IBOutlet weak var trampPV: UIPickerView!
    @IBOutlet weak var cuerpoPV: UIPickerView!
    @IBOutlet weak var kmInicialTF: UITextField!
    @IBOutlet weak var kmFinalTF: UITextField!
    @IBOutlet weak var ladoPV: UIPickerView!
    @IBOutlet weak var sentidoPV: UIPickerView!
    @IBOutlet weak var altitudTF: UITextField!
    @IBOutlet weak var latitudTF: UITextField!
    @IBOutlet weak var longitudTF: UITextField!
    @IBOutlet weak var clasePV: UIPickerView!
    @IBOutlet weak var tipoPV: UIPickerView!
    @IBOutlet weak var causaPV: UIPickerView!
    @IBOutlet weak var tipoEspPV: UIPickerView!
    @IBOutlet weak var descripcionTF: UITextField!
    @IBOutlet weak var fuenteTF: UITextField!
    @IBOutlet weak var lesionadosTF: UITextField!
    @IBOutlet weak var muertosTF: UITextField!
    @IBOutlet weak var vehiculosInvTF: UITextField!
    @IBOutlet weak var vehiculoTF: UITextField!
    @IBOutlet weak var daniosTF: UITextField!
    @IBOutlet weak var residenteTF: UITextField!
    @IBOutlet weak var fechaTF: UITextField!
    @IBOutlet weak var duracionTF: UITextField!
    @IBOutlet weak var tiempoEspTF: UITextField!
    @IBOutlet weak var observacionesTF: UITextField!
    @IBOutlet weak var imagenesCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kmInicialTF.text = auxilio?.kmInicio
        kmFinalTF.text = auxilio?.kmFinal
        altitudTF.text = String((auxilio?.altitud)!)
        latitudTF.text = String((auxilio?.latitud)!)
        longitudTF.text = String((auxilio?.longitud)!)
        descripcionTF.text = auxilio?.descripcion
        fuenteTF.text = auxilio?.fuenteInf
        lesionadosTF.text = String((auxilio?.lesionados)!)
        muertosTF.text = String((auxilio?.muertos)!)
        vehiculosInvTF.text = auxilio?.vehiculosInvolucrados
        vehiculoTF.text = auxilio?.vehiculo
        daniosTF.text = auxilio?.danioCamino
        residenteTF.text = auxilio?.residenteVial
        fechaTF.text = auxilio?.fechaConoc?.description
        duracionTF.text = auxilio?.durEvento
        observacionesTF.text = auxilio?.observaciones
        
        // Do any additional setup after loading the view.
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
