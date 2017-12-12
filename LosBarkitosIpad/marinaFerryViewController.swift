//
//  marinaferryViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesús Valladolid Rebollar on 8/12/17.
//  Copyright © 2017 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class Ticket: NSObject {
    
    var numero : Int = 0
    var fecha : String = ""
    var precio : Float = 0.0
    var punto : String = ""
    var particular : Bool = true
    
    func base() -> Float { return Float(precio / 1.21)}
    func iva() -> Float { return Float(precio - base()) }
}

class marinaferryViewController: UIViewController, WebServiceVentasMF {
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var tic = Ticket()
    
    @IBOutlet weak var partGrupView: UIView!
    @IBOutlet weak var partButton: UIButton!
    @IBOutlet weak var gruposButton: UIButton!
    @IBOutlet weak var precioPartView: UIView!
    @IBOutlet weak var precioGruposView: UIView!
    
    @IBAction func partPush(_ sender: UIButton) {
        fadeOut(view: self.precioGruposView)
        fadeIn(view: self.precioPartView)
        partButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        gruposButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func gruposPush(_ sender: UIButton) {
        fadeIn(view: self.precioGruposView)
        fadeOut(view: self.precioPartView)
        gruposButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        partButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func precioGrupoPush(_ sender: UIButton) {
        
        if let precio : Float = Float(sender.titleLabel!.text!) {
            webService.MFinsertar_ticket(precio, part: 1) // Si parametro = 1 es particular
        }
    }
    @IBAction func precioPartPush(_ sender: UIButton) {
        
        /*if let precio : Float = Float(sender.title) {
            webService.MFinsertar_ticket(precio, part: 1) // Si parametro = 1 es particular
            self.contadorParticular += 1
        }*/
    }
    
    ////////////////////////////////////////////////////////////////////////
    
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 1.0, view : UIView) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 1.0, view: UIView) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        })
    }
    /////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.precioPartView.alpha = 0
        self.precioGruposView.alpha = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didReceiveResponse_ventaParticular(_ respuesta: [String : AnyObject]) {
        
    }
    
    func didReceiveResponse_ventaGrupo(_ respuesta: [String : AnyObject]) {
            
            for (k,v) in respuesta {
                if k as String == "error" && v as! Int == 1 {
                    print("ERROR EN EL SERVIDOR")
                } else if k as String == "error" && v as! Int == 0 {
                    
                    self.rellenarTicket(respuesta)
                    self.imprimirTicket()
                }
            }
        
    }
    
 
    func rellenarTicket(_ datos : [String : AnyObject]) {
    
        
        for (k,v) in datos {
            switch k  {
            case "numero"     : tic.numero     = v as! Int
            case "precio"     : tic.precio     = v as! Float
            case "fecha"      : tic.fecha      = v as! String
            case "punto"      : tic.punto      = v as! String
            case "particular" : tic.particular = v as! Bool
            default : break
            }
        }
        
    }
    
    func imprimirTicket() -> Bool? {
        
        if setupImpresora() {
            
            foundPrinters = SMPort.searchPrinter("BT:")! as NSArray
            
            
            let portInfo : PortInfo = foundPrinters.object(at: 0) as! PortInfo
            lastSelectedPortName = portInfo.portName! as NSString
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName! as NSString)
            appDelegate.setPortSettings(arrayPort.object(at: 0) as! NSString)
            let p_portName : NSString = appDelegate.getPortName()
            let p_portSettings : NSString = appDelegate.getPortSettings()
            
            let vend    : String = DataManager().getValueForKey("nombre_vendedor", inFile: "appstate") as! String
            let punto   : String = DataManager().getValueForKey("punto_venta", inFile: "appstate") as! String
            let precio  : Int = Int(self.tic.precio)
            let numero  : Int = self.numeroTicket
            let reserva : Int = self.numeroReserva
            let barca   : String = self.barcaActualString!
            let diccParam : [String : AnyObject] = [
                "numero"      : numero as AnyObject,
                "reserva"     : reserva as AnyObject,
                "punto_venta" : punto as AnyObject,
                "precio"      : precio as AnyObject,
                "barca"       : barca as AnyObject,
                "vendedor"    : vend as AnyObject
            ]
            
            let ticketImpreso : Bool = PrintSampleReceipt3Inch(p_portName, portSettings: p_portSettings, parametro: diccParam)
            
            // Trataré de desconectar el puerto
            
            return ticketImpreso
        } else {
            webService.ajustarNumeroFalloImpresion(self.toTipo!)
            return false
        }
    }
    
}

