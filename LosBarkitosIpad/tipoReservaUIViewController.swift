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
    let RESERVA_BARCA     = 2
    let RESERVA_GOLD      = 3
    
    var conec : Conectividad = Conectividad()
    var hayConexion : Bool = false

    var reservas : [Int] = [0,0,0]
    var webService : webServiceCallAPI = webServiceCallAPI()

    // Valor devuelto por el tipoReservaViewController
    var totipoReservaViewControllerTipo : Int = 0
    var totipoReservaViewControllerPV : Int = 0
    var tovueltaReservaViewController : Bool = false
    var tovueltaListadoVentas : Bool = false

    
    @IBOutlet weak var btnRioReservaUIButton: UIButton!
    @IBOutlet weak var btnElectricaReservaUIButton: UIButton!
    @IBOutlet weak var btnBarcaReservaUIButton: UIButton!
    @IBOutlet weak var btnGoldReservaUIButton: UIButton!
    
    
    @IBAction func btnReservaPushButton(sender : UIButton) {
        self.webService.obtenerNumeroReserva(sender.tag, pv: self.totipoReservaViewControllerPV)
        self.tovueltaReservaViewController = false
    }
    
    @IBAction func cancelarReservaUIButton(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.hayConexion = conec.estaConectado()
        if !self.hayConexion {
            
            let alertaNOInternet = UIAlertController(title: "SIN CONEXIÓN!!!", message: "No puedes sacar reservas. Intenta conectarte a internet o  llama al Chus lo antes posible!!!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in
                self.dismissViewControllerAnimated(true, completion: nil)}
            
            alertaNOInternet.addAction(OkAction)
            
            self.presentViewController(alertaNOInternet, animated: true, completion:nil)
            
        }

    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        webService.delegateReserva = self
        
    }
    
    func didReceiveResponse_reservaPosible(respuesta : [Bool]) {
        
        self.btnRioReservaUIButton.enabled = respuesta[0]
        //self.btnElectricaReservaUIButton.enabled = respuesta[1]
        self.btnBarcaReservaUIButton.enabled = respuesta[1]
        self.btnGoldReservaUIButton.enabled = respuesta[2]
        
    }
    
    func didReceiveResponse_reserva(respuesta : [String : AnyObject]) {
        //print("respuesta del servidor : \(respuesta)")
        //var dicc : [String : AnyObject]
        var PV : String = ""
        var HR : String = ""
        var HP : String = ""
        var tipo : String = ""
        self.reservas = [0,0,0]
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
            
            //print(foundPrinters.count)
            let portInfo : PortInfo = foundPrinters.objectAtIndex(0) as! PortInfo
            
            lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var _ : NSString = appDelegate.getPortName()
            var _ : NSString = appDelegate.getPortSettings()
            //infoImpresoraUILabel.text = portInfo.portName
            
           // print("Impresoras: \(foundPrinters.objectAtIndex(0))" )
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
            
            
            let portInfo : PortInfo = foundPrinters.objectAtIndex(0) as! PortInfo
            lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            let p_portName : NSString = appDelegate.getPortName()
            let p_portSettings : NSString = appDelegate.getPortSettings()
            
            let _ : Bool = PrintSampleReceipt3Inch(p_portName, portSettings: p_portSettings, PV: PV, parametro: self.reservas, HR: HR, HP: HP, tipoBarca: tipo)
        } else {
            let alertaNoImpresora = UIAlertController(title: "SIN IMPRESORA", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP)", preferredStyle: UIAlertControllerStyle.Alert)
            
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
           let _ : VentaViewController = segue.destinationViewController as! VentaViewController
            
        } else if segue.identifier == "segueReservaElectrica" {
            let _ : VentaViewController = segue.destinationViewController as! VentaViewController

            
        } else if segue.identifier == "segueReservaBarca" {
            let _ : VentaViewController = segue.destinationViewController as! VentaViewController
 

        } else if segue.identifier == "segueReservaGold" {
            let _ : VentaViewController = segue.destinationViewController as! VentaViewController
     
        } else if segue.identifier == "segueReservaCancelar" {
            let _ : VentaViewController = segue.destinationViewController as! VentaViewController
            
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
