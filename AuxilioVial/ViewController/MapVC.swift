//
//  MapVC.swift
//  AuxilioVial
//
//  Created by Fabian on 28/07/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let aux:AuxilioVialDAO = AuxilioVialDAO()
    var listaAux:[AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.showsUserLocation = true
        
        self.listaAux = aux.findAllAuxiliovial()
        for aux in listaAux!{
            let location = CLLocationCoordinate2D(
                latitude: (aux  as! Auxvial).latitud, longitude: (aux  as! Auxvial).longitud
            )
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            if((aux  as! Auxvial).idClase == 1){
                annotation.title = "Incidente"
            }else{
                annotation.title = "Accidente"
            }
            annotation.subtitle = (aux  as! Auxvial).observaciones
            print("Observacion: \((aux  as! Auxvial).observaciones)")
            
            mapView.addAnnotation(annotation)
        }
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
