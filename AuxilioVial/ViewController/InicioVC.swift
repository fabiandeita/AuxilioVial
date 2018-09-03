//
//  InicioViewController.swift
//  AuxilioVial
//
//  Created by Fabian on 30/04/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit

class InicioVC: UIViewController {
    var sincronizador = Sincronizador()
    let alert = Alert()
    let strings = Strings()
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var texto1Label: UILabel!
    @IBOutlet weak var text2Label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sincronizador.inicioVC = self
        nextButton.isEnabled = false
        progressView.progress = 0
        indicator.startAnimating()
        if(!sincronizador.isCatalogosDescargados()){
            if Conexion.isConnectedToNetwork(){
                sincronizador.descargaEntidadesFederativas(self, progressView)
                /*sincronizador.descargaOrigenVisible(self, progressView)
                sincronizador.descargaLado(self, progressView)
                sincronizador.descargaClase(self, progressView)
                sincronizador.descargaCuerpo(self, progressView)*/
            }
            
        }
 
    }
    
    @IBAction func continueToLogin(_ sender: Any) {
        if(sincronizador.isCatalogosDescargados()){
            self.performSegue(withIdentifier: "loginScreenSegue", sender: "")
        }
    }
    
    public func stopAnimateIndicator(){
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func updateProgressView(percent: Float){
        progressView.progress = progressView.progress + percent
        
    }
    
    func percentProgressView() -> Float{
        return progressView.progress
        
    }
    
    func showMessageErrorLoadCatalogos(){
        present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SINCRONIZAR_CATALOGO), animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(sincronizador.isCatalogosDescargados()){
            self.performSegue(withIdentifier: "loginScreenSegue", sender: "")
        }
        if !Conexion.isConnectedToNetwork(){
            texto1Label.text = "Conéctese a internet"
            text2Label.text = "y reinicie la aplicación."
            nextButton.isHidden = true
            present(alert.mostrarAlertaSencilla(titulo : strings.TITULO_ERROR_VALIDACION, mensaje : strings.MENSAJE_SIN_INTERNET), animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    

}
