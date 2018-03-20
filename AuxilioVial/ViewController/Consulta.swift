//
//  Consulta.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 19/03/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit

class Consulta: UIViewController {

    @IBOutlet weak var dateTextFieldInicial: UITextField!
    @IBOutlet weak var dateTextFieldFinal: UITextField!
    @IBOutlet weak var incidentesUISwitch: UISwitch!
    @IBOutlet weak var accidentesUISwitch: UISwitch!
    
    var formatter:DateFormatter? = nil
    
    @IBAction func buscar(_ sender: Any) {
    }
    
    @IBAction func descargarServidor(_ sender: Any) {
        
    }
    @IBAction func verMapa(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializaDatePickers()
        incidentesUISwitch.setOn(false, animated: true)
        accidentesUISwitch.setOn(false, animated: true)
        
        // Do any additional setup after loading the view.
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
