//
//  Alert.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 17/01/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import Foundation
import UIKit
public class Alert{
    
    func mostrarAlertaSencilla(titulo titulo:String, mensaje mensaje:String) -> UIViewController{
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Aceptar", style: .default){
            (action: UIAlertAction) -> Void in }
        alerta.addAction(cancelar)
        return alerta;
    }
    
    
    
}
