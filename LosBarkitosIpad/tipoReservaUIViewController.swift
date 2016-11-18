//
//  tipoReservaUIViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 7/4/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit
var reservas : [Int] = [0,0,0,0]

class tipoReservaUIViewController: UIViewController, WebServiceReserva {
    
    let RESERVA_RIO       = 1
    let RESERVA_ELECTRICA = 2
    let RESERVA_BARCA     = 3
    let RESERVA_GOLD      = 4

    var reservas : [Int] = [0,0,0,0]
    var webService : webServiceCallAPI = webServiceCallAPI()

    // Valor devuelto por el tipoReservaViewController
    var totipoReservaViewControllerTipo : Int = 0
    var totipoReservaViewControllerPV : Int = 0
    var tovueltaReservaViewController : Bool = false
    var tovueltaListadoVentas : Bool = false

    
    @IBOutlet weak var btnRioReservaUIButton: UIButton!
    @IBOutlet weak var btnElectricaReservaUIButton: UIButton!
    @IBOutlet weak var btnWhalyReservaUIButton: UIButton!
    @IBOutlet weak var btnGoldWhalyUIButton: UIButton!
   
    @IBAction func btnRioReservaPushButton(sender: UIButton) {
        self.webService.obtenerNumeroReserva(self.RESERVA_RIO, pv: self.totipoReservaViewControllerPV)
        self.tovueltaReservaViewController = false

    }
 
    @IBAction func btnElectricaReservaPushButton(sender: UIButton) {
        self.webService.obtenerNumeroReserva(self.RESERVA_ELECTRICA, pv: self.totipoReservaViewControllerPV)
        self.tovueltaReservaViewController = false
        
    }
    
    @IBAction func btnGoldReservaPushButton(sender: UIButton) {
        self.webService.obtenerNumeroReserva(self.RESERVA_GOLD, pv: self.totipoReservaViewControllerPV)
        self.tovueltaReservaViewController = false

    }
    
    @IBAction func btnWhalyReservaPushButton(sender: UIButton) {
        self.webService.obtenerNumeroReserva(self.RESERVA_BARCA, pv: self.totipoReservaViewControllerPV)
        self.tovueltaReservaViewController = false

    }
    
    
    @IBAction func cancelarReservaUIButton(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        webService.delegateReserva = self
        
        // Do any additional setup after loading the view.
    }
    
    func didReceiveResponse_reservaPosible(respuesta : [Bool]) {
        
        self.btnRioReservaUIButton.enabled = respuesta[0]
        self.btnElectricaReservaUIButton.enabled = respuesta[1]
        self.btnWhalyReservaUIButton.enabled = respuesta[2]
        self.btnGoldWhalyUIButton.enabled = respuesta[3]
        
    }
    
    func didReceiveResponse_reserva(respuesta : [String : AnyObject]) {
        //print("respuesta del servidor : \(respuesta)")
        //var dicc : [String : AnyObject]
        var PV : String = ""
        var HR : String = ""
        var HP : String = ""
        var tipo : String = ""
        self.reservas = [0,0,0,0]
        for (k,v) in respuesta {
            if k == "PV" {
                PV = v as! String
            }
            if k == "reservas" {
                self.reservas = v as! [Int]
            }
            if k == "hora reserva" {
                HR = v as! String
            }
            if k == "hora prevista" {
                HP = v as! String
            }
            if k == "exito" {
                tipo = v as! String
            }
        }
        imprimirReserva(PV, HR: HR, HP: HP, tipo: tipo)
    }

    
    func didReceiveResponse_incrementada(respuesta : [String : AnyObject]) {
        
    }
    
    
    // Mira si está la impresora conectada:
    // True -> conectada
    // False -> no hay impresora
    func setupImpresora() -> Bool {
        
        foundPrinters = SMPort.searchPrinter("BT:")
        
        if foundPrinters.count > 0 {// Hay impresora conectada
            
            print(foundPrinters.count)
            let portInfo : PortInfo = foundPrinters.objectAtIndex(0) as! PortInfo
            
            lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            //infoImpresoraUILabel.text = portInfo.portName
            
            print("Impresoras: \(foundPrinters.objectAtIndex(0))" )
            return true
        }
        else { // No hay ninguna impresora conectada
            let alertaNoImpresora = UIAlertController(title: "SIN IMPRESORA", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alertaNoImpresora.addAction(OkAction)
            
            self.presentViewController(alertaNoImpresora, animated: true, completion: nil)
            return false
            
        }
        
    }
    
    func imprimirReserva(PV : String, HR : String, HP : String, tipo: String) {
        if setupImpresora() {
            foundPrinters = SMPort.searchPrinter("BT:")
            
            
            var portInfo : PortInfo = foundPrinters.objectAtIndex(0) as! PortInfo
            lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            
            let reservaImpresa : Bool = PrintSampleReceipt3Inch(p_portName, portSettings: p_portSettings, PV: PV, parametro: self.reservas, HR: HR, HP: HP, tipoBarca: tipo)
        } else {
            var alertaNoImpresora = UIAlertController(title: "SIN IMPRESORA", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alertaNoImpresora.addAction(OkAction)
            
            self.presentViewController(alertaNoImpresora, animated: true, completion: nil)

        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func   prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueReservaRio" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            
        } else if segue.identifier == "segueReservaElectrica" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController

            
        } else if segue.identifier == "segueReservaWhaly" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
 

        } else if segue.identifier == "segueReservaGold" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
     
        } else if segue.identifier == "segueReservaCancelar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            
        }
        
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
