//
//  ControlViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController, WebServiceProtocoloControl {
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    
    var libre : [String : [String : String]]?
    
    @IBOutlet weak var lblEstadoUILabel: UILabel!
    @IBOutlet weak var lblLlegadaRioUILabel: UILabel!
    @IBOutlet weak var lblLlegadaElectricaUILabel: UILabel!
    @IBOutlet weak var lblLlegadaWhalyUILabel: UILabel!
 
    @IBOutlet weak var lblLlegadaGoldUILabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.libre = nil
        webService.obtenerPrimerLibre()
    }
    
    

    @IBAction func salidaRioUibutton(sender: AnyObject) {
        
        // Cargar el estado actual de las barcas
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegateControl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponse_primeraLibre(respuesta: [String : [String : String]]) {
        
        var libres : Dictionary<String, String>
        for (k,v) in respuesta {
            let barca : [String : String] = v
           // libres[v.keys] = v.values
        }
        self.libre = respuesta
        
        //let RIO : Dictionary<String,String> = self.libre["rio"] as [String : String]
        //let libreRIO = self.libre?[""]
        //self.lblLlegadaRioUILabel.text = RIO["Nombre"] + " - " + RIO["libre"]
        
    }
    


}

