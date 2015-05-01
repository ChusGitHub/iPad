//
//  ControlViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//
import UIKit

class ControlViewController: UIViewController, WebServiceProtocoloControl, UITableViewDataSource, UITableViewDelegate {
    
    
    let RIO       = 1
    let ELECTRICA = 2
    let WHALY     = 3
    let GOLD      = 4

    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var estado : String?
    
    var libre = [String : [String : String]]()
    var lista = [[String : AnyObject]]()
    
    @IBOutlet weak var lblEstadoUILabel: UILabel!
    @IBOutlet weak var lblLlegadaRioUILabel: UILabel!
    @IBOutlet weak var lblLlegadaElectricaUILabel: UILabel!
    @IBOutlet weak var lblLlegadaWhalyUILabel: UILabel!
    @IBOutlet weak var lblLlegadaGoldUILabel: UILabel!
    
    @IBOutlet weak var listaUITableView: UITableView!
    
    @IBOutlet weak var numeroRiosFueraUILAbel: UILabel!
    
    @IBOutlet weak var numeroElectricasFueraUILabel: UILabel!
    @IBOutlet weak var numeroWhalysFueraUILabel: UILabel!
    @IBOutlet weak var numeroGoldsFueraUILabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.libre = nil
        //webService.obtenerPrimerLibre()
        self.estado = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }
    
    @IBAction func salidaUIButton(sender: AnyObject) {
        
        webService.salidaBarca(sender.tag)
        
    }

    @IBAction func llegadaUIButton(sender: AnyObject) {
        
        webService.llegadaBarca(sender.tag)
        
    }
    
    @IBAction func listaTipoBarcaUIButton(sender: AnyObject) {
        webService.listaReservas(sender.tag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegateControl = self
     //   webService.obtenerPrimerLibre()
        
        self.lblEstadoUILabel.text = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }
    
    func actualizarContadorBarcasFuera() {
        webService.barcasFuera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponse_primeraLibre(respuesta: [String : [String : String]]) {
        
        self.libre = respuesta
        println("\(self.libre)")
        colocarLibresEnPantalla()
    }
    
    func didReceiveResponse_listaLlegadas(respuesta: [String : AnyObject ]) {
        
        self.lista = []
        var registro : [String : String] = [:]
        
        println("lista llegadas : \(respuesta)")
        
        for (k,v) in respuesta {
            println("k = \(k)")
            println("v = \(v)")

            registro["nombre"] = v["Nombre"] as? String
            registro["libre"] = v["libre"] as? String
            registro["tipo"] = v["Tipo"] as? String
            let vueltas : Int = v["vueltas"] as! Int
            registro["vueltas"] = String(vueltas)
            
            self.lista.append(registro)
        }
        println("listaLlegadas : \(self.lista)")
        
        self.listaUITableView.clearsContextBeforeDrawing = true        // limpiar uitableview
        self.listaUITableView.reloadData()
    }

    
    func didReceiveResponse_listaReservas(respuesta: [String : AnyObject]) {
        
        self.lista = []
        var registro : [String : AnyObject] = [:]
        println("Lista reservas : \(respuesta)")
        
        for (k,v) in respuesta {
            registro["numero"] = v["numero"] as! Int
            registro["nombre"] = v["base"] as! String
            registro["hora_prevista"] = v["hora_prevista"] as! String
            registro["hora_reserva"] = v["hora_reserva"] as! String
            registro["fuera"] = v["fuera"] as! Bool
            self.lista.append(registro)
        }
        // ordenacion de las reservas por el numero
    
        self.lista.sort({(primero : [String:AnyObject], segundo : [String:AnyObject]) -> Bool in
                return   segundo["numero"] as! Int > primero["numero"] as! Int
            })
        println(" ORDENADO : \(self.lista)")
        
        self.listaUITableView.clearsContextBeforeDrawing = true
        self.listaUITableView.reloadData()
    }
    
    func didReceiveResponse_salida(respuesta: [String : String]) {
        
        
        if respuesta["error"] == "no es posible" {
            var alerta = UIAlertController(title: "EEEEPPPPPP", message: "No puede salir una barca si no hay disponibles", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
 
        } else {
            let nombre = respuesta["nombre"]!
            var alerta = UIAlertController(title: "SALIDA", message: "Salida de una \(nombre)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)

            self.actualizarContadorBarcasFuera()
        }
        
    }

    func didReceiveResponse_llegada(respuesta: [String : String]) {
        println(respuesta)
        if respuesta["error"] == "1" {
            var alerta = UIAlertController(title: "EEEEPPPPPP", message: "Error en la contabilización de la llegada de la barca", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
        } else {
            let nombre = respuesta["nombre"]!
            var alerta = UIAlertController(title: "LLEGADA", message: "Llegada de una \(nombre)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
            self.actualizarContadorBarcasFuera()
        }
        
    }
    
    func didReceiveResponse_barcasFuera(responseObject : [String : [Int]]) {
        
        let fuera : [Int] = responseObject["fuera"]!
        self.numeroRiosFueraUILAbel.text = String(fuera[0])
        self.numeroElectricasFueraUILabel.text = String(fuera[1])
        self.numeroWhalysFueraUILabel.text = String(fuera[2])
        self.numeroGoldsFueraUILabel.text = String(fuera[3])
    }
    
    
    func colocarLibresEnPantalla() {
        
        let RIO : [String : String]? = self.libre["rio"]
        let ELECTRICA = self.libre["electrica"]
        let WHALY = self.libre["whaly"]
        let GOLD = self.libre["gold"]
        
        let nombreRIO : String? = RIO?["nombre"]
        let libreRIO : String? = RIO?["libre"]
        let nombreELECTRICA : String? = ELECTRICA?["nombre"]
        let libreELECTRICA : String? = ELECTRICA?["libre"]
        let nombreWHALY : String? = WHALY?["nombre"]
        let libreWHALY : String? = WHALY?["libre"]
        let nombreGOLD : String? = GOLD?["nombre"]
        let libreGOLD : String? = GOLD?["libre"]

        self.lblLlegadaRioUILabel.text = nombreRIO! + " - " + libreRIO!
        self.lblLlegadaElectricaUILabel.text = nombreELECTRICA! + " - " + libreELECTRICA!
        self.lblLlegadaWhalyUILabel.text = nombreWHALY! + " - " + libreWHALY!
        self.lblLlegadaGoldUILabel.text = nombreGOLD! + " - " + libreGOLD!

    }
    
    
    
    // IMPLEMENTO LOS METODOS DELEGADOS DE listaUITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.lista.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell : ControlUITableViewCell = self.listaUITableView.dequeueReusableCellWithIdentifier("Cell") as! ControlUITableViewCell
        let numero : Int = self.lista[indexPath.row]["numero"] as! Int
        cell.numeroUILabelUITableViewCell.text = String(numero)
        cell.nombreUILabelUITableViewCell.text = self.lista[indexPath.row]["nombre"] as? String
       // hora  = self.lista[indexPath.row]["hora_prevista"]
        cell.tipoUILabelUITableViewCell.text = self.lista[indexPath.row]["hora_prevista"] as? String
        let fuera : Int = self.lista[indexPath.row]["fuera"] as! Int
        cell.libreUILabelUITableViewCell.text = String(fuera)
        
                
        return cell
        
    }

    
   // func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    //}


}

