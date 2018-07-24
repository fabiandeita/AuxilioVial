//
//  Consulta.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 19/03/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit

class Consulta: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateTextFieldInicial: UITextField!
    @IBOutlet weak var dateTextFieldFinal: UITextField!
    @IBOutlet weak var incidentesUISwitch: UISwitch!
    @IBOutlet weak var accidentesUISwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    var listaAux:[AnyObject]?
    var formatter:DateFormatter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializaDatePickers()
        tableView.delegate = self
        tableView.dataSource = self
        
        //incidentesUISwitch.setOn(false, animated: true)
        //accidentesUISwitch.setOn(false, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaAux != nil{
            return (listaAux?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        let auxvi = listaAux![indexPath.row] as! Auxvial
        cell.textLabel?.text  = auxvi.descripcion
        
        return cell
    }
    
    
    @IBAction func Busqueda(_ sender: Any) {
        
        let aux:AuxilioVialDAO = AuxilioVialDAO()
        let fechaInicial = dateTextFieldInicial.text!
        let fechaFinal = dateTextFieldFinal.text!
        
        self.listaAux = aux.getAuxiliovialConsulta(incidentes: accidentesUISwitch.isOn, accidentes: incidentesUISwitch.isOn, fechaInicial.description, fechaFinal.description)
        
        for auxVial in listaAux!{
            print ("Descripcion: " + (auxVial  as! Auxvial).descripcion!)
            print ((auxVial  as! Auxvial).danioCamino)
        }
        tableView.reloadData()
        print ("Auxvial size: \(String(describing: listaAux?.count))")
    }
    
    @IBAction func descargarServidor(_ sender: Any) {
        let  sincronizador:Sincronizador = Sincronizador()
        sincronizador.descargaAuxvialByEntidad(18)
        
    }
    
    @IBAction func verMapa(_ sender: Any) {
    }
    
    func inicializaDatePickers(){
        formatter = DateFormatter()
        formatter?.dateStyle = DateFormatter.Style.medium
        formatter?.timeStyle = DateFormatter.Style.none
        
        //FechaInicial
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(Consulta.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateTextFieldInicial.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(Consulta.donePressed(sender:)))
        toolbar.setItems([doneButton], animated: true)
        
        dateTextFieldInicial.inputAccessoryView = toolbar
        
        //FechaFinal
        let datePickerFinal = UIDatePicker()
        
        datePickerFinal.datePickerMode = UIDatePickerMode.date
        datePickerFinal.addTarget(self, action: #selector(Consulta.datePickerFinalValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateTextFieldFinal.inputView = datePickerFinal
        
        let toolbarFinal = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbarFinal.barStyle = UIBarStyle.blackTranslucent
        toolbarFinal.tintColor = UIColor.white
        
        let doneFinalButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(Consulta.donePressedFinal(sender:)))
        toolbarFinal.setItems([doneFinalButton], animated: true)
        
        dateTextFieldFinal.inputAccessoryView = toolbarFinal
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func donePressed(sender: UIBarButtonItem) {
        dateTextFieldInicial.resignFirstResponder()
    }
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        dateTextFieldInicial.text = formatter?.string(from: sender.date)
    }
    
    @objc func donePressedFinal(sender: UIBarButtonItem) {
        dateTextFieldFinal.resignFirstResponder()
    }
    
    
    @objc func datePickerFinalValueChanged(sender: UIDatePicker) {
        dateTextFieldFinal.text = formatter?.string(from: sender.date)
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
