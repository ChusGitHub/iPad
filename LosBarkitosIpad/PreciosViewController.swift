 //
//  PreciosViewController.swift
//  LosBarkitosIpad
//
//  Created by chus on 9/12/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit


class PreciosViewController: UIViewController, WebServiceProtocoloPrecio {

    let RIO         = 1
    //let ELECTRICA = 2
    //let WHALY     = 3
    let BARCA       = 2
    let GOLD        = 3

    let listaPrecio : String = DataManager().getValueForKey("lista_precio", inFile: "appstate") as! String
    var toTipo : Int?
    var precio : Int = 0
    
    var barcaActual : Int = -1
    var barcaActualString : String? = nil

    
    var toTipoString : String?
    var webService : webServiceCallAPI = webServiceCallAPI()
    // numero de ticket en BDD
    var numeroTicket : Int = 0
    // numero de reserva
    var numeroReserva : Int = 0
    // ticket si es negro o no
    var negro : Bool = false
    
    /// SE TIENE QUE CAMBIAR CADA VEZ QUE SE ACTUALIZA UN IPAD
    var PUNTO_VENTA : Int = 0
    var PUNTO_VENTA_NOMBRE : String = ""

    var conec : Conectividad = Conectividad()
    var hayConexion : Bool = false

    @IBOutlet weak var cancelarUIButton: UIButton!
    @IBOutlet weak var aceptarUIButton: UIButton!
    @IBOutlet weak var precioUILabel: UILabel!
    @IBOutlet var preciosUIButton : [UIButton] = []
    
    @IBOutlet var coleccionBotonesPrecios: [UIButton]!
    @IBAction func btnPreciosUIButton(sender : UIButton) {
        self.precioUILabel.text = ""
        switch listaPrecio {
        case "1":
            self.precioUILabel.text = "\(sender.tag)"
        case "2":
            self.precioUILabel.text = "\(sender.tag + 5)"
        case "3":
           self.precioUILabel.text = "\(sender.tag + 10)"
        case "4":
           self.precioUILabel.text = "\(sender.tag + 15)"
        case "5":
           self.precioUILabel.text = "\(sender.tag + 20)"
        default:
            self.precioUILabel.text = "\(sender.tag)"
        }
        self.aceptarUIButton.enabled = true
    }
    
    
    @IBAction func bntAceptarPushButton(sender: UIButton) {
        // Se tiene que mirar antes si la impresora esta conectada
        webService.obtenerNumero(Int(self.precioUILabel.text!)!)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webService.delegatePrecio = self
        
       // AQUI HAY QUE RECORRER LOS BOTONES DE LOS PRECIOS PARA PONERLES EL LABEL ADECUADO.
        self.ponerPrecios()
        self.aceptarUIButton.enabled = false

        if IPAD == "MARINAFERRY" {
            self.PUNTO_VENTA = 5
            self.PUNTO_VENTA_NOMBRE = "MarinaFerry 2"
        } else {
            self.PUNTO_VENTA_NOMBRE = "LosBarkitos"
            self.PUNTO_VENTA = 2
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.hayConexion = conec.estaConectado()
        if !self.hayConexion {
                
            let alertaNOInternet = UIAlertController(title: "SIN CONEXIÓN!!!", message: "No hay conexión. Llama al Chus lo antes posible!!!", preferredStyle: UIAlertControllerStyle.Alert)
                
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
            alertaNOInternet.addAction(OkAction)
                
            self.presentViewController(alertaNOInternet, animated: true, completion: {self.dismissViewControllerAnimated(true, completion: nil)})
                
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReveiveResponse_numeroTicket(respuesta: [String : AnyObject]) {
        print("RESPUESTA : \(respuesta)")
        var error : Bool = false
        for (k,v) in respuesta {
            print("k - \(k)")
            print("v - \(v)")
            if k as NSString == "error" && v as! NSString == "si" {
                error = true
                self.dismissViewControllerAnimated(true, completion: {
                
                    let alertaNOInternet = UIAlertController(title: "SIN CONEXIÓN!!!", message: "No hay conexión y no se ha incluido el ticket en el listado. Llama al Chus lo antes posible!!!", preferredStyle: UIAlertControllerStyle.Alert)
                
                    let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                    alertaNOInternet.addAction(OkAction)
                    
                    self.presentViewController(alertaNOInternet, animated: true, completion: nil)
                
                })
            } else {
                if k as NSString == "numero" {
                    self.numeroTicket = v as! Int
                } else if k as NSString == "negro" {
                    if v  as! String == "si" {
                        self.negro = true
                    } else {
                        self.negro = false
                    }
                } else if k == "reservas" {
                    let tmp : [Int] = v as! [Int]
                    //webService.incrementarNumeroReserva(self.toTipo!)
                    webService.obtenerNumeroReserva(self.toTipo!, pv:  self.PUNTO_VENTA)
                    self.numeroReserva = tmp[self.toTipo! - 1]
                }
            }
        }
        if error {
            self.numeroTicket = -1
        }
        self.procesarTicket()
    }
    
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta: [String : AnyObject]) {
        for (k,v) in respuesta {
            if k as NSString == "error" && v as! NSString == "si" {
                //print("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
                if k as NSString == "Tipo Barca" {
                    if v as! NSString == "Barkito" {
                        
                    }
                }
            }
        }
    }

    func didReceiveResponse_reserva(responseObject : [String : AnyObject]) {
        
    }

    // Se ha vendido un ticket de barkito y hay que procesarlo
    // FALTA PONER EL PUNTOVENTA CUANDO SEA IMPLANTADO
    func procesarTicket() {
        // Si se consigue imprimir el ticket se introduce en la BDD, sino da una alerta
        let ticketImpreso = self.imprimirTicket()
        if (ticketImpreso == true) {
            
            // Introducir el ticket vendido en la BDD correspondiente
            // obtengo el vendedor que ha hecho la venta
            let codVend : Int = Int((DataManager().getValueForKey("vendedor", inFile: "appstate") as! String))!
            
        //    let wifi = Reachability.reachabilityForInternetConnection()
          //  wifi.startNotifier()
            
            // Se inserta la venta de la barca en HEROKU
            webService.entradaBDD_ventaBarca(self.numeroTicket,
                                            tipo: self.toTipo!,
                                            precio: Int(self.precioUILabel.text!)!,
                                            puntoVenta: PUNTO_VENTA ,
                                            vendedor: codVend,
                                            negro: self.negro)
            
            var total : Int = (DataManager().getValueForKey("total_barcas", inFile: "appstate")) as! Int
            total += 1
            DataManager().setValueForKey("total_barcas", value: total, inFile: "appstate")
            // Se inserta la venta de la barca en SQLITE
            _ = insertaViajeSQLite() // let insertado =
            //if insertado {
              //  self.numeroBarcasUILabel.text = String(numeroBarcasSQLite())
            //}
            
        } else {
            self.dismissViewControllerAnimated(true, completion: {
                let alertaNOInsercionBDD = UIAlertController(title: "SIN IMPRESORA-NO HAY TICKET", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP) - No se ha insertado en la BDD", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alertaNOInsercionBDD.addAction(OkAction)
                
                self.presentViewController(alertaNOInsercionBDD, animated: true, completion: nil)
                
            })
            
        }
    }
    
    func didReceiveResponse_ajustar_numero_ticket_si_falla_impresion(respuesta: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: {

            let alertaAjustado = UIAlertController(title: "AJUSTADO EL NUMERO DE TIOKET",
                                                   message: "Se ha corregido el numero de ticket",
                                                   preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil)
            alertaAjustado.addAction(okAction)
            
            self.presentViewController(alertaAjustado, animated: true, completion: nil)
        })
    }

    func imprimirTicket() -> Bool? {
        
        if setupImpresora() {
            
            foundPrinters = SMPort.searchPrinter("BT:")
            
            
            let portInfo : PortInfo = foundPrinters.objectAtIndex(0) as! PortInfo
            lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            let p_portName : NSString = appDelegate.getPortName()
            let p_portSettings : NSString = appDelegate.getPortSettings()
            
            let vend    : String = DataManager().getValueForKey("nombre_vendedor", inFile: "appstate") as! String
            let punto   : String = DataManager().getValueForKey("punto_venta", inFile: "appstate") as! String
            let precio  : Int = Int(self.precioUILabel.text!)!
            let numero  : Int = self.numeroTicket
            let reserva : Int = self.numeroReserva
            let barca   : String = self.barcaActualString!
            let diccParam : [String : AnyObject] = [
                "numero"      : numero,
                "reserva"     : reserva,
                "punto_venta" : punto,
                "precio"      : precio,
                "barca"       : barca,
                "vendedor"    : vend
            ]
            
            let ticketImpreso : Bool = PrintSampleReceipt3Inch(p_portName, portSettings: p_portSettings, parametro: diccParam)
            
            // Trataré de desconectar el puerto
            
            return ticketImpreso
        } else {
            webService.ajustarNumeroFalloImpresion(self.toTipo!)
            return false
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "seguePreciosVentaCancelar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            siguienteVC.toPreciosViewController = 0
        }// else if segue.identifier == "seguePreciosVentaAceptar" {
          //  let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
           // siguienteVC.toPreciosViewController = "\(self.precioUILabel.text!)".toInt()!
           // siguienteVC.barcaActual = self.toTipo!
           // siguienteVC.barcaActualString = self.toTipoString!
       // }
        
    }
    
    func ponerPrecios() {
        
        
        //print("listaPrecio : \(listaPrecio)")

        //var boton : UIButton
        for boton in self.preciosUIButton {
            switch listaPrecio {
            case "1":
                boton.setTitle("\(boton.tag)", forState: UIControlState.Normal)
            case "2":
                boton.setTitle("\(boton.tag + 5)", forState: UIControlState.Normal)
            case "3":
                boton.setTitle("\(boton.tag + 10)", forState: UIControlState.Normal)
            case "4":
                boton.setTitle("\(boton.tag + 15)", forState: UIControlState.Normal)
            case "5":
                boton.setTitle("\(boton.tag + 20)", forState: UIControlState.Normal)
            default:
                continue
            }
        }
        
    }

    
    // TRABAJO CON LA BDD SQLITE
    func insertaViajeSQLite() -> Bool {
        
        //let formatoFecha = NSDateFormatter()
        //formatoFecha.dateFormat = "dd-MM-YYYY hh:mm:ss"
        //let fecha = formatoFecha.stringFromDate(NSDate())
        //let result = db.execute("INSERT i", parameters: <#[AnyObject]?#>)
        
        let viaje : Viaje = Viaje()
        let formatoFecha = NSDateFormatter()
        formatoFecha.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let fecha = formatoFecha.stringFromDate(NSDate())
        
        viaje.numero = self.numeroTicket
        viaje.fecha = fecha
        viaje.precio = Int(self.precioUILabel.text!)!
        viaje.barca = self.barcaActual
        viaje.blanco = self.negro
        viaje.vendedor =  Int((DataManager().getValueForKey("vendedor", inFile: "appstate") as! String))!
        viaje.punto_venta = (DataManager().getValueForKey("punto_venta_codigo", inFile: "appstate") as! Int)
        
        let estaInsertadoSQLITE = ManejoSQLITE.instance.insertaViajeSQLITE(viaje)
        return estaInsertadoSQLITE
        
        
    }
    
    func numeroBarcasSQLite() -> Int32 {
        
        return ManejoSQLITE.instance.numeroBarcas() as Int32
    }
    
    
 //   func verificarEstado(reachability : Reachability) {
        
   //     var connectionRequired : Bool = false
     //   self.estado = reachability.currentReachabilityStatus
        
      //  if reachability.isReachable() {
       //     print("conectado")
       // } else {
           
        //    let alertaNOInsercionBDD = UIAlertController(title: "SIN CONEXIÓN", message: " Intenta entrar en los ajustes del sistema y ver si está disponible la red WIFI", preferredStyle: UIAlertControllerStyle.Alert)
            
           // let OkActionHandler = {(accion : UIAlertAction!) -> Void in
             //   self.dismissViewControllerAnimated(true, completion: nil)
            //}
                
            //let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: OkActionHandler)
                
     //       alertaNOInsercionBDD.addAction(OkAction)
                
      //      self.presentViewController(alertaNOInsercionBDD, animated: true, completion: nil)
                
           
            
         
        //}
    //}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
